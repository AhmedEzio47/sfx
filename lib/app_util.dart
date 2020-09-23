import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'services/permissions_service.dart';

class AppUtil {
  static downloadFile(String url, String name) async {
    var response = await get(url);
    var firstPath = '/sdcard/download/';
    var contentDisposition = response.headers['content-disposition'];
    String fileName = contentDisposition
        .split('filename*=utf-8')
        .last
        .replaceAll(RegExp('%20'), ' ')
        .replaceAll(RegExp('%2C|\''), '');
    var filePathAndName = firstPath + fileName;
    File file2 = new File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
  }

  static alertDialog(
      BuildContext context, String heading, String message, String okBtn) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(heading),
            content: Text(message),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(okBtn),
              )
            ],
          );
        });
  }

  static Future chooseImage({ImageSource source = ImageSource.gallery}) async {
    File image = await ImagePicker.pickImage(source: source, imageQuality: 80);
    print('File size: ${image.lengthSync()}');
    return image;
  }

  static Future chooseAudio() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'mp3',
      'wav',
    ]);

    if (result != null) {
      File file = File(result.files.single.path);
      return file;
    }

    return null;
  }

  static Future uploadFile(File file, BuildContext context, String path,
      {List<String> groupMembersIds}) async {
    if (file == null) return;

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(path);
    print('storage path: $path');
    StorageUploadTask uploadTask;

    uploadTask = storageReference.putFile(file);

    await uploadTask.onComplete;
    print('File Uploaded');
    String url = await storageReference.getDownloadURL();

    return url;
  }

  static void showSnackBar(BuildContext context,
      GlobalKey<ScaffoldState> _scaffoldKey, String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }
}
