import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/workout.dart';
import '../models/exercise.dart';

class WorkoutsProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  List<Workout> _workouts = [];
  List<Exercise> _exercises = [];

  String _trainerId;

  List<Workout> get workouts {
    return [..._workouts];
  }

  List<Exercise> get exercises {
    return [..._exercises];
  }

  int get numberOfWorkouts {
    return _workouts.length;
  }

  List<Workout> get recentWorkouts {
    if (_workouts.length >= 4) {
      return [_workouts[0], _workouts[1], _workouts[2]];
    } else {
      return [];
    }
  }

  Workout findById(String id) {
    return _workouts.firstWhere((workout) => workout.id == id);
  }

  Future<void> fetchWorkouts(String trainerId) async {
    _trainerId = trainerId;
    var result = await _db
        .collection('trainers')
        .document(trainerId)
        .collection('workouts')
        .getDocuments();
    final List<Workout> loadedWorkouts = result.documents
        .map((workout) => Workout.fromSnapshot(workout))
        .toList();

    _workouts = loadedWorkouts;
    notifyListeners();
  }

  Future<void> fetchExercises(String workoutId) async {
    var result = await _db
        .collection('trainers')
        .document(_trainerId)
        .collection('workouts')
        .document(workoutId)
        .collection('exercises')
        .getDocuments();
    final List<Exercise> loadedExercises = result.documents
        .map((exercise) => Exercise.fromSnapshot(exercise))
        .toList();

    _exercises = loadedExercises;
    notifyListeners();
  }
}
