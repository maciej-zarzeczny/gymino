import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Trainer {
  final String id;
  final String name;
  final String imageUrl;
  final String numberOfFollowers;
  final List<dynamic> keywords;
  final int age;
  final int height;
  final int weight;
  final int trainingTime;

  Trainer({
    this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.numberOfFollowers,
    this.keywords,
    this.age,
    this.height,
    this.weight,
    this.trainingTime,
  });

  factory Trainer.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;

    String followersToString(int number) {
      if (number >= 1000) {
        return '${(number / 1000).round()} K';
      } else {
        return number.toString();
      }
    }

    return Trainer(
      id: doc.documentID ?? '',
      name: data['name'] ?? '',
      imageUrl: data['image_url'] ?? '',
      numberOfFollowers: followersToString(data['number_of_followers']) ?? followersToString(0),
      keywords: data['keywords'],
      age: data['age'] ?? 0,
      height: data['height'] ?? 0,
      weight: data['weight'] ?? 0,
      trainingTime: data['trainingTime'] ?? 0,
    );
  }
}
