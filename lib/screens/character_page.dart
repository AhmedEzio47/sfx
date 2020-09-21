import 'dart:typed_data';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sfx/constants/data.dart';
import 'package:sfx/models/character_model.dart';
import 'package:sfx/models/saying.dart';
import 'package:sfx/services/database_service.dart';

class CharacterPage extends StatefulWidget {
  final Character character;

  const CharacterPage({Key key, this.character}) : super(key: key);

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  int _spawnedAudioCount = 0;
  List<Saying> _sayings = [];
  bool _pageReady = false;

  getCharacterSayings() async {
    if (!Data.sayings.containsKey(widget.character.id)) {
      List<Saying> sayings =
          await DatabaseService.getCharacterSayings(widget.character.id);
      Data.sayings.putIfAbsent(widget.character.id, () => sayings);
      setState(() {
        _sayings = sayings;
      });
    } else {
      setState(() {
        _sayings = Data.sayings[widget.character.id];
      });
    }

    setState(() {
      _pageReady = true;
    });
  }

  @override
  void initState() {
    getCharacterSayings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _pageReady
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(widget.character.name),
              leading: Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 200,
                  child: Image.network(
                    widget.character.image,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Text(widget.character.name),
                Container(
                  height: 200,
                  child: GridView.builder(
                    itemCount: _sayings.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 8 / 3),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            _sayings[index]?.text,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _sayings[index] == null
                                ? null
                                : Audio.loadFromRemoteUrl(_sayings[index].voice,
                                    onComplete: () =>
                                        setState(() => --_spawnedAudioCount))
                              ..play()
                              ..dispose();
                            setState(() => ++_spawnedAudioCount);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            body: Center(
              child: Text('Loading...'),
            ),
          );
  }
}
