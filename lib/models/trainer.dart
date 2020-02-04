import 'package:cloud_firestore/cloud_firestore.dart';

class Trainer {
  final String id;
  final String name;
  final String imageUrl;  
  final int numberOfWorkouts;
  final bool calisthenics;
  final bool gym;  
  final List<dynamic> supplements;
  final int age;
  final int height;
  final int weight;
  final int trainingTime;

  Trainer({
    this.id,
    this.name,
    this.imageUrl,    
    this.numberOfWorkouts,
    this.calisthenics,
    this.gym,
    this.supplements,
    this.age,
    this.height,
    this.weight,
    this.trainingTime,
  });

  factory Trainer.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data;    

    return Trainer(
      id: doc.documentID ?? '',
      name: data['name'] ?? '',
      imageUrl: data['image_url'] ?? '',      
      numberOfWorkouts: data['numberOfWorkouts'] ?? 0,
      calisthenics: data['calisthenics'] ?? false,
      gym: data['gym'] ?? false,
      supplements: data['supplements'] ?? [],
      age: data['age'] ?? 0,
      height: data['height'] ?? 0,
      weight: data['weight'] ?? 0,
      trainingTime: data['trainingTime'] ?? 0,
    );
  }
}
