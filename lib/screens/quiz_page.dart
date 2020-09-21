import 'dart:math';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sfx/constants/data.dart';
import 'package:sfx/models/character_model.dart';
import 'package:sfx/models/question_model.dart';
import 'package:sfx/models/saying.dart';
import 'package:sfx/services/database_service.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> _questions = [];
  int _questionsCount = 2;
  int _currentQuestion = 0;
  int _spawnedAudioCount = 0;
  int _score = 0;
  bool _pageReady = false;

  @override
  void initState() {
    _getAllSayings();
    super.initState();
  }

  _getAllSayings() async {
    for (Character char in Data.characters) {
      if (!Data.sayings.containsKey(char.id)) {
        List<Saying> sayings =
            await DatabaseService.getCharacterSayings(char.id);
        Data.sayings.putIfAbsent(char.id, () => sayings);
      }
    }

    _createQuestions();
    setState(() {
      _pageReady = true;
    });
  }

  _createQuestions() {
    Random random = Random();
    for (int i = 0; i < _questionsCount; i++) {
      int randomCharacter = random.nextInt(Data.characters.length);

      int randomSaying = random
          .nextInt(Data.sayings[Data.characters[randomCharacter].id].length);

      String sayingVoice =
          Data.sayings[Data.characters[randomCharacter].id][randomSaying].voice;

      Question question = Question(
          voice: sayingVoice, answer: Data.characters[randomCharacter].name);

      if (_questions.length > 0) {
        while (_questions.contains(question)) {
          randomSaying = random.nextInt(
              Data.sayings[Data.characters[randomCharacter].id].length);

          String sayingVoice = Data
              .sayings[Data.characters[randomCharacter].id][randomSaying].voice;

          question = Question(
              voice: sayingVoice,
              answer: Data.characters[randomCharacter].name);
        }
      }
      setState(() {
        _questions.add(question);
      });
    }

    for (int i = 0; i < _questionsCount; i++) {
      List<String> choices = [];
      for (int i = 0; i < 4; i++) {
        int randomCharacter = random.nextInt(Data.characters.length);
        String answer = Data.characters[randomCharacter].name;
        while (choices.contains(answer)) {
          randomCharacter = random.nextInt(Data.characters.length);
          answer = Data.characters[randomCharacter].name;
        }
        choices.add(answer);
      }
      setState(() {
        _questions[i].choices = choices;
      });
    }

    playCurrentQuestion();
  }

  playCurrentQuestion() {
    _questions[_currentQuestion].voice == null
        ? null
        : Audio.loadFromRemoteUrl(_questions[_currentQuestion].voice,
            onComplete: () => setState(() => --_spawnedAudioCount))
      ..play()
      ..dispose();
    setState(() => ++_spawnedAudioCount);
  }

  @override
  Widget build(BuildContext context) {
    return _pageReady
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Quiz'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${_currentQuestion + 1}/$_questionsCount',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Container(
                  height: 200,
                  child: IconButton(
                    onPressed: () {
                      playCurrentQuestion();
                    },
                    icon: Icon(
                      Icons.play_circle_filled,
                      color: Colors.blue,
                      size: 50,
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 8 / 3),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              _questions[_currentQuestion].choices[index],
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              bool isCorrect =
                                  _questions[_currentQuestion].choices[index] ==
                                      _questions[_currentQuestion].answer;

                              if (isCorrect) _score++;

                              if (_currentQuestion + 1 == _questionsCount) {
                                AwesomeDialog(
                                  dismissOnTouchOutside: false,
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.NO_HEADER,
                                  body: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24.0),
                                      child: Text(
                                        'Your score: $_score',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  btnCancelText: 'Restart',
                                  btnCancelOnPress: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/quiz');
                                  },
                                  btnOkText: 'Done',
                                  btnOkOnPress: () {
                                    Navigator.of(context).pop(false);
                                    Navigator.of(context).pop();
                                  },
                                )..show();
                              } else {
                                AwesomeDialog(
                                  dismissOnTouchOutside: false,
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: isCorrect
                                      ? DialogType.SUCCES
                                      : DialogType.ERROR,
                                  body: Center(
                                    child: Text(
                                      isCorrect
                                          ? 'Correct answer!'
                                          : 'Wrong answer!',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  btnOkText: 'Next',
                                  btnOkOnPress: () {
                                    nextQuestion();
                                  },
                                )..show();
                              }
                            },
                          ),
                        );
                      }),
                )
              ],
            ))
        : Scaffold(
            body: Center(
              child: Text('Loading...'),
            ),
          );
  }

  nextQuestion() {
    setState(() {
      _currentQuestion++;
    });
    playCurrentQuestion();
  }
}
