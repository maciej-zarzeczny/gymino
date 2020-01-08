import 'package:flutter/material.dart';
import 'dart:ui';

import '../../widgets/button.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_input.dart';

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
  int _currentView = 0;
  List<int> _choosedGoals = [];

  List<String> _questions = [
    'Płeć',
    'Jaki jest Twój cel treningowy ?',
    'Wprowadź swoje dane',
  ];
  List<String> _trainingGoals = [
    'Budowanie masy mięśniowej',
    'Redukacja tkanki tłuszczowej',
    'Zwiększenie siły',
    'Nauka technik',
  ];

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

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login_image.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(                        
                        constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                            minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(                          
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).padding.top +
                                          10.0,
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
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.1),
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  _questions[_currentView],
                                  style: Theme.of(context).textTheme.title,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(                                
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                                  child: _views[_currentView],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  progressIndicator(
                                    context,
                                    [
                                      _currentView >= 0,
                                      _currentView >= 1,
                                      _currentView >= 2,
                                      _currentView >= 3
                                    ],
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom +
                                          10,
                                    ),
                                    child: Button(
                                      text: _currentView == _views.length - 1
                                          ? 'Utwórz konto'
                                          : 'Dalej',
                                      onTapFunction:
                                          _currentView == _views.length - 1
                                              ? signUp
                                              : nextQuestion,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget insertDataView(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomTextInput(
          hintText: 'Imię',
          icon: Icons.person_outline,
          controller: _nameController,
          isPassword: false,
        ),
        CustomTextInput(
          hintText: 'Adres email',
          icon: Icons.email,
          controller: _emailController,
          isPassword: false,
        ),
        CustomTextInput(
          hintText: 'Hasło',
          icon: Icons.lock_outline,
          controller: _passwordController,
          isPassword: true,
        ),
      ],
    );
  }

  Widget chooseGenderView(context) {
    return Row(
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
    );
  }

  Widget chooseGoalView(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _trainingGoals.map((element) {
        var index = _trainingGoals.indexOf(element);
        return GestureDetector(
          onTap: () => setGoal(index),
          child: optionItem(
            context,
            element,
            _choosedGoals.contains(index),
          ),
        );
      }).toList(),
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
