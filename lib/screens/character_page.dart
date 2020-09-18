import 'dart:typed_data';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sfx/constants/data.dart';
import 'package:sfx/models/character_model.dart';
import 'package:sfx/models/saying.dart';

class CharacterPage extends StatefulWidget {
  final Character character;

  const CharacterPage({Key key, this.character}) : super(key: key);

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  int _spawnedAudioCount = 0;
  List<ByteData> _sayings = List<ByteData>();

  void _loadAudioByteData() async {
    for (Saying saying in widget.character.sayings) {
      ByteData sayingByteData = await rootBundle.load(saying.voice);
      _sayings.add(sayingByteData);
    }
  }

  @override
  void initState() {
    _loadAudioByteData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Image.asset(
              widget.character.image,
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(widget.character.name),
          Container(
            height: 200,
            child: GridView.builder(
              itemCount: widget.character.sayings.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 8 / 3),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      widget.character.sayings[index].text,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _sayings[index] == null
                          ? null
                          : Audio.loadFromByteData(_sayings[index],
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
    );
  }
}
