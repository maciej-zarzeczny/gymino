import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../providers/auth_provider.dart';
import '../providers/users_provider.dart';
import '../models/user.dart';
import '../widgets/custom_title.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthProvider _authProvider = AuthProvider();
  FirebaseUser _user;
  bool _isLoading = true;

  @override
  void initState() {
    Future.microtask(() {
      _authProvider.getSignedInUser().then((user) {
        _user = user;
        setState(() {
          _isLoading = false;
        });
      });
    });

    super.initState();
  }

  void signOut() async {
    await _authProvider.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UsersProvider>(context).userData;

    String _gender;
    String _trainingType;
    String _experienceLevel;
    TextEditingController _nameController = TextEditingController();
    TextEditingController _genderController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _trainingTypeController = TextEditingController();
    TextEditingController _experienceLevelController = TextEditingController();

    if (userData != null && _user != null) {
      switch (userData.gender) {
        case 0:
          _gender = 'Mężczyzna';
          break;

        case 1:
          _gender = 'Kobieta';
          break;
      }
      switch (userData.trainingType) {
        case 0:
          _trainingType = 'Siłownia';
          break;

        case 1:
          _trainingType = 'Kalistenika';
          break;

        case 2:
          _trainingType = 'Hybrydowy';
          break;
      }
      switch (userData.experienceLevel) {
        case 1:
          _experienceLevel = 'Początkujący';
          break;

        case 2:
          _experienceLevel = 'Średniozaawansowany';
          break;

        case 3:
          _experienceLevel = 'Zaawansowany';
          break;
      }
      setState(() {
        _nameController.text = userData.name;
        _genderController.text = _gender;
        _emailController.text = _user.email;
        _trainingTypeController.text = _trainingType;
        _experienceLevelController.text = _experienceLevel;
      });
    }

    return _isLoading
        ? Global().loadingIndicator(context)
        : Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            color: Global().canvasColor,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomTitle('Ogólne informacje'),
                  textEditField(context, _nameController, 'Imię'),
                  Divider(color: Global().darkGrey),
                  textEditField(context, _emailController, 'Email'),
                  Divider(color: Global().darkGrey),
                  textEditField(context, _genderController, 'Płeć'),
                  Divider(color: Global().darkGrey),
                  textEditField(context, _trainingTypeController, 'Rodzaj treningu'),
                  Divider(color: Global().darkGrey),
                  textEditField(
                      context, _experienceLevelController, 'Poziom zaawansowania'),
                  Divider(color: Global().darkGrey),
                ],
              ),
            ),
          );
  }

  Widget textEditField(
      context, TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            labelText,
            style: Theme.of(context).textTheme.body1.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Global().darkGrey,
                ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.body1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
