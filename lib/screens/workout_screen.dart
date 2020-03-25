import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_picker/flutter_picker.dart';

import '../widgets/button.dart';
import '../size_config.dart';
import '../models/exercise.dart';
import '../providers/users_provider.dart';
import '../globals.dart';

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
  List<dynamic> _sets;
  bool _rest = false;
  double _opacity = 1.0;
  Timer _timer;
  int _timerDuration = 1;
  int _restDuration = 1;
  List<dynamic> _doneExercises = [];
  UsersProvider _usersProvider;
  String _workoutName;
  String _workoutImageUrl;
  String _appBarTitle = '';
  bool _workoutFinished = false;
  bool _setsInit = true;

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
        _appBarTitle = _exercises[0].name;
      });
    });
    super.initState();
  }

  void setDone(int weight, int reps) {
    if (_currentSet == 1) {
      _doneExercises.add({'name': _exercises[_currentExerciseIndex].name, 'sets': []});
    }
    Map<dynamic, dynamic> _set = {'reps': reps, 'weight': weight};
    _doneExercises[_currentExerciseIndex]['sets'].add(_set);

    setState(() {
      _sets[_currentSet - 1] = _set;
      if (_currentSet < _exercises[_currentExerciseIndex].sets.length) {
        _currentSet += 1;
        _restDuration = _exercises[_currentExerciseIndex].rest;
        startRest(_restDuration);
      } else {
        if (_currentExerciseIndex < _exercises.length - 1) {
          _setsInit = true;
          _currentSet = 1;
          _restDuration = _exercises[_currentExerciseIndex].setRest;
          startRest(_restDuration);
          _currentExerciseIndex += 1;
        } else {
          setState(() => _workoutFinished = true);
        }
      }
    });
  }

  void changeSet(int index, int weight, int reps) {
    Map<String, int> _set = {'reps': reps, 'weight': weight};
    _doneExercises[_currentExerciseIndex]['sets'][index] = _set;
    setState(() {
      _sets[index] = _set;
    });
  }

  Future<void> _finishWorkout() async {
    return await _usersProvider.saveWorkoutToDb(_workoutName, _workoutImageUrl, _doneExercises);
  }

  void startRest(int time) {
    setState(() => _appBarTitle = 'Odpoczynek');
    _rest = true;
    _opacity = 0.0;
    startCountdown(time);
  }

  void finishRest() {
    setState(() {
      _appBarTitle = _exercises[_currentExerciseIndex].name;
      _rest = false;
      _opacity = 1.0;
      _timerDuration = 0;
    });
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

  void showPickerArray(BuildContext context, int initReps, int initWeight, bool withWeight, int index) {
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
            begin: withWeight ? 1 : 0,
            end: withWeight ? 400 : 0,
            initValue: initWeight != 0 ? initWeight : 1,
            suffix: withWeight ? Text(' kg') : Text(''),
          ),
          NumberPickerColumn(begin: 1, end: 50, initValue: initReps),
        ]),
        delimiter: [
          PickerDelimiter(
            child: Container(
              width: 30.0,
              alignment: Alignment.center,
              child: Text('x'),
            ),
          ),
        ],
        hideHeader: true,
        title: new Text("Wybierz wartości"),
        onConfirm: (Picker picker, List value) {
          if (_doneExercises.length > _currentExerciseIndex && _doneExercises[_currentExerciseIndex]['sets'].length > index) {
            changeSet(index, picker.getSelectedValues()[0], picker.getSelectedValues()[1]);
          } else {
            setDone(picker.getSelectedValues()[0], picker.getSelectedValues()[1]);
          }
        }).showDialog(context);
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Zakończyć trening ?'.toUpperCase(),
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            content: new Text('Czy na pewno chcesz zakończyć obecny trening ? Nie zostanie on zapisany w historii treningów.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Nie'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Tak'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Exercise _currentExercise;
    int _setsNumber = 0;

    if (!_isLoading) {
      _currentExercise = _exercises[_currentExerciseIndex];
      if (_setsInit) {
        _setsInit = false;
        _sets = _currentExercise.sets;
      }
      _setsNumber = _currentExercise.sets.length;
    }

    final AppBar _appBar = AppBar(
      title: Text(
        _appBarTitle.toUpperCase(),
        style: Theme.of(context).textTheme.title,
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: Theme.of(context).textTheme.title.color),
      backgroundColor: Colors.transparent,
      brightness: Platform.isIOS ? Brightness.light : Brightness.dark,
      elevation: 0.0,
    );

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _appBar,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Global().canvasColor,
                child: Stack(
                  children: <Widget>[
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: 1 - _opacity,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.2),
                        child: Center(
                          child: restTimer(),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(0),
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 200),
                                opacity: _opacity,
                                child: Container(
                                  height: MediaQuery.of(context).size.width * 0.8,
                                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Global().softGrey,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(_currentExercise.image),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 200),
                                opacity: _opacity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _sets.asMap().entries.map((entry) {
                                    int index = entry.key + 1;
                                    int reps = entry.value['reps'];
                                    int weight = entry.value['weight'];
                                    return setRow(index, reps, _setsNumber, weight);
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        nextButton(_setsNumber, _sets[_currentSet - 1]['reps'], _sets[_currentSet - 1]['weight'])
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget setRow(int setNumber, int reps, int setsNumber, int weight) {
    bool value = false;
    if (!_workoutFinished) {
      value = _currentSet > setNumber;
    } else {
      value = _workoutFinished;
    }
    bool currentSet = _currentSet == setNumber;
    bool withWeight = weight > 0;

    String weightSuffix = value ? 'kg' : '%';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (!value && currentSet) {
            showPickerArray(context, reps, 0, withWeight, setNumber - 1);
          } else if (value) {
            showPickerArray(context, reps, weight, withWeight, setNumber - 1);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Checkbox(
              value: value,
              onChanged: (_) {
                if (!value && currentSet) {
                  showPickerArray(context, reps, 0, withWeight, setNumber - 1);
                } else if (value) {
                  showPickerArray(context, reps, weight, withWeight, setNumber - 1);
                }
              },
            ),
            Column(
              children: <Widget>[
                Text(
                  'SERIA',
                  style: TextStyle(
                    color: Global().mediumGrey,
                    letterSpacing: 1.0,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  setNumber.toString(),
                  style: TextStyle(
                    color: !value ? currentSet ? Theme.of(context).primaryColor : Global().mediumGrey : Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  'KG',
                  style: TextStyle(
                    color: Global().mediumGrey,
                    letterSpacing: 1.0,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  withWeight ? '$weight$weightSuffix' : '-',
                  style: TextStyle(
                    color: !value ? currentSet ? Theme.of(context).primaryColor : Global().mediumGrey : Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  'POWTÓRZENIA',
                  style: TextStyle(
                    color: Global().mediumGrey,
                    letterSpacing: 1.0,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  reps.toString(),
                  style: TextStyle(
                    color: !value ? currentSet ? Theme.of(context).primaryColor : Global().mediumGrey : Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget restTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CircularPercentIndicator(
          radius: SizeConfig.blockSizeHorizontal * 50.0,
          lineWidth: 13.0,
          percent: _timerDuration / _restDuration,
          center: Text(
            parseDuration(_timerDuration),
            style: Theme.of(context).textTheme.display2.copyWith(
                  fontSize: SizeConfig.safeBlockHorizontal * 10.0,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          progressColor: Theme.of(context).accentColor,
          backgroundColor: Global().softGrey,
          animationDuration: 100,
          animation: true,
          animateFromLastPercent: true,
        ),
      ],
    );
  }

  Widget nextButton(int _setsNumber, int _repsNumber, int weight) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10.0),
      child: Column(
        children: <Widget>[
          Text(
            (_rest || _workoutFinished) ? '' : 'Seria: $_currentSet / $_setsNumber',
            style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).primaryColor),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Button(
              text: _rest ? 'Pomiń' : _workoutFinished ? 'Zakończ trening' : 'Gotowe',
              onTapFunction: _rest
                  ? finishRest
                  : _workoutFinished
                      ? () {
                          setState(() => _isLoading = true);
                          _finishWorkout().then((_) {
                            setState(() {
                              _setsInit = true;
                              _isLoading = false;
                            });
                            Navigator.of(context).pop();
                          }).catchError((err) {
                            setState(() => _isLoading = false);
                            print(err.toString());
                          });
                        }
                      : () => showPickerArray(context, _repsNumber, 0, weight > 0, _currentSet),
            ),
          ),
        ],
      ),
    );
  }
}
