import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../screens/statistics_screen.dart';
import '../widgets/navigation_bar.dart';
import './trainers_screen.dart';
import '../screens/user_profile_screen.dart';
import '../screens/saved_workouts_screen.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthProvider _authProvider = AuthProvider();
  int _currentIndex = 0;
  bool _showMoreSettings = false;

  List<String> _titles = [
    'TRENERZY',
    'STATYSTYKI',
    'ZAPISANE TRENINGI',
    'PROFIL',
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 3) {
        _showMoreSettings = true;
      } else {
        _showMoreSettings = false;
      }
      _currentIndex = index;
    });
  }

  void signOut() async {
    await _authProvider.signOut();
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
      brightness: Platform.isIOS ? Brightness.light : Brightness.dark,
      actions: <Widget>[
        _showMoreSettings
            ? PopupMenuButton(
                color: Theme.of(context).canvasColor,
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).iconTheme.color,
                ),
                onSelected: (selection) {
                  if (selection == 2) {
                    signOut();
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 0,
                    child: Text(
                      'Regulamin',
                      style: Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).iconTheme.color),
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      'Polityka prywatności',
                      style: Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).iconTheme.color),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      'Wyloguj się',
                      style: Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).iconTheme.color),
                    ),
                  ),
                ],
              )
            : Container(),
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
