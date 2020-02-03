import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../../models/user.dart';
import '../../widgets/button.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_input.dart';
import '../../globals.dart';

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
  final _passwordCheckController = TextEditingController();
  final _globals = Global();

  bool _isLoading = false;
  int _currentView = 0;
  List<int> _choosedOptions = [-1, -1, -1];

  List<String> _questions = [
    'Płeć',
    'Jaki jest Twój cel treningowy ?',
    'Jak oceniasz swój poziom zaawansowania ?',
    'Wprowadź swoje dane',
  ];
  List<String> _trainingGoals = [
    'Budowanie masy mięśniowej',
    'Redukacja tkanki tłuszczowej',
    'Zwiększenie siły',
    'Nauka technik',
  ];
  List<String> _experienceLevels = [
    'Początkujący',
    'Średniozaawansowany',
    'Zaawansowany',
  ];

  void signUp() async {
    setState(() => _isLoading = true);

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    dynamic result = await _authProvider.registerWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _nameController.text.trim(),
      _choosedOptions[0],
      _choosedOptions[1],
      _choosedOptions[2],
    );

    setState(() => _isLoading = false);

    if (result.runtimeType == User) {
      Navigator.of(context).pop();
    } else {
      String _errTitle;
      String _errSubtitle;

      switch (result) {
        case 'ERROR_INVALID_EMAIL':
          _errTitle = 'Nieprawidłowy adres email';
          _errSubtitle =
              'Wprowadzony adres email jest niepoprawny. Spróbuj jeszcze raz';
          break;

        case 'ERROR_WEAK_PASSWORD':
          _errTitle = 'Za krótkie hasło';
          _errSubtitle = 'Hasło musi mieć co najmniej 6 znaków';
          break;

        case 'ERROR_EMAIL_ALREADY_IN_USE':
          _errTitle = 'Adres email już istnieje';
          _errSubtitle = 'Konto z podanym adresem email już istnieje.';
          break;

        default:
          _errTitle = 'Błąd';
          _errSubtitle =
              'Podczas rejestracji wystąpił błąd. Spróbuj jeszcze raz.';
          break;
      }

      _globals.showAlertDialog(
        context,
        _errTitle,
        _errSubtitle,
        'Ok',
        () => Navigator.of(context).pop(),
      );
    }
  }

  int verifyData() {
    String _name = _nameController.text.trim();
    String _email = _emailController.text.trim();
    String _password = _passwordController.text.trim();
    String _passwordCheck = _passwordCheckController.text.trim();

    if (_name.isEmpty || _email.isEmpty || _password.isEmpty) {
      return 1;
    } else if (_password != _passwordCheck) {
      return 2;
    } else {
      return 0;
    }
  }

  void nextQuestion() {
    if (_currentView < _questions.length - 1 &&
        _choosedOptions[_currentView] == -1) {
      _globals.showAlertDialog(
        context,
        'Brak wybranej opcji',
        'Wybierz jedną z podanych opcji',
        'Ok',
        () => Navigator.of(context).pop(),
      );
    } else if (_currentView < _questions.length - 1) {
      setState(() => _currentView += 1);
    } else {
      int result = verifyData();
      if (result == 1) {
        _globals.showAlertDialog(
          context,
          'Niektóre pola są puste',
          'Wypełnij wszystkie wymagane pola',
          'Ok',
          () => Navigator.of(context).pop(),
        );
      } else if (result == 2) {
        _globals.showAlertDialog(
          context,
          'Podane hasła różnią się',
          '',
          'Ok',
          () => Navigator.of(context).pop(),
        );
      } else if (result == 0) {
        signUp();
      }
    }
  }

  void setGender(int choice) {
    setState(() {
      _choosedOptions[0] = choice;
    });
  }

  void setGoal(int choice) {
    setState(() {
      _choosedOptions[1] = choice;
    });
  }

  void setExperienceLevel(int choice) {
    setState(() {
      _choosedOptions[2] = choice;
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
      experienceLevelView(context),
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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(new FocusNode()),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                icon: Global().backArrow(),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    _questions[_currentView],
                                    style: Theme.of(context).textTheme.display2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: _views[_currentView],
                                ),
                              ],
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
                                    bottom:
                                        MediaQuery.of(context).padding.bottom +
                                            10,
                                  ),
                                  child: Button(
                                    text: _currentView == _views.length - 1
                                        ? 'Utwórz konto'
                                        : 'Dalej',
                                    onTapFunction: nextQuestion,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
          color: Colors.white,
          withIcon: true,
        ),
        CustomTextInput(
          hintText: 'Adres email',
          icon: Icons.email,
          controller: _emailController,
          isPassword: false,
          color: Colors.white,
          withIcon: true,
        ),
        CustomTextInput(
          hintText: 'Hasło',
          icon: Icons.lock_outline,
          controller: _passwordController,
          isPassword: true,
          color: Colors.white,
          withIcon: true,
        ),
        CustomTextInput(
          hintText: 'Powtórz hasło',
          icon: Icons.lock_outline,
          controller: _passwordCheckController,
          isPassword: true,
          color: Colors.white,
          withIcon: true,
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
          child: genderItem(context, 'Mężczyzna', _choosedOptions[0] == 0),
        ),
        GestureDetector(
          onTap: () => setGender(1),
          child: genderItem(context, 'Kobieta', _choosedOptions[0] == 1),
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
            index == _choosedOptions[1],
          ),
        );
      }).toList(),
    );
  }

  Widget experienceLevelView(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _experienceLevels.map((element) {
        var index = _experienceLevels.indexOf(element) + 1;
        return GestureDetector(
          onTap: () => setExperienceLevel(index),
          child: optionItem(
            context,
            element,
            index == _choosedOptions[2],
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
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.2,
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
      children: _questions.map((element) {
        var index = _questions.indexOf(element);
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0),
          width: MediaQuery.of(context).size.width * 0.035,
          height: MediaQuery.of(context).size.width * 0.035,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isChecked[index] ? Theme.of(context).accentColor : Colors.white,
          ),
        );
      }).toList(),
    );
  }
}
