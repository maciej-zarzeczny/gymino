import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/workout.dart';
import '../models/exercise.dart';

class WorkoutsProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  final int _workoutsLimit = 5;

  DocumentSnapshot _lastDocument;
  bool _allWorkoutsLoaded = false;

  List<Workout> _loadedWorkouts = [];
  List<Workout> _workouts = [];
  List<Exercise> _exercises = [];

  String _trainerId = '';

  String get currentTrainerId {
    return _trainerId;
  }

  List<Workout> get workouts {
    return [..._workouts];
  }

  List<Exercise> get exercises {
    return [..._exercises];
  }

  int get numberOfWorkouts {
    return _workouts.length;
  }

  bool get allWorkoutsLoaded {
    return _allWorkoutsLoaded;
  }

  // TODO: Change to return last 4 workouts based on timestamps
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
        .orderBy('name')
        .limit(_workoutsLimit)
        .getDocuments();

    if (result.documents.length > 0) {
      _lastDocument = result.documents[result.documents.length - 1];
      _loadedWorkouts = result.documents
          .map((workout) => Workout.fromSnapshot(workout))
          .toList();

      _workouts = _loadedWorkouts;
    } else {
      _workouts = [];
    }
    if (result.documents.length < _workoutsLimit) {
      _allWorkoutsLoaded = true;
    }

    notifyListeners();
  }

  Future<void> fetchMoreWorkouts() async {
    var result = await _db
        .collection('trainers')
        .document(_trainerId)
        .collection('workouts')
        .orderBy('name')
        .startAfterDocument(_lastDocument)
        .limit(_workoutsLimit)
        .getDocuments();

    if (result.documents.length > 0) {
      _lastDocument = result.documents[result.documents.length - 1];
      _loadedWorkouts = result.documents
          .map((workout) => Workout.fromSnapshot(workout))
          .toList();

      _workouts.addAll(_loadedWorkouts);
    }
    if (result.documents.length < _workoutsLimit) {
      _allWorkoutsLoaded = true;
    }
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

  Future<void> fetchExercisesData() async {
    var futures = <Future>[];
    for (int i = 0; i < _exercises.length; i++) {
      futures
          .add(_db.document('exercises/${_exercises[i].id}').get().then((data) {
        _exercises[i].setExerciseData(
            data['name'],
            data['description'],
            data['instructions'],
            data['imageUrl'],
            data['keywords'],
            data['bulletPoints']);
      }));
    }

    await Future.wait(futures);
    notifyListeners();
  }
}
