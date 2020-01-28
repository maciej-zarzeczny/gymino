import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

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
  bool _showAppBar = false;

  @override
  void initState() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      );
    }
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 2) {
        _showAppBar = true;
      } else {
        _showAppBar = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      elevation: 5.0,
      centerTitle: true,
      title: Text('Zapisane treningi'),
    );

    List<Widget> _views = [
      TrainersScreen(),
      Center(
        child: Text('Szukaj...'),
      ),
      SavedWorkoutsScreen.withAppBar(appBar.preferredSize.height),
      UserProfileScreen(),
    ];

    return Scaffold(
      appBar: _showAppBar ? appBar : null,
      body: _views[_currentIndex],
      bottomNavigationBar: NavigationBar(
        onItemTapped: _onItemTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}
