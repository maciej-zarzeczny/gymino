import 'package:flutter/material.dart';

import '../../providers/auth_provider.dart';

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
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: Container(
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                1,
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
                  color: Colors.black26,
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
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: TextField(
                                      controller: _emailController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              width: 2.0, color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              width: 2.0, color: Colors.white),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 15.0,
                                          vertical: 15.0,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person_outline,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        hintText: 'Nazwa uzytkownika',
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      cursorColor: Colors.white,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: TextField(
                                      controller: _passwordController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              width: 2.0, color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                              width: 2.0, color: Colors.white),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      obscureText: true,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: signIn,
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 4.0,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                        vertical: 15.0,
                                      ),
                                      child: Text(
                                        'Zaloguj',
                                        textAlign: TextAlign.center,
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
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
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
