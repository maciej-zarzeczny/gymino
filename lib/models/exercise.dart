import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;  
  final List<dynamic> sets;
  final int rest;
  final int setRest;

  String name;
  String description;
  String instructions;
  String imageUrl;  
  List<dynamic> keywords;
  List<dynamic> bulletPoints;

  Exercise({
    this.id,
    this.sets,
    this.rest,
    this.setRest,
  });

  void setExerciseData(String name, String description, String instructions, String imageUrl, List<dynamic> keywords, List<dynamic> bulletPoints) {
    this.name = name;
    this.description = description;
    this.instructions = instructions;
    this.imageUrl = imageUrl;
    this.keywords = keywords;
    this.bulletPoints = bulletPoints;
  }

  factory Exercise.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;        

    return Exercise(
      id: doc.documentID ?? '',
      sets: data['sets'],
      rest: data['rest'] ?? 0,
      setRest: data['setRest'] ?? 0,
    );
  }
}
