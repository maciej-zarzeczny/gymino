import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../providers/auth_provider.dart';
import './register_screen.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_text_input.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthProvider _authProvider = AuthProvider();

  bool _isLoading = false;

  void signIn() async {
    setState(() => _isLoading = true);
    dynamic result = await _authProvider.signInWithEmailAndPassword(
        _emailController.text, _passwordController.text);
    if (result == null) {
      setState(() => _isLoading = false);
    }
  }

  void signInWithGoogle() async {
    setState(() => _isLoading = true);
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
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Image(
                  width: double.infinity,
                  height: double.infinity,
                  image: AssetImage('assets/images/login_image.jpg'),
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black45,
                ),
                _isLoading
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image:
                                  AssetImage('assets/images/sqilly_logo.png'),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Column(
                                children: <Widget>[
                                  CustomTextInput(hintText: 'Adres email', controller: _emailController, icon: Icons.person_outline, isPassword: false,),
                                  CustomTextInput(hintText: 'Hasło', controller: _passwordController, icon: Icons.lock_outline, isPassword: true,),                                                                    
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
                                  GestureDetector(
                                    onTap: signInWithGoogle,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 4.0,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 15.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                            width: 25,
                                            height: 25,
                                            image: AssetImage(
                                                'assets/images/google_logo.png'),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              'Zaloguj przez Google',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                _isLoading
                    ? Container()
                    : GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, RegisterScreen.routeName),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom + 10,
                          ),
                          child: Align(
                            child: Text(
                              'Nie masz konta? Zarejestruj się',
                              style:
                                  Theme.of(context).textTheme.display3.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
