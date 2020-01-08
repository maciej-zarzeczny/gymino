import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UsersProvider {
  final String uid;
  UsersProvider({this.uid});

  final Firestore _db = Firestore.instance;

  Future<void> updateUserData(String name, int gender, int trainingGoal, bool isPremium) async {
    return await _db.collection('users').document(uid).setData({
      'name': name,      
      'gender': gender,
      'trainingGoal': trainingGoal, 
      'isPremium': isPremium,
    });
  }

  Stream<UserData> get userData {
    return _db.collection('users').document(uid).snapshots().map((snapshot) {
      return UserData.fromSnapshot(snapshot);
    });
  }
}
