import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/services/auth.dart';

class AuthView extends StatefulWidget {
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final AuthService _auth = AuthService();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Tic-Tac-Toe',
              style: TextStyle(fontSize: 40, fontFamily: 'monospace'),
            ),
            ElevatedButton(
              child: Text('Enter Anonymously'),
              onPressed: () async {
                dynamic result = await _auth.signInAnon();
                print(result.uid ?? 'Error on login');
                if (result == null) {
                  setState(() {
                    error = 'Error on login';
                  });
                } else {
                  SharedPreferences prefs = await _prefs;
                  await prefs.setString('uid', result.uid);
                }
              },
            ),
            Text(error, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
