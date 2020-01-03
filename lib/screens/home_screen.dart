import 'package:flutter/material.dart';

import '../widgets/navigation_bar.dart';
import './trainers_screen.dart';
import '../screens/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;  

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = [
      TrainersScreen(),
      Center(
        child: Text('Szukaj...'),
      ),
      TrainersScreen(),
      UserProfileScreen(),
    ];

    return Scaffold(
      body: _views[_currentIndex],
      bottomNavigationBar: NavigationBar(
        onItemTapped: _onItemTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}
