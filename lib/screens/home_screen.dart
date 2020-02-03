import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/statistics_screen.dart';
import '../widgets/navigation_bar.dart';
import './trainers_screen.dart';
import '../screens/user_profile_screen.dart';
import '../screens/saved_workouts_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<String> _titles = [
    'TRENERZY',
    'STATYSTYKI',
    'ZAPISANE TRENINGI',
    'PROFIL',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        _titles[_currentIndex],
        style: Theme.of(context).textTheme.title,
      ),
      backgroundColor: Theme.of(context).canvasColor, 
      brightness: Brightness.light,     
  
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {    
    List<Widget> _views = [
      TrainersScreen(),
      StatisticsScreen(),
      SavedWorkoutsScreen(),
      UserProfileScreen(),
    ];

    return Scaffold(
      appBar: _appBar(),
      body: _views[_currentIndex],
      bottomNavigationBar: NavigationBar(
        onItemTapped: _onItemTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}
