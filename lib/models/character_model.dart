import 'package:sfx/models/saying.dart';

class Character {
  String name;
  String voice;
  String image;
  List<Saying> sayings;
  Character({this.name, this.voice, this.image, this.sayings});
}
