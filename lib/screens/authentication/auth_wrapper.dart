import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../providers/users_provider.dart';
import '../../models/user.dart';
import './login_screen.dart';
import '../home_screen.dart';

class AuthWrapper extends StatelessWidget {
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    if (user == null) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      return LoginScreen();
    } else {
      if (usersProvider.userData == null ||
          usersProvider.userData.uid != user.uid) {            
        usersProvider.getUserData(user.uid);        
      }
      return HomeScreen();
    }
  }
}
