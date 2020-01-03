import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {  
  final String uid;
  final String name;
  final String surname;
  final String trainingGoal;
  final String experienceLevel;
  final String trainingType;
  final int age;  
  final bool isPremium;

  UserData({
    this.uid,
    this.name,
    this.surname,
    this.age,
    this.trainingGoal,
    this.trainingType,
    this.experienceLevel,
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

    String trainingTypeToString(int number) {
      if (number == 0) return 'Siłownia';
      else if (number == 1) return 'Kalistenika';
      else if (number == 2) return 'Trening hybrydowy';
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
      surname: data['surname'] ?? '',
      age: data['age'] ?? 0,
      trainingGoal: trainingGoalToString(data['trainingGoal'] ?? 0),
      trainingType: trainingTypeToString(data['trainingType'] ?? 0),      
      experienceLevel: experienceLevelToString(data['experienceLevel'] ?? 0),
      isPremium: data['isPremium'] ?? 0,
    );
  }
}
