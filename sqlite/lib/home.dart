import 'package:flutter/material.dart';
import 'package:sqlite/company.dart';
import 'package:sqlite/crud.dart';
import 'package:sqlite/form.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Company>> future;
  String name;
  int id;

  @override
  void initState() {
    super.initState();
    future = CrudCompany.readAllComps();
  }

  void addCompRoute() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FormComp()))
        .then((value) {
      print(value);
      setState(() {
        future = CrudCompany.readAllComps();
      });
    });
  }

  void editCompRoute(Company c) {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => FormComp(comp: c)))
        .then((value) {
      print(value);
      setState(() {
        future = CrudCompany.readAllComps();
      });
    });
  }

  void deleteCompRoute(Company c) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Deleting Company'),
          content: Text('Are you sure?'),
          actions: [
            FlatButton(
                onPressed: () {
                  CrudCompany.deleteComp(c.id)
                      .then((value) => Navigator.of(context).pop());
                },
                child: Text('Yes')),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No')),
          ],
        );
      },
    ).then((value) => setState(() {
          future = CrudCompany.readAllComps();
        }));
  }

  Card buildItem(Company comp) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${comp.name}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${comp.url}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: () => deleteCompRoute(comp),
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  color: Colors.red,
                  textColor: Colors.white70,
                ),
                RaisedButton.icon(
                  onPressed: () => editCompRoute(comp), //updateComp(comp),
                  icon: Icon(Icons.edit),
                  label: Text('View details'),
                  color: Colors.green,
                  textColor: Colors.white70,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Company>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: snapshot.data.map((comp) => buildItem(comp)).toList(),
              );
            } else {
              print('No snapshot.data');
              return SizedBox();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCompRoute,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
