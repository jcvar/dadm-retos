import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsPage extends StatefulWidget {
  @override
  _PrefsPageState createState() => _PrefsPageState();
}

class _PrefsPageState extends State<PrefsPage> {
  bool soundCheck = false;

  @override
  void initState() {
    super.initState();
    restore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: ListView(
        children: <Widget>[
          CheckboxListTile(
            value: soundCheck,
            onChanged: (bool checked) {
              setState(() {
                soundCheck = checked;
              });
              save('sound',checked);
            },
            secondary: Icon(Icons.speaker),
            controlAffinity: ListTileControlAffinity.platform,
            title: Text('Sound'),
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Change Difficulty'),
            onTap: () {
              changeDifficulty(context);
            },
          ),
        ],
      ),
    );
  }

  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      soundCheck = (sharedPrefs.getBool('sound') ?? false);
    });
  }
}

void changeDifficulty(BuildContext context) async {
  String newdiff = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select difficulty:'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Easy');
              },
              child: Text('Easy'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Medium');
              },
              child: Text('Medium'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Hard');
              },
              child: Text('Hard'),
            ),
          ],
        );
      });
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('difficulty', newdiff);
}

Future<String> getDiff() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String diff = prefs.getString('difficulty');
  return diff;
}

initPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('sound', false);
  await prefs.setString('difficulty', 'Easy');
  await prefs.setString('message', 'YOU WIN');
}

save(String key, dynamic value) async {
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  if (value is bool) {
    sharedPrefs.setBool(key, value);
  } else if (value is String) {
    sharedPrefs.setString(key, value);
  } else if (value is int) {
    sharedPrefs.setInt(key, value);
  } else if (value is double) {
    sharedPrefs.setDouble(key, value);
  } else if (value is List<String>) {
    sharedPrefs.setStringList(key, value);
  }
}
