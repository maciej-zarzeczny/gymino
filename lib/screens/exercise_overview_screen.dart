import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../providers/workouts_provider.dart';
import '../models/exercise.dart';
import '../widgets/keyword.dart';

class ExerciseOverviewScreen extends StatefulWidget {
  static const routeName = '/exerciseOverview';

  @override
  _ExerciseOverviewScreenState createState() => _ExerciseOverviewScreenState();
}

class _ExerciseOverviewScreenState extends State<ExerciseOverviewScreen> {
  bool _isLoading = true;
  String _exerciseId;

  @override
  void initState() {
    Future.microtask(() {
      _exerciseId = ModalRoute.of(context).settings.arguments as String;
      var workoutsProvider =
          Provider.of<WorkoutsProvider>(context, listen: false);
      if (workoutsProvider.findExerciseById(_exerciseId) == null) {
        workoutsProvider.fetchExerciseData(_exerciseId).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ExerciseData _exerciseData;
    if (_exerciseId != null) {
      _exerciseData =
          Provider.of<WorkoutsProvider>(context).findExerciseById(_exerciseId);
    }

    return Scaffold(
      body: _isLoading
          ? Global().loadingIndicator(context)
          : Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: header(context),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  color: Colors.white,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: content(_exerciseData, context),
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
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Global().backArrow(),
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
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget content(ExerciseData exercise, context) {
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
                return Keyword(keyword, true);
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
