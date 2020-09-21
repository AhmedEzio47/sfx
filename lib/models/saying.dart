import 'package:cloud_firestore/cloud_firestore.dart';

class Saying {
  final String id;
  final String text;
  final String voice;
  final dynamic timestamp;

  Saying({this.id, this.text, this.voice, this.timestamp});

  factory Saying.fromDoc(DocumentSnapshot doc) {
    return Saying(
        id: doc.documentID,
        text: doc['text'],
        voice: doc['voice'],
        timestamp: doc['timestamp']);
  }
}
