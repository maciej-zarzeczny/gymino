import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sqilly/providers/users_provider.dart';
import './globals.dart';
import './providers/trainers_provider.dart';
import './providers/workouts_provider.dart';
import './providers/auth_provider.dart';
import './screens/home_screen.dart';
import './screens/trainer_workouts_screen.dart';
import './screens/workout_overview_screen.dart';
import './screens/workout_screen.dart';
import './screens/exercise_overview_screen.dart';
import './screens/trainer_info_screen.dart';
import './screens/authentication/login_screen.dart';
import './screens/authentication/auth_wrapper.dart';
import './screens/authentication/register_screen.dart';
import './screens/saved_workouts_screen.dart';
import './models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TrainersProvider(),
        ),
        ChangeNotifierProvider.value(
          value: WorkoutsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: UsersProvider(),
        ),
        StreamProvider<User>.value(
          value: AuthProvider().user,
        ),
      ],
      child: MaterialApp(
        title: 'SQILLY',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF1A1A1A, Global().primaryColor),
          accentColor: Color.fromRGBO(224, 22, 22, 1),
          fontFamily: 'SF-Pro-Display',
          iconTheme: IconThemeData(
            color: Color.fromRGBO(26, 26, 26, 1.0),
          ),
          // fontFamily: 'Roboto',
          textTheme: TextTheme(
            title: TextStyle(
              color: Color.fromRGBO(26, 26, 26, 1.0),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
            display1: TextStyle(
              color: Color.fromRGBO(26, 26, 26, 1.0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            display2: TextStyle(
              color: Global().canvasColor,
              fontSize: 25,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.7,
            ),
            overline: TextStyle(
              color: Global().darkGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            body1: TextStyle(
                color: Color.fromRGBO(26, 26, 26, 1.0),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8),
            body2: TextStyle(
              color: Global().darkGrey,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            button: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Global().canvasColor,
            ),
          ),
        ),
        darkTheme: ThemeData(
          primarySwatch: MaterialColor(0xFF1A1A1A, Global().primaryColor),
          accentColor: Color.fromRGBO(224, 22, 22, 1),
          fontFamily: 'SF-Pro-Display',
          canvasColor: Color.fromRGBO(26, 26, 26, 1.0),
          iconTheme: IconThemeData(
            color: Global().canvasColor,
          ),
          textTheme: TextTheme(
            title: TextStyle(
              color: Global().canvasColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
            display1: TextStyle(
              color: Color.fromRGBO(26, 26, 26, 1.0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            display2: TextStyle(
              color: Global().canvasColor,
              fontSize: 25,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.7,
            ),
            overline: TextStyle(
              color: Global().darkGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            body1: TextStyle(
                color: Color.fromRGBO(26, 26, 26, 1.0),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8),
            body2: TextStyle(
              color: Global().darkGrey,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            button: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Global().canvasColor,
            ),
          ),
        ),
        initialRoute: AuthWrapper.routeName,
        routes: {
          AuthWrapper.routeName: (context) => AuthWrapper(),
          LoginScreen.routeName: (context) => LoginScreen(),
          RegisterScreen.routeName: (context) => RegisterScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          TrainerWorkoutsScreen.routeName: (context) => TrainerWorkoutsScreen(),
          WorkoutOverviewScreen.routeName: (context) => WorkoutOverviewScreen(),
          WorkoutScreen.routeName: (context) => WorkoutScreen(),
          ExerciseOverviewScreen.routeName: (context) =>
              ExerciseOverviewScreen(),
          TrainerInfoScreen.routeName: (context) => TrainerInfoScreen(),
          SavedWorkoutsScreen.routeName: (context) => SavedWorkoutsScreen(),
        },
      ),
    );
  }
}
