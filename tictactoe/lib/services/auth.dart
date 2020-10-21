import 'package:tictactoe/models/appuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase user to appuser
  AppUser _userMapper(User u) {
    return u != null ? AppUser(uid: u.uid) : null;
  }

  // auth stream
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userMapper);
  }

  // Sign in Anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User u = result.user;
      return _userMapper(u);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // Sign in Email & Pass
  Future signInEmail(String email, String passw) async {
    try {
      UserCredential result = await
          _auth.signInWithEmailAndPassword(email: email, password: passw);
      User u = result.user;
      return _userMapper(u);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with Email & Password
  Future registerEmail(String email, String passw) async {
    try {
      UserCredential result = await
          _auth.createUserWithEmailAndPassword(email: email, password: passw);
      User u = result.user;
      return _userMapper(u);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in Google

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
