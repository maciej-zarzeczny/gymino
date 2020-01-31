import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';
import '../screens/workout_overview_screen.dart';
import '../widgets/badge.dart';
import '../providers/workouts_provider.dart';

class SavedWorkoutsScreen extends StatefulWidget {
  static const String routeName = '/savedWorkouts';

  SavedWorkoutsScreen();

  double appBarHeight;
  SavedWorkoutsScreen.withAppBar(this.appBarHeight);

  @override
  _SavedWorkoutsScreenState createState() => _SavedWorkoutsScreenState();
}

class _SavedWorkoutsScreenState extends State<SavedWorkoutsScreen> {
  UsersProvider usersProvider;

  @override
  Widget build(BuildContext context) {
    usersProvider = Provider.of<UsersProvider>(context);
    final Map<dynamic, dynamic> savedWorkouts =
        usersProvider.userData.savedWorkouts;

    String _difficultyToString(int number) {
      if (number == 0)
        return 'POCZĄTKUJĄCY';
      else if (number == 1)
        return 'ŚREDNI';
      else
        return 'ZAAWANSOWANY';
    }

    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      width: double.infinity,
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.bottom -
          MediaQuery.of(context).padding.top -
          widget.appBarHeight,
      color: Colors.white,
      child: savedWorkouts.isNotEmpty ? ListView.builder(
        padding: const EdgeInsets.all(0.0),
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
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Usunięto z ulubionych")));
            },
            child: savedWorkoutCard(
              context,
              id,
              savedWorkouts.values.elementAt(index)['imageUrl'],
              savedWorkouts.values.elementAt(index)['name'],
              _difficultyToString(
                  savedWorkouts.values.elementAt(index)['difficulty']),
              savedWorkouts.values.elementAt(index)['duration'],
              savedWorkouts.values.elementAt(index)['trainerId'],
            ),
          );
        },
      ) : Center(child: Text('Brak zapisanych treningów'),),
    );
  }

  Widget savedWorkoutCard(context, String id, String imageUrl, String name,
      String difficulty, int duration, String trainerId) {
    return GestureDetector(
      onTap: () {
        Provider.of<WorkoutsProvider>(context, listen: false).currentTrainerId =
            trainerId;
        Navigator.of(context)
            .pushNamed(WorkoutOverviewScreen.routeName, arguments: id);
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.2,
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                width: double.infinity,
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(15.0),
              child: Text(
                name,
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Badge(difficulty, false),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.watch_later,
                    color: Colors.white,
                    size: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      '$duration min',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
