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
      sayings: [
        Saying(
            text: 'Let\'s do this!',
            voice: 'assets/sounds/shelly/Let\'s do this!.mp3'),
        Saying(
            text: 'Let\'s go!', voice: 'assets/sounds/shelly/Let\'s go!.mp3'),
        Saying(
            text: 'Asi me gusta!',
            voice: 'assets/sounds/shelly/Asi me gusta!.mp3'),
      ]),
  Character(
      name: 'El Primo',
      image: 'assets/images/elprimo.png',
      voice: 'assets/sounds/elprimo.mp3',
      sayings: [
        Saying(text: 'Vamanos!', voice: 'assets/sounds/elprimo/Vamanos!.mp3'),
        Saying(
            text: 'For pain and for glory!',
            voice: 'assets/sounds/elprimo/For pain and for glory!.mp3'),
        Saying(
            text: 'El campeon!',
            voice: 'assets/sounds/elprimo/El campeon!.mp3'),
      ]),
  Character(
      name: 'Bull',
      image: 'assets/images/bull.png',
      voice: 'assets/sounds/bull.mp3',
      sayings: [
        Saying(
            text: 'No I\'m in charge!',
            voice: 'assets/sounds/bull/No I\'m in charge!.mp3'),
        Saying(
            text: 'Don\'t miss with the Bull!',
            voice: 'assets/sounds/bull/Don\'t miss with the Bull!.mp3'),
        Saying(
            text: 'Angry Bull!', voice: 'assets/sounds/bull/Angry Bull!.mp3'),
      ]),
];
