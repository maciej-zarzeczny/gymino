import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/more_loading_indicator.dart';
import '../globals.dart';
import '../providers/users_provider.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../models/workout.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
            'Wystąpił błąd',
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

  final AuthProvider _authProvider = AuthProvider();

  void signOut() async {
    await _authProvider.signOut();
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
            width: double.infinity,
            color: Colors.white,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Historia treningów',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: finishedWorkouts.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Wykonane treningi - ${userData.finishedWorkouts}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      } else if (index == finishedWorkouts.length + 1) {
                        return MoreLoadingIndicator(_moreLoading);
                      } else {
                        return finishedWorkoutCard(finishedWorkouts[index - 1]);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget finishedWorkoutCard(FinishedWorkout finishedWorkout) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(finishedWorkout.imageUrl),
      ),
      title: Text(
        finishedWorkout.name,
        style: Theme.of(context).textTheme.display2,
      ),
      subtitle: Text(
        DateFormat('dd-MM-yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(
            finishedWorkout.date.millisecondsSinceEpoch,
          ),
        ),
        style: Theme.of(context).textTheme.display3,
      ),
      children: finishedWorkout.exercises.map((exercise) {
        List<dynamic> sets = exercise['sets'];
        int setCounter = 0;
        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  exercise['name'],
                  style: Theme.of(context).textTheme.display2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sets.map((setData) {
                    setCounter += 1;
                    return Text(
                      '$setCounter\t\t\t\t ${setData['reps']} x ${setData['weight']} kg',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
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
