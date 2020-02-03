import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../widgets/custom_title.dart';
import '../providers/users_provider.dart';
import '../globals.dart';
import '../models/user.dart';
import '../models/workout.dart';
import '../widgets/more_loading_indicator.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  UsersProvider usersProvider;
  bool _isLoading = true;
  bool _moreLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Future.microtask(() {
      usersProvider = Provider.of<UsersProvider>(context, listen: false);
      if (usersProvider.finishedWorkouts.isEmpty ||
          usersProvider.lastFinishedWorkoudInserted) {
        usersProvider.fetchFinishedWorkouts().then((_) {
          setState(() {
            _isLoading = false;
          });
        }).catchError((err) {
          setState(() => _isLoading = false);
          Global().showAlertDialog(
            context,
            'Błąd',
            'Podczas pobierania historii treningów wystąpił błąd. W przypadku ciągłego pojawiania się błędu skontaktuj się z twórcą aplikacji.',
            'Ok',
            () => Navigator.of(context).pop(),
          );
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _moreLoading = true;
        });

        if (!usersProvider.allFinishedWorkotusLoaded) {
          usersProvider.fetchMoreFinishedWorkouts().then((_) {
            setState(() {
              _moreLoading = false;
            });
          });
        } else {
          double edge = 50.0;
          double offsetFromBottom = _scrollController.position.maxScrollExtent -
              _scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            _scrollController
                .animateTo(_scrollController.offset - (edge - offsetFromBottom),
                    duration: new Duration(milliseconds: 500),
                    curve: Curves.easeOut)
                .then((_) {
              setState(() {
                _moreLoading = false;
              });
            });
          }
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData userData;
    List<FinishedWorkout> finishedWorkouts;

    if (!_isLoading) {
      userData = usersProvider.userData;
      finishedWorkouts = usersProvider.finishedWorkouts;
    }

    return _isLoading
        ? Global().loadingIndicator(context)
        : Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            width: double.infinity,
            color: Global().canvasColor,
            child: finishedWorkouts.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: finishedWorkouts.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CustomTitle('Ogólne'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  circle(
                                      context,
                                      userData.finishedWorkouts.toString(),
                                      'Wszystkie treningi'),
                                ],
                              ),
                              CustomTitle('Historia treningów')
                            ]);
                      } else if (index == finishedWorkouts.length+1) {
                        return MoreLoadingIndicator(_moreLoading);
                      } else {
                        return finishedWorkoutCard(finishedWorkouts[index - 1]);
                      }
                    },
                  )
                : Center(
                    child: Text('Brak wykonanych treningów'),
                  ),
          );
  }

  Widget circle(context, String info, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            // color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 4.0,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Text(
              info,
              style: Theme.of(context).textTheme.display2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(title, style: Theme.of(context).textTheme.body1),
      ],
    );
  }

  Widget finishedWorkoutCard(FinishedWorkout finishedWorkout) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(finishedWorkout.imageUrl),
      ),
      title: Text(
        finishedWorkout.name,
        style: Theme.of(context).textTheme.body1.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        DateFormat('dd-MM-yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(
            finishedWorkout.date.millisecondsSinceEpoch,
          ),
        ),
        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 13),
      ),
      children: finishedWorkout.exercises.map((exercise) {
        List<dynamic> sets = exercise['sets'];
        int setCounter = 0;
        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  exercise['name'],
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sets.map((setData) {
                    setCounter += 1;
                    return Text(
                      '$setCounter\t\t\t\t ${setData['reps']} x ${setData['weight']} kg',
                      style: Theme.of(context).textTheme.body1,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
