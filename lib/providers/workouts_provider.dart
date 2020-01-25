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
  Map<String, List<Workout>> _workoutsMap = new Map();  
  List<ExerciseData> _exerciseData = [];

  String _trainerId = '';

  set currentTrainerId(id) {
    _trainerId = id;
  }

  String get currentTrainerId {
    return _trainerId;
  }  

  List<Workout> get workouts {
    return _workoutsMap[_trainerId];
  }

  int get numberOfWorkouts {
    return _workoutsMap[_trainerId].length;
  }

  bool get allWorkoutsLoaded {
    return _allWorkoutsLoaded;
  }

  // TODO: Change to return last 4 workouts based on timestamps
  List<Workout> get recentWorkouts {
    if (_workoutsMap[_trainerId].length >= 4) {
      return [_workoutsMap[_trainerId][0], _workoutsMap[_trainerId][1], _workoutsMap[_trainerId][2]];
    } else {
      return [];
    }
  }

  Workout findById(String id) {
    return _workoutsMap[_trainerId].firstWhere((workout) => workout.id == id);
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

  Future<void> fetchWorkouts() async {    
    _allWorkoutsLoaded = false;
    var result = await _db
        .collection('trainers')
        .document(_trainerId)
        .collection('workouts')
        .orderBy('name')
        .limit(_workoutsLimit)
        .getDocuments();

    if (result.documents.length > 0) {
      print(result.documents.length);
      _lastDocument = result.documents[result.documents.length - 1];
      _loadedWorkouts = result.documents
          .map((workout) => Workout.fromSnapshot(workout))
          .toList();
      
      _workoutsMap[_trainerId] = _loadedWorkouts;
    } else {      
      _workoutsMap[_trainerId] = [];
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
      print(result.documents.length);
      _lastDocument = result.documents[result.documents.length - 1];
      _loadedWorkouts = result.documents
          .map((workout) => Workout.fromSnapshot(workout))
          .toList();
      
      _workoutsMap[_trainerId].addAll(_loadedWorkouts);
    }
    if (result.documents.length < _workoutsLimit) {
      _allWorkoutsLoaded = true;
    }
    notifyListeners();
  }

  List<Exercise> getExercises(String workoutId) {
    List<Exercise> loadedExercises = findById(workoutId)
        .exercises
        .map((exercise) => Exercise.fromMap(exercise))
        .toList();

    return loadedExercises;
  }

  Future<void> fetchExerciseData(String id) async {
    DocumentSnapshot result =
        await _db.collection('exercises').document(id).get();

    print('1');
    _exerciseData.add(ExerciseData.fromSnapshot(result));
    notifyListeners();
  }
}
