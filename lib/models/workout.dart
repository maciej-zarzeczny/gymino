import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './exercise.dart';

class Workout {
  final String id;
  final String name;
  final String imageUrl;
  final int duration;
  final int difficulty;
  final List<dynamic> keywords;
  final List<dynamic> exercises;
  final bool isPremium;
  final String description;

  Workout({
    this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.duration,
    @required this.difficulty,
    @required this.keywords,
    this.exercises,
    this.isPremium,
    this.description,
  });

  factory Workout.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;

    return Workout(
      id: doc.documentID ?? '',
      name: data['name'] ?? '',
      imageUrl: data['image'] ?? '',
      duration: data['duration'] ?? 0,
      difficulty: data['difficulty'] ?? 1,
      keywords: data['keywords'] ?? [],
      exercises: data['exercises'] ?? [],
      isPremium: data['isPremium'] ?? false,
      description: data['description'] ?? '',
    );
  }

  List<Exercise> getExercises() {
    List<Exercise> loadedExercises =
        exercises.map((exercise) => Exercise.fromMap(exercise)).toList();

    return loadedExercises;
  }
}

class FinishedWorkout {
  final String id;
  final String name;
  final Timestamp date;
  final String imageUrl;
  final List<dynamic> exercises;

  FinishedWorkout({
    this.id,
    this.name,
    this.date,
    this.imageUrl,
    this.exercises,
  });

  factory FinishedWorkout.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;

    return FinishedWorkout(
      id: doc.documentID ?? '',
      name: data['name'] ?? '',
      date: data['date'],
      imageUrl: data['imageUrl'] ?? '',
      exercises: data['exercises'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'date': date,
    'imageUrl': imageUrl,
    'exercises': exercises,
  };
}

class SavedWorkout {
  final String id;
  final String name;
  final String imageUrl;  
  final String trainerId;
  final int difficulty;
  final int duration;   

  SavedWorkout({
    this.id,
    this.name,
    this.imageUrl,
    this.trainerId,
    this.difficulty,
    this.duration,    
  });

  factory SavedWorkout.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;

    return SavedWorkout(
      id: doc.documentID ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      trainerId: data['trainerId'] ?? '',
      difficulty: data['difficulty'] ?? 0,
      duration: data['duration'] ?? 0,      
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'imageUrl': imageUrl,
    'trainerId': trainerId,
    'difficulty': difficulty,
    'duration': duration,
    'createdAt': Timestamp.now(),
  };
}
