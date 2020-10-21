import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/models/appuser.dart';
import 'package:tictactoe/screens/gamepage.dart';
import 'package:tictactoe/services/auth.dart';
import 'package:tictactoe/services/db.dart';

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final AuthService _auth = AuthService();
  final DataService db = DataService();
  String gameid = '';
  String error = '';
  String uid = '';

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AppUser>(context).uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Main menu'),
        actions: [
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.logout),
            label: Text('Log out'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(hintText: 'Game ID'),
                validator: (val) {
                  return val.isEmpty ? 'Enter a game code' : null;
                },
                onChanged: (val) {
                  setState(() {
                    gameid = val;
                  });
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text('Enter Game'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    gotoGame();
                  }
                },
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
              Text(
                'uid: ' + uid,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> gotoGame() async {
    bool allclear = await db.enterGame(gameid);
    if (allclear) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GamePage(gameid),
        ),
      );
    } else {
      setState(() {
        error = 'Error joining game';
      });
    }
  }
}
