import 'package:flutter/material.dart';

import '../globals.dart';
import '../providers/auth_provider.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  final AuthProvider _authProvider = AuthProvider();

  void signOut() async {
    await _authProvider.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Global().canvasColor,
      child: Center(
        child: FlatButton(
          onPressed: signOut,
          child: Text('Wyloguj sie'),
        ),
      ),
    );
  }
}
