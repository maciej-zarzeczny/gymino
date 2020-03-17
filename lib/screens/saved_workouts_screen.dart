import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../globals.dart';
import '../providers/users_provider.dart';
import '../screens/workout_overview_screen.dart';
import '../widgets/difficulty_level.dart';
import '../providers/workouts_provider.dart';

class SavedWorkoutsScreen extends StatefulWidget {
  static const String routeName = '/savedWorkouts';

  @override
  _SavedWorkoutsScreenState createState() => _SavedWorkoutsScreenState();
}

class _SavedWorkoutsScreenState extends State<SavedWorkoutsScreen> {
  UsersProvider usersProvider;

  @override
  Widget build(BuildContext context) {
    usersProvider = Provider.of<UsersProvider>(context);
    final Map<dynamic, dynamic> savedWorkouts = usersProvider.userData.savedWorkouts;

    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      width: double.infinity,
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - MediaQuery.of(context).padding.top,
      color: Global().canvasColor,
      child: savedWorkouts.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: savedWorkouts.length,
              itemBuilder: (context, index) {
                String id = savedWorkouts.keys.elementAt(index);
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
                  onDismissed: (direction) {
                    usersProvider.removeWorkoutFromFavourites(id);
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Usunięto z ulubionych")));
                  },
                  child: savedWorkoutCard(
                    context,
                    id,
                    savedWorkouts.values.elementAt(index)['imageUrl'],
                    savedWorkouts.values.elementAt(index)['name'],
                    savedWorkouts.values.elementAt(index)['difficulty'],
                    savedWorkouts.values.elementAt(index)['duration'],
                    savedWorkouts.values.elementAt(index)['trainerId'],
                  ),
                );
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
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.2,
        constraints: BoxConstraints(minHeight: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl),
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
                      maxLines: 2,
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
    );
  }
}
