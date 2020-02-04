import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/trainer.dart';

class TrainersProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  final int _trainersLimit = 6;
  final int _recommendedTrainersLimit = 3;

  bool _allTrainersLoaded = false;
  DocumentSnapshot _lastTrainer;

  List<Trainer> _loadedTrainers = [];
  List<Trainer> _trainers = [];
  List<Trainer> _recommendedTrainers = [];

  String _trainerId;

  List<Trainer> get trainers {
    return [..._trainers];
  }

  List<Trainer> get recommendedTrainers {
    return [..._recommendedTrainers];
  }

  bool get allTrainersLoaded {
    return _allTrainersLoaded;
  }

  String get currentTrainerId {
    return _trainerId;
  }

  Trainer findById(String id) {
    return _trainers.firstWhere((trainer) => trainer.id == id);
  }

  Future<void> fetchTrainers(int trainingType, int gender) async {
    bool gym = false;
    bool calisthenics = false;
    switch (trainingType) {
      case 0:
        gym = true;
        calisthenics = false;
        break;

      case 1:
        gym = false;
        calisthenics = true;
        break;

      case 2:
        gym = true;
        calisthenics = true;
        break;
    }    

    QuerySnapshot topResults = await _db
        .collection('trainers')
        .where('gym', isEqualTo: gym)
        .where('calisthenics', isEqualTo: calisthenics)
        .where('gender', isEqualTo: gender)
        .orderBy('numberOfWorkouts', descending: true)
        .limit(_recommendedTrainersLimit)
        .getDocuments();

    if (topResults.documents.length > 0) {
      print('Read: ${topResults.documents.length}');
      _recommendedTrainers = topResults.documents.map((trainer) {
        return Trainer.fromSnapshot(trainer);
      }).toList();
    }    

    QuerySnapshot result = await _db
        .collection('trainers')        
        .orderBy('numberOfWorkouts', descending: true)             
        .limit(_trainersLimit)
        .getDocuments();

    if (result.documents.length > 0) {
      print('Read: ${result.documents.length}');
      _lastTrainer = result.documents[result.documents.length - 1];
      _loadedTrainers = result.documents
          .map((trainer) => Trainer.fromSnapshot(trainer))
          .toList();
      
      _trainers = _loadedTrainers;
    }
    if (result.documents.length < _trainersLimit) {
      _allTrainersLoaded = true;
    }
    
    notifyListeners();
  }

  Future<void> fetchMoreTrainers() async {
    var result = await _db
        .collection('trainers')
        .orderBy('numberOfWorkouts', descending: true)
        .limit(_trainersLimit)
        .startAfterDocument(_lastTrainer)
        .getDocuments();

    if (result.documents.length > 0) {
      print(result.documents.length);
      _lastTrainer = result.documents[result.documents.length - 1];
      _loadedTrainers = result.documents
          .map((trainer) => Trainer.fromSnapshot(trainer))
          .toList();

      _trainers.addAll(_loadedTrainers);
    }
    if (result.documents.length < _trainersLimit) {
      _allTrainersLoaded = true;
    }
    notifyListeners();
  }
}
