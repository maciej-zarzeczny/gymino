import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {  
  final String uid;
  final String name;
  final int gender;  
  final int trainingType;
  final int experienceLevel;  
  int finishedWorkouts;
  final Map<dynamic, dynamic> savedWorkouts;

  UserData({
    this.uid,
    this.name,    
    this.gender,    
    this.trainingType,
    this.experienceLevel,
    this.finishedWorkouts,
    this.savedWorkouts,        
  });

  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;

    // String trainingGoalToString(int number) {
    //   if (number == 0) return 'Budowanie masy mięśniowej';
    //   else if (number == 1) return 'Redukcja masy';
    //   else if (number == 2) return 'Zwiększenie wytrzymałości';
    //   else return '';
    // }

    // String genderToString(int number) {
    //   if (number == 0) return 'Mężczyzna';
    //   else if (number == 1) return 'Kobieta';
    //   else return '';
    // }

    return UserData(
      uid: snapshot.documentID,
      name: data['name'] ?? '',
      gender: data['gender'] ?? 0,                  
      trainingType: data['trainingType'] ?? 0,
      experienceLevel: data['experienceLevel'] ?? 0,
      finishedWorkouts: data['finishedWorkouts'] ?? 0,
      savedWorkouts: data['savedWorkouts'] ?? {},      
    );
  }
}
