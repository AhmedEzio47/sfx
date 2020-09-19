import 'package:flutter/material.dart';
import 'package:sfx/screens/character_page.dart';
import 'package:sfx/screens/quiz_page.dart';
import 'package:sfx/screens/root.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final Map args = settings.arguments as Map;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => RootPage());

      case '/character':
        return MaterialPageRoute(
            builder: (_) => CharacterPage(character: args['character']));

      case '/quiz':
        return MaterialPageRoute(builder: (_) => QuizPage());

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
