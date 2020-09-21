import 'package:flutter/services.dart';

class Question {
  String voice;
  String answer;
  List<String> choices;
  Question({this.voice, this.answer, this.choices});
}
