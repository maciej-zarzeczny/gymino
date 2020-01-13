import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../providers/auth_provider.dart';
import './register_screen.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_text_input.dart';
import '../../globals.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _globals = Global();

  final AuthProvider _authProvider = AuthProvider();

  bool _isLoading = false;

  void signIn() async {    
    setState(() => _isLoading = true);

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    dynamic result = await _authProvider.signInWithEmailAndPassword(
        _emailController.text.trim(), _passwordController.text.trim());    

    String _errTitle;
    String _errSubtitle;

    switch(result) {
      case 'ERROR_WRONG_PASSWORD':
        _errTitle = 'Błąd logowania';
        _errSubtitle = 'Podany email lub hasło są nieprawidłowe.';
        break;     

      case 'ERROR_USER_NOT_FOUND':
        _errTitle = 'Błąd logowania';
        _errSubtitle = 'Podany email lub hasło są nieprawidłowe.';
        break; 

      case 'ERROR_INVALID_EMAIL':
        _errTitle = 'Błąd logowania';
        _errSubtitle = 'Podany email lub hasło są nieprawidłowe.';
        break;

      default :
        _errTitle = 'Bład logowania';
        _errSubtitle = 'Podczas logowania wystąpił błąd spróbuj jeszcze raz.';
        break;
    }

    setState(() => _isLoading = false);

    _globals.showAlertDialog(
        context,
        _errTitle,
        _errSubtitle,
        'Ok',
        () => Navigator.of(context).pop(),
      );
  }

  void signInWithGoogle() async {    
    setState(() => _isLoading = true);

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    dynamic result = await _authProvider.signInWithGoogle();
    if (result == null) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
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
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top +
                                  MediaQuery.of(context).size.width * 0.2,
                              bottom: 10.0,
                            ),
                            child: Image(
                              image:
                                  AssetImage('assets/images/sqilly_logo.png'),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CustomTextInput(
                                  hintText: 'Adres email',
                                  controller: _emailController,
                                  icon: Icons.person_outline,
                                  isPassword: false,
                                ),
                                CustomTextInput(
                                  hintText: 'Hasło',
                                  controller: _passwordController,
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                ),
                                Button(
                                  text: 'Zaloguj',
                                  onTapFunction: signIn,
                                ),
                                Text(
                                  'Lub',
                                  style: Theme.of(context)
                                      .textTheme
                                      .display3
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                GoogleSignInButton(signInWithGoogle),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, RegisterScreen.routeName),
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).padding.bottom + 10,
                              ),
                              child: Text(
                                'Nie masz konta? Zarejestruj się',
                                style: Theme.of(context)
                                    .textTheme
                                    .display3
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
      ),
    );
  }
}
