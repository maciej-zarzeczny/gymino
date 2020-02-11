import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';
import './users_provider.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null; 
  }

  // User stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.code);
      return error.code;
    } 
  }

  // Sign in with google
  Future signInWithGoogle() async {    
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      return user;
    } catch (error) {      
      return error;
    }
  }

  // Registering new user
  Future registerWithEmailAndPassword(String email, String password, String name, int gender, int trainingType, int experienceLevel) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // create a new document for the user with the uid
      await UsersProvider().createUserData(user.uid, name, gender, trainingType, experienceLevel);
      return _userFromFirebaseUser(user);
    } catch (error) {         
      return error.code;
    } 
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();      
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign out google
  Future<void> signOutGoogle() async {
    try {
      return await _googleSignIn.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<FirebaseUser> getSignedInUser() async {
    return await _auth.currentUser();
  }
}