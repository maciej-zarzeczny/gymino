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
    String name = '';
    String gender = '';
    String trainingGoal = '';
    if (userData != null) {
      name = userData.name;
      gender = userData.gender;
      trainingGoal = userData.trainingGoal;
    }

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
          Text('$name ($gender)'),
          Text(trainingGoal),          
        ],
      ),
    );
  }
}
