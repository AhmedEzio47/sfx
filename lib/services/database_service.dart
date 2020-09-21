import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sfx/constants/contants.dart';
import 'package:sfx/models/character_model.dart';
import 'package:sfx/models/saying.dart';

class DatabaseService {
  static getCharacters() async {
    QuerySnapshot charactersSnapshot =
        await charactersRef.orderBy('timestamp').getDocuments();
    List<Character> characters = charactersSnapshot.documents
        .map((doc) => Character.fromDoc(doc))
        .toList();
    return characters;
  }

  static getCharacterSayings(String characterId) async {
    QuerySnapshot sayingsSnapshot = await charactersRef
        .document(characterId)
        .collection('sayings')
        .orderBy('timestamp')
        .getDocuments();
    List<Saying> sayings =
        sayingsSnapshot.documents.map((doc) => Saying.fromDoc(doc)).toList();
    return sayings;
  }
}
