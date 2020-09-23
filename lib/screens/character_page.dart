import 'dart:typed_data';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sfx/app_util.dart';
import 'package:sfx/constants/data.dart';
import 'package:sfx/models/character_model.dart';
import 'package:sfx/models/saying.dart';
import 'package:sfx/services/database_service.dart';
import 'package:sfx/services/permissions_service.dart';

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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPermissionGranted = false;

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
            key: _scaffoldKey,
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
                        crossAxisCount: 2, childAspectRatio: 10 / 3),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(0),
                                    topLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                color: Colors.blue,
                                child: Text(
                                  _sayings[index]?.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _sayings[index] == null
                                      ? null
                                      : Audio.loadFromRemoteUrl(
                                          _sayings[index].voice,
                                          onComplete: () => setState(
                                              () => --_spawnedAudioCount))
                                    ..play()
                                    ..dispose();
                                  setState(() => ++_spawnedAudioCount);
                                },
                              ),
                              flex: 7,
                            ),
                            Expanded(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(0),
                                    topLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                color: Colors.blue,
                                child: Icon(
                                  Icons.file_download,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  if (await PermissionsService()
                                      .hasStoragePermission()) {
                                    setState(() {
                                      isPermissionGranted = true;
                                    });
                                  } else {
                                    bool isGranted = await PermissionsService()
                                        .requestStoragePermission(
                                            onPermissionDenied: () {
                                      AppUtil.alertDialog(
                                          context,
                                          'info',
                                          'You must grant this storage access to be able to use this feature.',
                                          'OK');
                                      print('Permission has been denied');
                                    });
                                    setState(() {
                                      isPermissionGranted = isGranted;
                                    });
                                    return;
                                  }

                                  if (isPermissionGranted) {
                                    await AppUtil.downloadFile(
                                        _sayings[index].voice,
                                        _sayings[index]?.text);
                                    AppUtil.showSnackBar(
                                        context, _scaffoldKey, 'Downloaded!');
                                  } else {}
                                },
                              ),
                              flex: 3,
                            )
                          ],
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
