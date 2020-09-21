import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sfx/constants/data.dart';
import 'package:sfx/models/character_model.dart';
import 'package:sfx/services/database_service.dart';
import 'package:sfx/widgets/drawer.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _spawnedAudioCount = 0;
  bool _pageReady = false;

  @override
  Widget build(BuildContext context) {
    return _pageReady
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Main'),
              leading: Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Icon(
                        const IconData(58311, fontFamily: 'MaterialIcons')),
                  ),
                ),
              ),
            ),
            body: GridView.builder(
              itemCount: Data.characters.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return item(character: Data.characters[index]);
              },
            ),
            drawer: BuildDrawer(),
          )
        : Scaffold(
            body: Center(
              child: Text('Loading...'),
            ),
          );
  }

  @override
  void initState() {
    getCharacters();
    super.initState();
  }

  getCharacters() async {
    Data.characters = await DatabaseService.getCharacters();
    setState(() {
      _pageReady = true;
    });
  }

  item({Color backColor = Colors.white, Character character}) {
    return GestureDetector(
      onTap: () {
        character.voice == null
            ? null
            : Audio.loadFromRemoteUrl(character.voice,
                onComplete: () => setState(() => --_spawnedAudioCount))
          ..play()
          ..dispose();
        setState(() => ++_spawnedAudioCount);
        Navigator.of(context)
            .pushNamed('/character', arguments: {'character': character});
      },
      child: Column(
        children: [
          Container(
            height: 150,
            child: Image.network(
              character.image,
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(character.name)
        ],
      ),
    );
  }
}
