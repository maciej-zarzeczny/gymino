import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/trainer.dart';
import '../widgets/keyword.dart';
import '../models/question.dart';
import '../providers/trainers_provider.dart';
import '../widgets/question_card.dart';

class TrainerInfoScreen extends StatefulWidget {
  static const routeName = '/trainerInfo';

  @override
  _TrainerInfoScreenState createState() => _TrainerInfoScreenState();
}

class _TrainerInfoScreenState extends State<TrainerInfoScreen> {
  bool _infoChoosen = true;
  bool _isLoading = true;
  Trainer _trainer;
  List<Question> _questions;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      _trainer = ModalRoute.of(context).settings.arguments as Trainer;
      Provider.of<TrainersProvider>(context, listen: false)
          .fetchQuestions(_trainer.id)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  void infoChoosed() {
    setState(() {
      _infoChoosen = true;
    });
  }

  void faqChoosed() {
    setState(() {
      _infoChoosen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final trainersProvider = Provider.of<TrainersProvider>(context);
    _questions = trainersProvider.questions;

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(              
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  header(context, _trainer),
                  picker(context),
                  _infoChoosen                  
                      ? Column(
                          children: <Widget>[
                            infoGrid(context, _trainer.age, _trainer.height),
                            infoGrid2(context, _trainer.weight,
                                _trainer.trainingTime),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                              child: Text(
                                'Ostatnio dodane',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Container(                              
                              height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.55,                                 
                              child: ListView.builder(
                                padding: const EdgeInsets.all(0.0),
                                itemCount: _questions.length,
                                itemBuilder: (context, i) {
                                  return QuestionCard(_questions[i].question, _questions[i].answer);
                                },
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }

  Widget header(context, Trainer trainer) {
    return Container(
      width: double.infinity,
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.3,
      child: Stack(
        children: <Widget>[
          Image(
            width: double.infinity,
            image: NetworkImage(trainer.imageUrl),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          Container(
            color: Colors.black26,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              iconSize: 30,
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.favorite, color: Theme.of(context).primaryColor),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        trainer.numberOfFollowers,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 23),
                      ),
                    ),
                  ],
                ),
                Text(trainer.name, style: Theme.of(context).textTheme.title),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: trainer.keywords.map((keyword) {
                      return Keyword(keyword, false);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget infoGrid(context, int data1, int data2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    data1.toString(),
                    style: Theme.of(context).textTheme.title.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30,
                        ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Text(
                      'Wiek',
                      style: TextStyle(
                        color: Color.fromRGBO(190, 190, 190, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.only(right: 5.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1.0),
                borderRadius: BorderRadius.circular(20.0)),
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.width * 0.35,
          ),
          Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    '$data2 cm',
                    style: Theme.of(context).textTheme.title.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30,
                        ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Text(
                      'Wzrost',
                      style: TextStyle(
                        color: Color.fromRGBO(190, 190, 190, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1.0),
                borderRadius: BorderRadius.circular(20.0)),
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.width * 0.35,
          ),
        ],
      ),
    );
  }

  Widget infoGrid2(context, int data1, int data2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    '$data1 kg',
                    style: Theme.of(context).textTheme.title.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30,
                        ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Text(
                      'Waga',
                      style: TextStyle(
                        color: Color.fromRGBO(190, 190, 190, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.only(right: 5.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1.0),
                borderRadius: BorderRadius.circular(20.0)),
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.width * 0.35,
          ),
          Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    '$data2 lat',
                    style: Theme.of(context).textTheme.title.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30,
                        ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Text(
                      'Staż treningowy',
                      style: TextStyle(
                        color: Color.fromRGBO(190, 190, 190, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1.0),
                borderRadius: BorderRadius.circular(20.0)),
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.width * 0.35,
          ),
        ],
      ),
    );
  }

  Widget picker(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: infoChoosed,
            child: Container(
              child: Text(
                'Informacje',
                style: TextStyle(
                  color: _infoChoosen
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              margin: const EdgeInsets.only(right: 5.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1.0,
                  ),
                  color: _infoChoosen
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15.0)),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
          ),
          GestureDetector(
            onTap: faqChoosed,
            child: Container(
              child: Text(
                'Pytania',
                style: TextStyle(
                  color: !_infoChoosen
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              margin: const EdgeInsets.only(left: 5.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                  color: !_infoChoosen
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(15.0)),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
