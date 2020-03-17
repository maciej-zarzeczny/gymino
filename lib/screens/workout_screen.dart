import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sqilly/globals.dart';

import '../widgets/button.dart';
import '../size_config.dart';
import '../models/exercise.dart';
import '../providers/users_provider.dart';

class WorkoutScreen extends StatefulWidget {
  static const routeName = '/workout';

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _currentExerciseIndex;
  int _currentSet;
  List<Exercise> _exercises;
  bool _isLoading = true;
  int _repsNumber;
  int _currentReps = 0;
  bool _rest = false;
  double _opacity = 1.0;
  Timer _timer;
  int _timerDuration;
  int _restDuration = 0;
  final weightInputController = TextEditingController(text: '0');
  List<dynamic> _doneExercises = [];
  UsersProvider _usersProvider;
  String _workoutName;
  String _workoutImageUrl;

  @override
  void initState() {
    Future.microtask(() {
      final args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _usersProvider = Provider.of<UsersProvider>(context, listen: false);
      setState(() {
        _exercises = args['exercises'];
        _workoutName = args['workoutName'];
        _workoutImageUrl = args['imageUrl'];
        _currentExerciseIndex = 0;
        _currentSet = 1;
        _isLoading = false;
      });
    });
    super.initState();
  }

  void setDone() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_currentSet == 1) {
      _doneExercises.add({'name': _exercises[_currentExerciseIndex].name, 'sets': []});
    }
    Map<dynamic, dynamic> _set = {'reps': _currentReps, 'weight': double.parse(weightInputController.text.trim())};
    _doneExercises[_currentExerciseIndex]['sets'].add(_set);

    weightInputController.text = '0';

    setState(() {
      if (_currentSet < _exercises[_currentExerciseIndex].sets.length) {
        _currentSet += 1;
        _currentReps = 0;
        _restDuration = _exercises[_currentExerciseIndex].rest;
        startRest(_restDuration);
      } else {
        _currentSet = 1;
        _currentReps = 0;
        if (_currentExerciseIndex < _exercises.length - 1) {
          _restDuration = _exercises[_currentExerciseIndex].setRest;
          startRest(_restDuration);
          _currentExerciseIndex += 1;
        } else {
          setState(() => _isLoading = true);
          _finishWorkout().then((_) {
            setState(() => _isLoading = false);
            Navigator.of(context).pop();
          }).catchError((err) {
            setState(() => _isLoading = false);
            print(err.toString());
          });
        }
      }
    });
  }

  Future<void> _finishWorkout() async {
    return await _usersProvider.saveWorkoutToDb(_workoutName, _workoutImageUrl, _doneExercises);
  }

  void startRest(int time) {
    _rest = true;
    _opacity = 0.0;
    startCountdown(time);
  }

  void finishRest() {
    setState(() {
      _rest = false;
      _opacity = 1.0;
      _timerDuration = 0;
      weightInputController.text = '0';
    });
  }

  void addRep() {
    setState(() {
      if (_currentReps < _repsNumber) {
        _currentReps += 1;
      }
    });
  }

  void substractRep() {
    setState(() {
      if (_currentReps > 0) {
        _currentReps -= 1;
      }
    });
  }

  void addTime() {
    setState(() {
      _restDuration += 30;
      _timerDuration += 30;
    });
  }

  void substractTime() {
    setState(() {
      if (_timerDuration >= 30) {
        _timerDuration -= 30;
      } else {
        _timerDuration = 0;
      }
    });
  }

  String nextExercise() {
    if (_currentExerciseIndex + 1 < _exercises.length) {
      return 'Następnie: ${_exercises[_currentExerciseIndex + 1].name}';
    } else {
      return 'Ostatnie ćwiczenie';
    }
  }

  String parseDuration(int duration) {
    int minutes = duration ~/ 60;
    int seconds = duration % 60;

    return '$minutes:' + seconds.toString().padLeft(2, '0');
  }

  void startCountdown(int duration) {
    _timerDuration = duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_timerDuration < 1) {
          timer.cancel();
          finishRest();
        } else {
          _timerDuration -= 1;
        }
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    weightInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Exercise _currentExercise;
    int _setsNumber;

    if (!_isLoading) {
      _currentExercise = _exercises[_currentExerciseIndex];
      _setsNumber = _currentExercise.sets.length;
      _repsNumber = _currentExercise.sets.elementAt(_currentSet - 1);
    }

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(_currentExercise.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.05),
                        Color.fromRGBO(26, 26, 26, 0.95),
                      ],
                    ),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (weightInputController.text == '') {
                              weightInputController.text = '0';
                            }
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth,
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      topHeader(),
                                      exerciseTitle(_currentExercise.name, _currentSet, _setsNumber),
                                      repsCounter(_currentReps, _repsNumber),
                                      weightCounter(),
                                      nextButton(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          );
  }

  Widget exerciseTitle(String exerciseName, int currentSet, int setsNumber) {
    return Container(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.fitness_center,
            color: Global().canvasColor,
            size: SizeConfig.safeBlockHorizontal * 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text(
              _rest ? 'Odpoczynek' : exerciseName,
              style: Theme.of(context).textTheme.display2,
              textAlign: TextAlign.center,
            ),
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: _opacity,
            child: Text(
              'seria $currentSet/$setsNumber',
              style: Theme.of(context).textTheme.body1.copyWith(
                    color: Global().canvasColor,
                    fontSize: SizeConfig.safeBlockHorizontal * 5.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget repsCounter(int currentReps, int repsNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: _opacity,
              child: IconButton(
                padding: const EdgeInsets.only(left: 0.0),
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.white,
                  size: SizeConfig.safeBlockHorizontal * 13.0,
                ),
                onPressed: () {
                  substractRep();
                },
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: 1 - _opacity,
              child: InkWell(
                onTap: _rest ? substractTime : substractRep,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    '-30 s',
                    style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ],
        ),
        CircularPercentIndicator(
          radius: SizeConfig.blockSizeHorizontal * 50.0,
          lineWidth: 13.0,
          percent: _rest ? _timerDuration / _restDuration : currentReps / repsNumber,
          center: Text(
            _rest ? parseDuration(_timerDuration) : '$currentReps/$repsNumber',
            style: Theme.of(context).textTheme.display2.copyWith(fontSize: SizeConfig.safeBlockHorizontal * 10.0),
          ),
          progressColor: Theme.of(context).accentColor,
          backgroundColor: Colors.white,
          animationDuration: 100,
          animation: true,
          animateFromLastPercent: true,
        ),
        Stack(
          children: <Widget>[
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: _opacity,
              child: IconButton(
                padding: const EdgeInsets.only(right: 0.0),
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: SizeConfig.safeBlockHorizontal * 13.0,
                ),
                onPressed: () {
                  addRep();
                },
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: 1 - _opacity,
              child: InkWell(
                onTap: _rest ? addTime : addRep,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    '+30 s',
                    style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget weightCounter() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: _opacity,
      child: Column(
        children: <Widget>[
          Text(
            'Obciążenie',
            style: Theme.of(context).textTheme.body1.copyWith(
                  color: Global().canvasColor,
                  fontSize: SizeConfig.safeBlockHorizontal * 3.0,
                ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 7.0, bottom: 10.0),
            height: SizeConfig.blockSizeHorizontal * 25.0,
            width: SizeConfig.blockSizeHorizontal * 25.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onTap: () => weightInputController.text = '',
                    controller: weightInputController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 7.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                Text(
                  'kg',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5.0,
                    color: Color.fromRGBO(94, 94, 94, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget nextButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10.0),
      child: Column(
        children: <Widget>[
          Text(
            nextExercise(),
            style: Theme.of(context).textTheme.body1.copyWith(
                  color: Global().canvasColor,
                  fontSize: SizeConfig.safeBlockHorizontal * 3.0,
                ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Button(
              text: _rest ? 'Pomiń' : 'Gotowe',
              onTapFunction: _rest ? finishRest : setDone,
            ),
          ),
        ],
      ),
    );
  }

  Widget topHeader() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      alignment: Alignment.topLeft,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        icon: Icon(
          Icons.highlight_off,
          color: Colors.white,
          size: 35,
        ),
        onPressed: () {          
          if (_currentSet > 1) {
            if (Platform.isIOS) {
              showCupertinoDialog(
                  context: context,
                  builder: (bCntx) {
                    return CupertinoAlertDialog(
                      title: Text('Zakończyć trening ?'),
                      content: Text('Czy na pewno chcesz zakończyć trening ?'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: Text('Nie'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        CupertinoDialogAction(
                          child: Text('Tak'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() => _isLoading = true);
                            _finishWorkout().then((_) {
                              setState(() => _isLoading = false);
                              Navigator.of(context).pop();
                            }).catchError((err) {
                              setState(() => _isLoading = false);
                              Global().showAlertDialog(
                                context,
                                'Błąd',
                                'Podczas zapisywania treningu wystąpił błąd, spróbuj ponownie później.',
                                'Ok',
                                () => Navigator.of(context).pop(),
                              );
                            });
                          },
                        ),
                      ],
                    );
                  });
            }
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
