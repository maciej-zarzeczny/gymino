import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/trainer.dart';
import '../models/question.dart';

class TrainersProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  final int _trainersLimit = 5;
  final int _questionsLimit = 5;

  bool _allTrainersLoaded = false;
  bool _allQuestionsLoaded = false;
  DocumentSnapshot _lastTrainer;
  DocumentSnapshot _lastQuestion;

  List<Trainer> _loadedTrainers = [];
  List<Trainer> _trainers = [];
  List<Question> _loadedQuestions = [];
  List<Question> _questions = [];

  List<Trainer> get trainers {
    return [..._trainers];
  }

  List<Question> get questions {
    return [..._questions];
  }

  bool get allTrainersLoaded {
    return _allTrainersLoaded;
  }

  bool get allQuestionsLoaded {
    return _allQuestionsLoaded;
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

  Future<void> fetchQuestions(String id) async {
    var result = await _db
        .collection('trainers')
        .document(id)
        .collection('questions')
        .orderBy('question')
        .limit(_questionsLimit)
        .getDocuments();

    if (result.documents.length > 0) {
      _lastQuestion = result.documents[result.documents.length - 1];
      _loadedQuestions = result.documents
          .map((question) => Question.fromSnapshot(question))
          .toList();

      _questions = _loadedQuestions;
    }
    if (result.documents.length < _questionsLimit) {
      _allQuestionsLoaded = true;
    }

    notifyListeners();
  }

  Future<void> fetchMoreQuestions(String id) async {
    var result = await _db
        .collection('trainers')
        .document(id)
        .collection('questions')
        .orderBy('question')
        .startAfterDocument(_lastQuestion)
        .limit(_questionsLimit)
        .getDocuments();

    if (result.documents.length > 0) {
      _lastQuestion = result.documents[result.documents.length - 1];
      _loadedQuestions = result.documents
          .map((question) => Question.fromSnapshot(question))
          .toList();

      _questions.addAll(_loadedQuestions);
    }
    if (result.documents.length < _questionsLimit) {
      _allQuestionsLoaded = true;
    }

    notifyListeners();
  }
}
