import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final List<dynamic> sets;
  final int rest;
  final int setRest;

  Exercise({
    this.id,
    this.name,
    this.description,
    this.sets,
    this.rest,
    this.setRest,
  });

  factory Exercise.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;        

    return Exercise(
      id: doc.documentID ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      sets: data['sets'],
      rest: data['rest'],
      setRest: data['setRest'],
    );
  }
}
