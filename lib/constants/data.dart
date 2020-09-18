import 'package:sfx/models/character_model.dart';
import 'package:sfx/models/saying.dart';

List<Character> characters = [
  Character(
      name: 'Colt',
      image: 'assets/images/colt.png',
      voice: 'assets/sounds/colt.mp3',
      sayings: [
        Saying(
            text: 'Check out my guns, ha ha ha!',
            voice: 'assets/sounds/colt/Check out my guns, ha ha ha!.mp3'),
        Saying(
            text: 'Too pretty for pain!',
            voice: 'assets/sounds/colt/Too pretty for pain!.mp3'),
        Saying(
            text: 'This is too easy!',
            voice: 'assets/sounds/colt/This is too easy!.mp3'),
      ]),
  Character(
    name: 'Shelly',
    image: 'assets/images/shelly.png',
    voice: 'assets/sounds/shelly.mp3',
  )
];
