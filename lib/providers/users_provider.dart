import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UsersProvider {
  final String uid;
  UsersProvider({this.uid});

  final Firestore _db = Firestore.instance;

  Future<void> updateUserData(String name, String surname, int age, int trainingGoal, int trainingType, int experienceLevel, bool isPremium) async {
    return await _db.collection('users').document(uid).setData({
      'name': name,
      'surname': surname,
      'age': age,
      'trainingType': trainingType,
      'trainingGoal': trainingGoal,
      'experienceLevel': experienceLevel,
      'isPremium': isPremium,
    });
  }

  Stream<UserData> get userData {
    return _db.collection('users').document(uid).snapshots().map((snapshot) {
      return UserData.fromSnapshot(snapshot);
    });
  }
}
