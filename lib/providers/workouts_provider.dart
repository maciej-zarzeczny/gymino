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
  Map<String, List<Workout>> _workoutsMap = new Map();
  Map<String, List<Workout>> _recommendedWorkouts = new Map();
  List<ExerciseData> _exerciseData = [];

  String _trainerId = '';

  set currentTrainerId(id) {
    _trainerId = id;
  }

  set fromSavedWorkouts(value) {
    _fromSavedWorkouts = value;
  }

  bool get fromSavedWorkouts {
    return _fromSavedWorkouts;
  }

  String get currentTrainerId {
    return _trainerId;
  }

  List<Workout> get workouts {
    return _workoutsMap[_trainerId];
  }

  List<Workout> get recommendedWorkouts {    
    if (_workoutsMap[_trainerId].length > 1 && _recommendedWorkouts[_trainerId] != null) {
      return _recommendedWorkouts[_trainerId];
    } else {
      return [];
    }
  }

  int get numberOfWorkouts {
    return _workoutsMap[_trainerId].length;
  }

  bool get allWorkoutsLoaded {
    return _allWorkoutsLoaded;
  }

  Workout findById(String id) {
    Workout workout;
    try {
      workout =
          _workoutsMap[_trainerId].firstWhere((workout) => workout.id == id);
      return workout;
    } catch (e) {
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
    var result = await _db
        .collection('trainers')
        .document(_trainerId)
        .collection('workouts')
        .document(id)
        .get();
    if (result != null) {
      _fromSavedWorkouts = true;
      print('1');
      _workoutsMap[_trainerId] = [Workout.fromSnapshot(result)];
    }
    notifyListeners();
  }

  Future<void> fetchWorkouts(int experienceLevel) async {
    _allWorkoutsLoaded = false;
    _fromSavedWorkouts = false;

    QuerySnapshot recommendedResult = await _db
        .collection('trainers')
        .document(_trainerId)
        .collection('workouts')
        .where('difficulty', isEqualTo: experienceLevel)
        .orderBy('createdDate', descending: true)        
        .limit(_recommendedWorkoutsLimit)
        .getDocuments();

    if (recommendedResult.documents.length > 0) {      
      _recommendedWorkouts[_trainerId] = recommendedResult.documents
          .map((workout) => Workout.fromSnapshot(workout))
          .toList();
    }

    QuerySnapshot result = await _db
        .collection('trainers')
        .document(_trainerId)
        .collection('workouts')
        .orderBy('createdDate', descending: true)
        .limit(workoutsLimit - recommendedResult.documents.length)
        .getDocuments();

    if (result.documents.length > 0) {
      print(
          'Read: ${result.documents.length + recommendedResult.documents.length}');
      _lastDocument = result.documents[result.documents.length - 1];
      _loadedWorkouts = result.documents
          .map((workout) => Workout.fromSnapshot(workout))
          .toList();

      _workoutsMap[_trainerId] = _loadedWorkouts;
    } else {
      _workoutsMap[_trainerId] = [];
    }
    if (result.documents.length < workoutsLimit - recommendedResult.documents.length) {
      _allWorkoutsLoaded = true;
    }

    notifyListeners();
  }

  Future<void> fetchMoreWorkouts() async {
    _fromSavedWorkouts = false;
    var result = await _db
        .collection('trainers')
        .document(_trainerId)
        .collection('workouts')
        .orderBy('createdDate', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(workoutsLimit)
        .getDocuments();

    if (result.documents.length > 0) {
      print('Read: ${result.documents.length}');
      _lastDocument = result.documents[result.documents.length - 1];
      _loadedWorkouts = result.documents
          .map((workout) => Workout.fromSnapshot(workout))
          .toList();

      _workoutsMap[_trainerId].addAll(_loadedWorkouts);
    }
    if (result.documents.length < workoutsLimit) {
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
