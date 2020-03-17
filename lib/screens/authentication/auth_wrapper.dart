import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../models/user.dart';
import './login_screen.dart';
import '../home_screen.dart';

class AuthWrapper extends StatefulWidget {
  static const String routeName = '/';

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showSplashScreen = true;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      setState(() {
        _showSplashScreen = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (_showSplashScreen) {
      return splashScreen(context);
    } else {
      if (user == null) {
        return LoginScreen();
      } else {
        return HomeScreen();
      }
    }
  }

  Widget splashScreen(BuildContext context) {
    final AppBar _appBar = AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 0.0,
      brightness: Platform.isIOS ? Brightness.light : Brightness.dark,
    );
    return Scaffold(
      appBar: _appBar,
      backgroundColor: Theme.of(context).canvasColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,        
      ),
    );
  }
}
