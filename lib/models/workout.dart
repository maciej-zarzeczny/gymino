import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  final String id;
  final String name;
  final String imageUrl;
  final int duration;
  final String difficulty;
  final Map<dynamic, dynamic> keywords;

  Workout({
    this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.duration,
    @required this.difficulty,
    @required this.keywords,
  });

  factory Workout.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;

    String difficultyToString(int number) {
      if (number == 0) return 'POCZĄTKUJĄCY';
      else if (number == 1) return 'ŚREDNI';
      else return 'ZAAWANSOWANY';
    }

    return Workout(
      id: doc.documentID ?? '',
      name: data['name'] ?? '',
      imageUrl: data['image_url'] ?? '',
      duration: data['duration'] ?? 0,
      difficulty: difficultyToString(data['difficulty']),
      keywords: data['keywords'],
    );
  }
}
