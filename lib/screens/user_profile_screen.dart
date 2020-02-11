import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

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
  bool _saveData = false;
  bool _showInitialInfo = true;
  UserData userData;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

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

  void _showSaveButton() {
    setState(() => _saveData = true);
  }

  void saveData(UserData userData) async {
    setState(() => _isLoading = true);
    await Provider.of<UsersProvider>(context, listen: false).updateUserData(userData).then((_) {
      setState(() {
        _saveData = false;
        _isLoading = false;
      });
    }).catchError((err) {
      Global().showAlertDialog(
        context,
        'Błąd',
        'Wystąpił błąd podczas łączenia z serwerem, spróbuj ponownie późniem',
        'Ok',
        () => Navigator.of(context).pop(),
      );
    });
  }

  void changeGender(String gender) {
    if (gender != userData.genderName) {
      setState(() {
        _saveData = true;
        userData.genderName = gender;
      });
    }
    Navigator.of(context, rootNavigator: true).pop('Discard');
  }

  void changeTrainingType(String trainingType) {
    if (trainingType != userData.trainingTypeName) {
      setState(() {
        _saveData = true;
        userData.trainingTypeName = trainingType;
      });
    }
    Navigator.of(context, rootNavigator: true).pop('Discard');
  }

  void changeExperienceLevel(String experienceLevel) {
    if (experienceLevel != userData.experienceLevelName) {
      setState(() {
        _saveData = true;
        userData.experienceLevelName = experienceLevel;
      });
    }
    Navigator.of(context, rootNavigator: true).pop('Discard');
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<UsersProvider>(context).userData;

    final List<Widget> _genderOptions = userData.genderNames.map((gender) {
      return Platform.isIOS
          ? CupertinoActionSheetAction(
              child: Text(
                gender,
                style: Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).iconTheme.color),
              ),
              onPressed: () => changeGender(gender),
            )
          : FlatButton(
              child: Text(
                gender,
                style: Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).iconTheme.color),
              ),
              onPressed: () => changeGender(gender),
            );
    }).toList();

    final List<Widget> _trainingTypeOptions = userData.trainingTypeNames.map((trainingType) {
      return Platform.isIOS
          ? CupertinoActionSheetAction(
              child: Text(
                trainingType,
                style: Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).iconTheme.color),
              ),
              onPressed: () => changeTrainingType(trainingType),
            )
          : FlatButton(
              child: Text(
                trainingType,
                style: Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).iconTheme.color),
              ),
              onPressed: () => changeTrainingType(trainingType),
            );
    }).toList();

    final List<Widget> _experienceLevelOptions = userData.experienceLevelNames.map((experienceLevel) {
      return Platform.isIOS
          ? CupertinoActionSheetAction(
              child: Text(
                experienceLevel,
                style: Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).iconTheme.color),
              ),
              onPressed: () => changeExperienceLevel(experienceLevel),
            )
          : FlatButton(
              child: Text(
                experienceLevel,
                style: Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).iconTheme.color),
              ),
              onPressed: () => changeExperienceLevel(experienceLevel),
            );
    }).toList();

    if (_user != null && _showInitialInfo) {
      _showInitialInfo = false;
      _nameController.text = userData.name;
      _emailController.text = _user.email;
    }

    return _isLoading
        ? Global().loadingIndicator(context)
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              color: Global().canvasColor,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomTitle('Ogólne informacje'),
                        _saveData
                            ? FlatButton(
                                onPressed: () => saveData(userData),
                                child: Text(
                                  'Zapisz',
                                  style: Theme.of(context).textTheme.button.copyWith(
                                        color: Theme.of(context).accentColor,
                                      ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    textEditField(context, _emailController, 'Email', userData, true),
                    Divider(color: Global().darkGrey),
                    textEditField(context, _nameController, 'Imię', userData, false),
                    Divider(color: Global().darkGrey),
                    pickerField(context, 'Płeć', userData.genderName, _genderOptions),
                    Divider(color: Global().darkGrey),
                    pickerField(context, 'Rodzaj treningu', userData.trainingTypeName, _trainingTypeOptions),
                    Divider(color: Global().darkGrey),
                    pickerField(context, 'Poziom', userData.experienceLevelName, _experienceLevelOptions),
                    Divider(color: Global().darkGrey),
                    CustomTitle('Aktywne subskrypcje'),
                  ],
                ),
              ),
            ),
          );
  }

  Widget textEditField(context, TextEditingController controller, String labelText, UserData userData, bool readOnly) {
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
                    fontWeight: readOnly ? FontWeight.normal : FontWeight.bold,
                    color: readOnly ? Global().darkGrey : Theme.of(context).primaryColor,
                  ),
              onChanged: (text) {
                if (labelText == 'Imię') {
                  userData.name = text;
                }
                _showSaveButton();
              },
              readOnly: readOnly,
            ),
          ),
        ],
      ),
    );
  }

  void _cupertinoModalPopup(BuildContext context, String labelText, List<Widget> options) {
    showCupertinoModalPopup(
      context: context,
      builder: (builder) {
        return CupertinoActionSheet(
          title: Text('Wybierz ${labelText.toLowerCase()}'),
          actions: options,
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('Discard');
            },
            child: Text(
              'Anuluj',
              style: Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).iconTheme.color),
            ),
          ),
        );
      },
    );
  }

  void _modalBottomSheet(BuildContext context, List<Widget> options) {
    showModalBottomSheet(
      context: context,
      builder: (buildContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options,
          ),
        );
      },
    );
  }

  Widget pickerField(context, String labelText, String value, List<Widget> options) {
    return GestureDetector(
      onTap: () {
        Platform.isIOS ? _cupertinoModalPopup(context, labelText, options) : _modalBottomSheet(context, options);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.5) - 22.5,
              child: Text(
                labelText,
                style: Theme.of(context).textTheme.body1.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Global().darkGrey,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 5.0),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.body1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
