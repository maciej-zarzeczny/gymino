import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final List<dynamic> sets;

  Exercise({
    this.id,
    this.name,
    this.description,
    this.sets,
  });

  factory Exercise.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;        

    return Exercise(
      id: doc.documentID ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      sets: data['sets'],
    );
  }
}
