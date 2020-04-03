import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../globals.dart';
import '../providers/users_provider.dart';
import '../screens/workout_overview_screen.dart';
import '../widgets/difficulty_level.dart';
import '../providers/workouts_provider.dart';
import '../models/workout.dart';
import '../widgets/more_loading_indicator.dart';

class SavedWorkoutsScreen extends StatefulWidget {
  static const String routeName = '/savedWorkouts';

  @override
  _SavedWorkoutsScreenState createState() => _SavedWorkoutsScreenState();
}

class _SavedWorkoutsScreenState extends State<SavedWorkoutsScreen> {
  UsersProvider usersProvider;
  bool _isLoading = true;
  bool _moreLoading = false;
  bool _loadMoreButton = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Future.microtask(() {
      usersProvider = Provider.of<UsersProvider>(context, listen: false);
      if (usersProvider.savedWorkouts.isEmpty) {
        usersProvider.fetchSavedWorkotus().then((_) {
          setState(() {
            _isLoading = false;
          });
        }).catchError((err) {
          setState(() => _isLoading = false);
          Global().showAlertDialog(
            context,
            'Błąd',
            'Podczas łączenia z serwerem wystąpił błąd, spróbuj ponownie później.',
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
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadMoreButton = false;
          _moreLoading = true;
        });

        if (!usersProvider.allSavedWorkoutsLoaded) {
          usersProvider.fetchMoreSavedWorkouts().then((_) {
            setState(() {
              _moreLoading = false;
            });
          });
        } else {
          double edge = 50.0;
          double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            _scrollController
                .animateTo(_scrollController.offset - (edge - offsetFromBottom), duration: new Duration(milliseconds: 500), curve: Curves.easeOut)
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

  void removeFromFavourites(String id) async {
    usersProvider.removeWorkoutFromFavourites(id).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Usunięto z ulubionych")));
    }).catchError((err) {
      Global().showAlertDialog(
        context,
        'Błąd',
        'Podczas usuwania treningu z ulubionych wystąpił błąd, spróbuj ponownie później.',
        'Ok',
        () => Navigator.of(context).pop(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    UsersProvider _usersProvider = Provider.of<UsersProvider>(context);
    List<SavedWorkout> savedWorkouts = _usersProvider.savedWorkouts;

    if (_usersProvider.allSavedWorkoutsLoaded) {
      _loadMoreButton = false;
    }

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: const EdgeInsets.only(top: 20.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - MediaQuery.of(context).padding.top,
            color: Global().canvasColor,
            child: savedWorkouts.isNotEmpty
                ? ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: savedWorkouts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == savedWorkouts.length) {
                        return _loadMoreButton
                            ? FlatButton(
                                onPressed: () async {
                                  setState(() {
                                    _loadMoreButton = false;
                                    _moreLoading = true;
                                  });
                                  await usersProvider.fetchSavedWorkotus().then((_) {
                                    setState(() => _moreLoading = false);
                                  });
                                },
                                child: Text(
                                  'Pokaż więcej',
                                  style: Theme.of(context).textTheme.button.copyWith(
                                        color: Theme.of(context).accentColor,
                                      ),
                                ),
                              )
                            : MoreLoadingIndicator(_moreLoading);
                      } else {
                        String id = savedWorkouts[index].id;
                        return Dismissible(
                          key: Key(id),
                          background: Container(
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(context).accentColor,
                              size: 50,
                            ),
                            alignment: Alignment.centerRight,
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) => removeFromFavourites(id),
                          child: savedWorkoutCard(
                            context,
                            id,
                            savedWorkouts[index].imageUrl,
                            savedWorkouts[index].name,
                            savedWorkouts[index].difficulty,
                            savedWorkouts[index].duration,
                            savedWorkouts[index].trainerId,
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10.0),
                  )
                : Center(
                    child: Text('Brak zapisanych treningów'),
                  ),
          );
  }

  Widget savedWorkoutCard(context, String id, String imageUrl, String name, int difficulty, int duration, String trainerId) {
    return GestureDetector(
      onTap: () {
        Provider.of<WorkoutsProvider>(context, listen: false).currentTrainerId = trainerId;
        Navigator.of(context).pushNamed(WorkoutOverviewScreen.routeName, arguments: id);
      },
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Center(
          child: Icon(
            Icons.image,
            color: Global().darkGrey,
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: Icon(
            Icons.broken_image,
            color: Global().darkGrey,
          ),
        ),
        imageBuilder: (context, imageProvider) => Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.2,
          constraints: BoxConstraints(minHeight: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Global().mediumGrey,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: Theme.of(context).textTheme.display1.copyWith(
                              color: Global().canvasColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.0),
                      DifficultyLevel(difficulty),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(26, 26, 26, 0.7),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: Global().canvasColor,
                          size: 15,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          '$duration min',
                          style: Theme.of(context).textTheme.overline.copyWith(
                                color: Global().canvasColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
