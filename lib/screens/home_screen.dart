import 'package:flutter/material.dart';

import '../widgets/navigation_bar.dart';
import './trainers_screen.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthProvider _authProvider = AuthProvider();
  int _currentIndex = 0;

  void signOut() async {
    await _authProvider.signOut();
  }

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
      Center(
        child: RaisedButton(
          onPressed: signOut,          
          child: Text('Wyloguj się'),
        ),
      )
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
