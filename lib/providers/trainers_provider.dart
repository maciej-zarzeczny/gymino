import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/trainer.dart';

class TrainersProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  final int _trainersLimit = 5;

  bool _allTrainersLoaded = false;  
  DocumentSnapshot _lastTrainer;

  List<Trainer> _loadedTrainers = [];
  List<Trainer> _trainers = [];  

  String _trainerId;

  List<Trainer> get trainers {
    return [..._trainers];
  }

  bool get allTrainersLoaded {
    return _allTrainersLoaded;
  }

  String get currentTrainerId {
    return _trainerId;
  }

  // TODO: Chnage algorythm
  List<Trainer> get popularTrainers {
    return _trainers.length < 4
        ? null
        : [_trainers[1], _trainers[2], _trainers[3]];
  }

  Trainer get topTrainer {
    return _trainers.isEmpty ? null : _trainers.first;
  }

  Trainer findById(String id) {
    return _trainers.firstWhere((trainer) => trainer.id == id);
  }

  Future<void> fetchTrainers() async {
    var result = await _db
        .collection('trainers')
        .orderBy('number_of_followers', descending: true)
        .limit(_trainersLimit)
        .getDocuments();

    if (result.documents.length > 0) {
      print(result.documents.length);
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
        .orderBy('number_of_followers', descending: true)
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
