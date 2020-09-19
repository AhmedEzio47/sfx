import 'package:flutter/services.dart';

class Question {
  ByteData voice;
  String answer;
  List<String> choices;
  Question({this.voice, this.answer, this.choices});
}
