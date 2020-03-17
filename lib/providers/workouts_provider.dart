import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/workout.dart';
import '../models/exercise.dart';

class WorkoutsProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  final int workoutsLimit = 5;
  final int _recommendedWorkoutsLimit = 3;

  DocumentSnapshot _lastDocument;
  bool _allWorkoutsLoaded = false;
  bool _fromSavedWorkouts = false;

  List<Workout> _loadedWorkouts = [];
  Map<String, List<Workout>> _workouts = new Map();
  Map<String, List<Workout>> _recommendedWorkouts = new Map();
  List<ExerciseData> _exerciseData = [];

  String _trainerId = '';

  set currentTrainerId(id) {
    _trainerId = id;
  }

  set fromSavedWorkouts(value) {
    _fromSavedWorkouts = value;
  }

  void removeRecommendedWorkouts() {
    _recommendedWorkouts[_trainerId] = [];
  }

  bool get fromSavedWorkouts {
    return _fromSavedWorkouts;
  }

  String get currentTrainerId {
    return _trainerId;
  }

  List<Workout> get workouts {
    return _workouts[_trainerId];
  }

  List<Workout> get recommendedWorkouts {
    if (_recommendedWorkouts[_trainerId] != null) {
      return _recommendedWorkouts[_trainerId];
    } else {
      return [];
    }
  }

  int get numberOfWorkouts {
    return _workouts[_trainerId].length;
  }

  bool get allWorkoutsLoaded {
    return _allWorkoutsLoaded;
  }

  Workout findById(String id) {
    Workout workout;
    bool error = false;
    try {
      workout = _workouts[_trainerId].firstWhere((workout) => workout.id == id);
    } catch (e) {
      error = true;
    }

    if (workout == null) {
      try {
        workout = _recommendedWorkouts[_trainerId].firstWhere((workout) => workout.id == id);
        error = false;
      } catch (e) {
        error = true;
      }
    }

    if (!error) {
      return workout;
    } else {
      return null;
    }
  }

  dynamic findExerciseById(String id) {
    ExerciseData exerciseData;
    try {
      exerciseData = _exerciseData.firstWhere((exercise) => exercise.id == id);
      return exerciseData;
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchWorkoutById(String id) async {
    var result = await _db.collection('trainers').document(_trainerId).collection('workouts').document(id).get();
    if (result != null) {
      _fromSavedWorkouts = true;
      print('Read: 1');
      if (_workouts[_trainerId] == null) {
        _workouts[_trainerId] = [(Workout.fromSnapshot(result))];
      } else {
        _workouts[_trainerId].add(Workout.fromSnapshot(result));
      }
    }
    notifyListeners();
  }

  Future<void> fetchWorkouts(int experienceLevel) async {
    _allWorkoutsLoaded = false;
    _fromSavedWorkouts = false;

    QuerySnapshot result = await _db
        .collection('trainers')
        .document(_trainerId)
        .collection('workouts')
        .orderBy('createdAt', descending: true)
        .limit(workoutsLimit)
        .getDocuments();

    if (result.documents.length > 0) {
      print('Read: ${result.documents.length}');
      _lastDocument = result.documents[result.documents.length - 1];

      _workouts[_trainerId] = result.documents.map((workout) => Workout.fromSnapshot(workout)).toList();
    } else {
      _workouts[_trainerId] = [];
    }
    if (result.documents.length < workoutsLimit) {
      _allWorkoutsLoaded = true;
    }

    if (result.documents.length > 4) {
      QuerySnapshot recommendedResult = await _db
          .collection('trainers')
          .document(_trainerId)
          .collection('workouts')
          .where('difficulty', isEqualTo: experienceLevel)
          .orderBy('createdAt', descending: true)
          .limit(_recommendedWorkoutsLimit)
          .getDocuments();

      if (recommendedResult.documents.length > 0) {
        print('Read: ${recommendedResult.documents.length}');
        _recommendedWorkouts[_trainerId] = recommendedResult.documents.map((workout) => Workout.fromSnapshot(workout)).toList();
      }
    }

    notifyListeners();
  }

  Future<void> fetchMoreWorkouts() async {
    _fromSavedWorkouts = false;
    var result = await _db
        .collection('trainers')
        .document(_trainerId)
        .collection('workouts')
        .orderBy('createdAt', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(workoutsLimit)
        .getDocuments();

    if (result.documents.length > 0) {
      print('Read: ${result.documents.length}');
      _lastDocument = result.documents[result.documents.length - 1];
      _loadedWorkouts = result.documents.map((workout) => Workout.fromSnapshot(workout)).toList();

      _workouts[_trainerId].addAll(_loadedWorkouts);
    }
    if (result.documents.length < workoutsLimit) {
      _allWorkoutsLoaded = true;
    }
    notifyListeners();
  }

  Future<void> fetchExerciseData(String id) async {
    DocumentSnapshot result = await _db.collection('trainers').document(_trainerId).collection('exercises').document(id).get();

    print('Read: 1');
    _exerciseData.add(ExerciseData.fromSnapshot(result));
    notifyListeners();
  }
}
