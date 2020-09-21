import 'package:cloud_firestore/cloud_firestore.dart';

class Character {
  final String id;
  final String name;
  final String voice;
  final String image;
  final dynamic timestamp;
  Character({this.id, this.name, this.voice, this.image, this.timestamp});
  factory Character.fromDoc(DocumentSnapshot doc) {
    return Character(
        id: doc.documentID,
        name: doc['name'],
        voice: doc['voice'],
        image: doc['image'],
        timestamp: doc['timestamp']);
  }
}
