import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UsersProvider with ChangeNotifier {
  String uid;
  UserData _userData;
  final Firestore _db = Firestore.instance;

  get userData {
    return _userData;
  }

  Future<void> updateUserData(String uid, String name, int gender, int trainingGoal, int experienceLevel, bool isPremium) async {
    this.uid = uid;
    return await _db.collection('users').document(uid).setData({
      'name': name,      
      'gender': gender,
      'trainingGoal': trainingGoal, 
      'experienceLevel': experienceLevel,
      'isPremium': isPremium,
    });    
  }

  Future<void> getUserData(String uid) async {
    this.uid = uid;
    var result = await _db.collection('users').document(uid).get();
    print('fetching user data');
    _userData = UserData.fromSnapshot(result);    
  }

  int _difficultyToInt(String difficulty) {
      if (difficulty == 'POCZĄTKUJĄCY') return 0;
      else if (difficulty == 'ŚREDNI') return 1;
      else return 2;
    }

  Future<void> addWorkoutToFavourites(String id, String difficulty, int duration, String name, String imageUrl, String trainerId) async {    
    Map<dynamic, dynamic> newWorkout = new Map();
    newWorkout['name'] = name;
    newWorkout['duration'] = duration;
    newWorkout['difficulty'] = _difficultyToInt(difficulty);
    newWorkout['imageUrl'] = imageUrl;
    newWorkout['trainerId'] = trainerId;

    _userData.savedWorkouts[id] = newWorkout;
    notifyListeners();

    return await _db.collection('users').document(uid).updateData({'savedWorkouts' : _userData.savedWorkouts});
  }

  Future<void> removeWorkoutFromFavourites(String id) async {
    _userData.savedWorkouts.remove(id);
    notifyListeners();
    return await _db.collection('users').document(uid).updateData({'savedWorkouts.$id' : FieldValue.delete()});    
  }
}
