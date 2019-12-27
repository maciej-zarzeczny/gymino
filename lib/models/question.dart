import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String question;
  final String answer;

  Question({
    this.id,
    this.question,
    this.answer,
  });

  factory Question.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;    

    return Question(
      id: doc.documentID ?? '',
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
    );
  }
}
