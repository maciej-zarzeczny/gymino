import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Trainer {
  final String id;
  final String name;
  final String imageUrl;
  final String numberOfFollowers;

  Trainer({
    this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.numberOfFollowers,
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
    );
  }
}
