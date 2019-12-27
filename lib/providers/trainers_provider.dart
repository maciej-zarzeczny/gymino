import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/trainer.dart';

class TrainersProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;  

  List<Trainer> _trainers = [];

  List<Trainer> get trainers {
    return [..._trainers];
  }

  List<Trainer> get popularTrainers {
    return _trainers.length < 4 ? null : [_trainers[1], _trainers[2], _trainers[3]];
  }

  Trainer get topTrainer {
    return _trainers.isEmpty ? null : _trainers.first;
  }

  Trainer findById(String id) {
    return _trainers.firstWhere((trainer) => trainer.id == id);
  }  

  Future<void> fetchTrainers() async {
    var result = await _db.collection('trainers').orderBy('number_of_followers', descending: true).getDocuments(); 
    final List<Trainer> loadedTrainers = result.documents
        .map((trainer) => Trainer.fromSnapshot(trainer))
        .toList();
    
    _trainers = loadedTrainers;            
    notifyListeners();
  }
}
