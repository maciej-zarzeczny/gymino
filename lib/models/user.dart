import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {  
  final String uid;
  final String name;
  final String gender;
  final String trainingGoal;
  final String experienceLevel;
  int finishedWorkouts;
  final Map<dynamic, dynamic> savedWorkouts;
  final bool isPremium;

  UserData({
    this.uid,
    this.name,    
    this.gender,
    this.trainingGoal,
    this.experienceLevel,
    this.finishedWorkouts,
    this.savedWorkouts,    
    this.isPremium,
  });

  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;

    String trainingGoalToString(int number) {
      if (number == 0) return 'Budowanie masy mięśniowej';
      else if (number == 1) return 'Redukcja masy';
      else if (number == 2) return 'Zwiększenie wytrzymałości';
      else return '';
    }

    String genderToString(int number) {
      if (number == 0) return 'Mężczyzna';
      else if (number == 1) return 'Kobieta';
      else return '';
    }

    String experienceLevelToString(int number) {
      if (number == 0) return 'Początkujący';
      else if (number == 1) return 'Średniozaawansowany';
      else if (number == 2) return 'Zaawansowany';
      else return '';
    }

    return UserData(
      uid: snapshot.documentID,
      name: data['name'] ?? '',
      gender: genderToString(data['gender'] ?? 0),            
      trainingGoal: trainingGoalToString(data['trainingGoal'] ?? 0),
      experienceLevel: experienceLevelToString(data['experienceLevel'] ?? 0),
      finishedWorkouts: data['finishedWorkouts'] ?? 0,
      savedWorkouts: data['savedWorkouts'] ?? {},      
      isPremium: data['isPremium'] ?? 0,
    );
  }
}
