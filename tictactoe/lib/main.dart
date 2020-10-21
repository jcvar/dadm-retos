import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/models/appuser.dart';
import 'package:tictactoe/screens/authview.dart';
import 'package:tictactoe/screens/menu.dart';
import 'package:tictactoe/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Center(
        child: Text(
          'Firebase is Loading',
          textDirection: TextDirection.ltr,
        ),
      );
    }

    if (!_initialized) {
      return Center(
        child: Text(
          'Firebase could not be initialized',
          textDirection: TextDirection.ltr,
        ),
      );
    }

    return StreamProvider<AppUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.black),
        home: Selektor(),
      ),
    );
  }
}

class Selektor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider.of<AppUser>(context) == null ? AuthView() : Menu();
  }
}
