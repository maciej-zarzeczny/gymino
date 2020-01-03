import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';

class UserProfileScreen extends StatelessWidget {
  final AuthProvider _authProvider = AuthProvider();

  void signOut() async {
    await _authProvider.signOut();
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: signOut,
            child: Text('Wyloguj się'),
          ),
          Text('${userData.name} ${userData.surname} (${userData.age})'),
          Text(userData.trainingGoal),
          Text(userData.trainingType),
          Text(userData.experienceLevel),
        ],
      ),
    );
  }
}
