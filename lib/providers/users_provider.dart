import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/workout.dart';
import '../models/user.dart';

class UsersProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  String uid;
  UserData _userData;
  List<FinishedWorkout> _finishedWorkouts = [];
  int _finishedWorkoutsLimit = 5;
  DocumentSnapshot _lastFinishedWorkout;
  bool _allFinishedWorkoutsLoaded;
  bool _lastFinishedWorkoutInserted = false;
  bool userDataChanged = false;

  List<FinishedWorkout> get finishedWorkouts {
    return [..._finishedWorkouts];
  }

  bool get lastFinishedWorkoudInserted {
    return _lastFinishedWorkoutInserted;
  }

  UserData get userData {
    return _userData;
  }

  bool get allFinishedWorkotusLoaded {
    return _allFinishedWorkoutsLoaded;
  }

  Future<void> createUserData(String uid, String name, int gender, int trainingType, int experienceLevel) async {
    this.uid = uid;

    print('Write: 1');

    return await _db.collection('users').document(uid).setData({
      'name': name,
      'gender': gender,
      'trainingType': trainingType,
      'experienceLevel': experienceLevel,
      'savedWorkouts': {},
    });
  }

  Future<void> updateUserData(UserData userData) async {
    print('Update: 1');
    userDataChanged = true;
    return await _db.collection('users').document(uid).updateData(userData.toJson());
  }

  Future<void> getUserData(String uid) async {
    if (_userData == null || _userData.uid != uid || userDataChanged) {
      this.uid = uid;
      var result = await _db.collection('users').document(uid).get();
      print('Read: 1');
      _userData = UserData.fromSnapshot(result);
    }
  }

  Future<void> addWorkoutToFavourites(String id, int difficulty, int duration, String name, String imageUrl, String trainerId) async {
    Map<dynamic, dynamic> newWorkout = new Map();
    newWorkout['name'] = name;
    newWorkout['duration'] = duration;
    newWorkout['difficulty'] = difficulty;
    newWorkout['imageUrl'] = imageUrl;
    newWorkout['trainerId'] = trainerId;

    _userData.savedWorkouts[id] = newWorkout;
    notifyListeners();

    print('Update: 1');

    return await _db.collection('users').document(uid).updateData({'savedWorkouts': _userData.savedWorkouts});
  }

  Future<void> removeWorkoutFromFavourites(String id) async {
    _userData.savedWorkouts.remove(id);
    notifyListeners();

    print('Update: 1');

    return await _db.collection('users').document(uid).updateData({'savedWorkouts.$id': FieldValue.delete()});
  }

  Future<void> fetchFinishedWorkouts() async {
    _allFinishedWorkoutsLoaded = false;
    var results = await _db
        .collection('users')
        .document(uid)
        .collection('finishedWorkouts')
        .orderBy('date', descending: true)
        .limit(_finishedWorkoutsLimit)
        .getDocuments();

    if (results.documents.length > 0) {
      print('Read: ${results.documents.length}');
      _lastFinishedWorkout = results.documents[results.documents.length - 1];
      _finishedWorkouts = results.documents.map((finishedWorkout) {
        return FinishedWorkout.fromSnapshot(finishedWorkout);
      }).toList();
    }

    if (results.documents.length < _finishedWorkoutsLimit) {
      _allFinishedWorkoutsLoaded = true;
    }

    notifyListeners();
  }

  Future<void> fetchMoreFinishedWorkouts() async {
    var results = await _db
        .collection('users')
        .document(uid)
        .collection('finishedWorkouts')
        .orderBy('date', descending: true)
        .startAfterDocument(_lastFinishedWorkout)
        .limit(_finishedWorkoutsLimit)
        .getDocuments();

    if (results.documents.length > 0) {
      print('Read: ${results.documents.length}');
      _lastFinishedWorkout = results.documents[results.documents.length - 1];
      _finishedWorkouts.addAll(results.documents.map((finishedWorkout) {
        return FinishedWorkout.fromSnapshot(finishedWorkout);
      }).toList());
    }

    if (results.documents.length < _finishedWorkoutsLimit) {
      _allFinishedWorkoutsLoaded = true;
    }

    notifyListeners();
  }

  // Function for saving current workout to database as finished workout
  Future<void> saveWorkoutToDb(String name, String imageUrl, List<dynamic> exercises) async {
    FinishedWorkout _finishedWorkout = new FinishedWorkout(
      name: name,
      date: Timestamp.now(),
      imageUrl: imageUrl,
      exercises: exercises,
    );

    print('Update: 1');
    print('Write: 1');

    _finishedWorkouts.insert(0, _finishedWorkout);
    if (_finishedWorkouts.length < _finishedWorkoutsLimit) {
      _lastFinishedWorkoutInserted = true;
    }
    _userData.finishedWorkouts += 1;
    await _db.collection('users').document(uid).updateData({'finishedWorkouts': _userData.finishedWorkouts});
    return await _db.collection('users').document(uid).collection('finishedWorkouts').add(_finishedWorkout.toJson());
  }
}
