import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sfx/constants/data.dart';
import 'package:sfx/models/character_model.dart';
import 'package:sfx/widgets/drawer.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  Map<String, ByteData> _voices = Map<String, ByteData>();
  int _spawnedAudioCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Main'),
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Icon(const IconData(58311, fontFamily: 'MaterialIcons')),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        itemCount: characters.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return item(character: characters[index]);
        },
      ),
      drawer: BuildDrawer(),
    );
  }

  @override
  void initState() {
    _loadAudioByteData();
    super.initState();
  }

  void _loadAudioByteData() async {
    for (Character character in characters) {
      ByteData voice = await rootBundle.load(character.voice);
      _voices.putIfAbsent(character.voice, () => voice);
    }
  }

  item({Color backColor = Colors.white, Character character}) {
    return GestureDetector(
      onTap: () {
        _voices[character.voice] == null
            ? null
            : Audio.loadFromByteData(_voices[character.voice],
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
            child: Image.asset(
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
