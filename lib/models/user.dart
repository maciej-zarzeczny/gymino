import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  String name;
  int gender;
  int trainingType;
  int experienceLevel;
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

  Map<String, dynamic> toJson() => 
  {
    'name': name,
    'gender': gender,
    'trainingType': trainingType,
    'experienceLevel': experienceLevel,
  };

  List<String> genderNames = [
    'Mężczyzna',
    'Kobieta',
  ];
  List<String> trainingTypeNames = [
    'Siłownia',
    'Kalistenika',
    'Hybrydowy',
  ];
  List<String> experienceLevelNames = [
    'Początkujący',
    'Średniozaawansowany',
    'Zaawansowany',
  ];

  String get genderName {
    switch (gender) {
      case 0:
        return genderNames[0];
        break;

      case 1:
        return genderNames[1];
        break;

      default:
        return '';
        break;
    }
  }

  String get trainingTypeName {
    switch (trainingType) {
      case 0:
        return trainingTypeNames[0];
        break;

      case 1:
        return trainingTypeNames[1];
        break;

      case 2:
        return trainingTypeNames[2];
        break;

      default:
        return '';
        break;
    }
  }

  String get experienceLevelName {
    switch (experienceLevel) {
      case 1:
        return experienceLevelNames[0];
        break;

      case 2:
        return experienceLevelNames[1];
        break;

      case 3:
        return experienceLevelNames[2];
        break;

      default:
        return '';
        break;
    }
  }

  set genderName(String value) {
    if (value == genderNames[0]) {
      gender = 0;
    } else if (value == genderNames[1]) {
      gender = 1;
    }
  }

  set trainingTypeName(String value) {
    if (value == trainingTypeNames[0]) {
      trainingType = 0;
    } else if (value == trainingTypeNames[1]) {
      trainingType = 1;
    } else if (value == trainingTypeNames[2]) {
      trainingType = 2;
    }
  }

  set experienceLevelName(String value) {
    if (value == experienceLevelNames[0]) {
      experienceLevel = 1;
    } else if (value == experienceLevelNames[1]) {
      experienceLevel = 2;
    } else if (value == experienceLevelNames[2]) {
      experienceLevel = 3;
    }
  }
}
