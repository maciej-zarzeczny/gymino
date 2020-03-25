import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  final List<dynamic> sets;
  final int rest;
  final int setRest;
  final String name;
  final String image;
  final bool withWeight;

  Exercise({
    this.id,
    this.sets,
    this.rest,
    this.setRest,
    this.name,
    this.image,
    this.withWeight,
  });

  factory Exercise.fromMap(Map<dynamic, dynamic> data) {
    return Exercise(
      id: data['id'] ?? '',
      sets: data['sets'] ?? 0,
      rest: data['rest'] ?? 0,
      setRest: data['setRest'] ?? 0,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      withWeight: data['withWeight'] ?? false
    );
  }
}

class ExerciseData {
  String id;
  String name;
  String description;  
  String imageUrl;
  List<dynamic> keywords;
  List<dynamic> bulletPoints;

  ExerciseData({
    this.id,
    this.name,
    this.description,    
    this.imageUrl,
    this.keywords,
    this.bulletPoints,
  });

  factory ExerciseData.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;

    return ExerciseData(
      id: doc.documentID,
      name: data['name'] ?? '',
      description: data['description'] ?? '',      
      imageUrl: data['image'] ?? '',
      keywords: data['keywords'] ?? [],
      bulletPoints: data['bulletPoints'] ?? [],
    );
  }
}
