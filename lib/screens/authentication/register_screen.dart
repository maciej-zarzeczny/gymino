import 'package:flutter/material.dart';
import 'dart:ui';

import '../../widgets/button.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthProvider _authProvider = AuthProvider();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  int _choosedGender = 0;
  // int _choosedExperience = 0;
  // int _choosedTrainingType = 0;
  int _currentView = 0;
  List<int> _choosedGoals = [];

  void signUp() async {
    setState(() => _isLoading = true);
    dynamic result = await _authProvider.registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _choosedGender,
        _choosedGoals[0]);
    if (result == null) {
      setState(() => _isLoading = false);
    } else {
      Navigator.of(context).pop();
    }
  }

  void nextQuestion() {
    setState(() {
      if (_currentView < 2) {
        _currentView += 1;
      } else {
        signUp();
      }
    });
  }

  void setGender(int choice) {
    setState(() {
      _choosedGender = choice;
    });
  }

  void setGoal(int choice) {
    setState(() {
      if (_choosedGoals.contains(choice)) {
        _choosedGoals.remove(choice);
      } else {
        _choosedGoals.add(choice);
      }
    });
  }

  void goBack(context) {
    setState(() {
      if (_currentView > 0) {
        _currentView -= 1;
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = [
      chooseGenderView(context),
      chooseGoalView(context),
      insertDataView(context),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Image(
                  image: AssetImage('assets/images/login_image.jpg'),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black45,
                ),
                _isLoading
                    ? Container()
                    : Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 10.0,
                              left: 10.0,
                              right: 5.0,
                              bottom: 10.0),
                          onPressed: () => goBack(context),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _views[_currentView],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget insertDataView(context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.15),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                'Podaj swoje dane',
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15.0,
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 22,
                      ),
                      hintText: 'Imię',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15.0,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                        size: 22,
                      ),
                      hintText: 'Adres email',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15.0,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                        size: 22,
                      ),
                      hintText: 'Hasło',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: progressIndicator(
                    context,
                    [
                      _currentView >= 0,
                      _currentView >= 1,
                      _currentView >= 2,
                      _currentView >= 3
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: Button(
                    text: _currentView == 2 ? 'Stwórz konto' : 'Dalej',
                    onTapFunction: nextQuestion,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseGenderView(context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.15),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                'Płeć',
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => setGender(0),
                  child: genderItem(context, 'Mężczyzna', _choosedGender == 0),
                ),
                GestureDetector(
                  onTap: () => setGender(1),
                  child: genderItem(context, 'Kobieta', _choosedGender == 1),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: progressIndicator(
                    context,
                    [
                      _currentView >= 0,
                      _currentView >= 1,
                      _currentView >= 2,
                      _currentView >= 3
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: Button(
                    text: _currentView == 2 ? 'Stwórz konto' : 'Dalej',
                    onTapFunction: nextQuestion,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseGoalView(context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.15),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              'Jaki jest Twój cel treningowy ?',
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => setGoal(0),
                  child: optionItem(
                    context,
                    'Budowanie masy mięśniowej',
                    _choosedGoals.contains(0),
                  ),
                ),
                GestureDetector(
                  onTap: () => setGoal(1),
                  child: optionItem(
                    context,
                    'Redukcja tkanki tłuszczowej',
                    _choosedGoals.contains(1),
                  ),
                ),
                GestureDetector(
                  onTap: () => setGoal(2),
                  child: optionItem(
                    context,
                    'Zwiększenie siły',
                    _choosedGoals.contains(2),
                  ),
                ),
                GestureDetector(
                  onTap: () => setGoal(3),
                  child: optionItem(
                    context,
                    'Nauka technik',
                    _choosedGoals.contains(3),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: progressIndicator(
                  context,
                  [
                    _currentView >= 0,
                    _currentView >= 1,
                    _currentView >= 2,
                    _currentView >= 3
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                child: Button(
                  text: _currentView == 2 ? 'Stwórz konto' : 'Dalej',
                  onTapFunction: nextQuestion,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget genderItem(context, String text, bool isChosen) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.4,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: isChosen ? 5.0 : 2.0,
          color: isChosen ? Theme.of(context).accentColor : Colors.white,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.body1.copyWith(
                color: isChosen ? Theme.of(context).accentColor : Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget optionItem(context, String title, bool isChosen) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.25,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: isChosen ? 5.0 : 2.0,
          color: isChosen ? Theme.of(context).accentColor : Colors.white,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.body1.copyWith(
                color: isChosen ? Theme.of(context).accentColor : Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget progressIndicator(context, isChecked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0),
          width: MediaQuery.of(context).size.width * 0.035,
          height: MediaQuery.of(context).size.width * 0.035,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isChecked[0] ? Theme.of(context).accentColor : Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0),
          width: MediaQuery.of(context).size.width * 0.035,
          height: MediaQuery.of(context).size.width * 0.035,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isChecked[1] ? Theme.of(context).accentColor : Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0),
          width: MediaQuery.of(context).size.width * 0.035,
          height: MediaQuery.of(context).size.width * 0.035,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isChecked[2] ? Theme.of(context).accentColor : Colors.white,
          ),
        ),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 3.0),
        //   width: MediaQuery.of(context).size.width * 0.035,
        //   height: MediaQuery.of(context).size.width * 0.035,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: isChecked[3] ? Theme.of(context).accentColor : Colors.white,
        //   ),
        // ),
      ],
    );
  }
}
