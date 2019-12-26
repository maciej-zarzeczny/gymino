import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../widgets/keyword.dart';

class ExerciseOverviewScreen extends StatelessWidget {
  static const routeName = '/exerciseOverview';

  @override
  Widget build(BuildContext context) {
    final Exercise _exercise =
        ModalRoute.of(context).settings.arguments as Exercise;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.55,
            width: double.infinity,
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: header(context),
          ),
          Container(
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.45,
            width: double.infinity,
            child: SingleChildScrollView(
              child: content(_exercise, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget header(context) {
    return Stack(
      children: <Widget>[
        Image(
          width: double.infinity,
          image: AssetImage('assets/images/aj.jpg'),
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
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        Positioned(
          bottom: -1,
          left: 0,
          right: 0,
          child: Container(
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.05,
            padding: const EdgeInsets.all(0.0),
            margin: const EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              color: Theme.of(context).canvasColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget content(Exercise exercise, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            exercise.name,
            style: Theme.of(context).textTheme.body2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: exercise.keywords.map((keyword) {
                return Keyword(keyword);
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              exercise.description,
              style: Theme.of(context).textTheme.display3.copyWith(
                    color: Color.fromRGBO(100, 100, 100, 1),
                    fontSize: 14,
                  ),
            ),
          ),
          Text(
            exercise.instructions,
            style: Theme.of(context).textTheme.display3.copyWith(
                  color: Color.fromRGBO(100, 100, 100, 1),
                  fontSize: 14,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 35.0),
            child: Column(              
              children: exercise.bulletPoints.map((element) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(                  
                    children: <Widget>[
                      Icon(
                        Icons.star_border,
                        color: Theme.of(context).primaryColor,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 5.0, right: 15.0),                      
                        width: MediaQuery.of(context).size.width - 55,
                        child: Text(
                          element,
                          style: Theme.of(context).textTheme.display3.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
