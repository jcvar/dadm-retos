import 'package:flutter/material.dart';
import 'package:sqlite/company.dart';
import 'package:sqlite/crud.dart';

class FormComp extends StatefulWidget {
  final Company comp;

  const FormComp({Key key, this.comp}) : super(key: key);

  @override
  _FormCompState createState() => _FormCompState();
}

class _FormCompState extends State<FormComp> {
  final _formKey = GlobalKey<FormState>();
  Company _compState;

  void readData() async {
    //final comp = await CrudCompany.readComp(id);
    //print(comp.name);
  }

  updateComp(Company comp) async {
    await CrudCompany.updateComp(comp);
    Navigator.pop(context);
  }

  createComp(Company comp) async {
    await CrudCompany.createComp(comp);
    Navigator.pop(context);
  }

  deleteComp(int id) async {
    //await CrudCompany.deleteComp(id);
    setState(() {
      id = null;
      //future = CrudCompany.readAllComps();
    });
  }

  @override
  void initState() {
    super.initState();

    print(widget.comp);

    if (widget.comp == null) {
      _compState = Company(
        name: '',
        email: '',
        tel: '',
        url: '',
        products: '',
        classification: '',
      );
    } else {
      _compState = widget.comp;
    }
  }

  void handleSubmit() {
    if (_formKey.currentState.validate()) {
      print('Submitting $_compState');
      if (_compState.id != null) {
        updateComp(_compState);
      } else {
        createComp(_compState);
      }
      //Navigator.pop(context, _compState); // pop() in async functions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Company'),
        actions: [
          FlatButton.icon(
            onPressed: handleSubmit,
            textColor: Colors.black,
            icon: Icon(Icons.check),
            label: Text(_compState.id == null ? 'Create' : 'Update'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onChanged: (value) {
                  _compState.name = value;
                },
                validator: (value) {
                  return value == '' ? 'Required field' : null;
                },
                decoration: InputDecoration(labelText: 'Name'),
                initialValue: _compState.name ?? '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onChanged: (value) {
                  _compState.url = value;
                },
                validator: (value) {
                  if (value == '')
                    return 'Required field';
                  else
                    return null;
                },
                decoration: InputDecoration(labelText: 'URL'),
                initialValue: _compState.url ?? '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onChanged: (value) {
                  _compState.tel = value;
                },
                validator: (value) {
                  if (value == '')
                    return 'Required field';
                  else
                    return null;
                },
                decoration: InputDecoration(labelText: 'Phone number'),
                initialValue: _compState.tel ?? '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onChanged: (value) {
                  _compState.email = value;
                },
                validator: (value) {
                  if (value == '')
                    return 'Required field';
                  else
                    return null;
                },
                decoration: InputDecoration(labelText: 'Email'),
                initialValue: _compState.email ?? '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onChanged: (value) {
                  _compState.products = value;
                },
                validator: (value) {
                  if (value == '')
                    return 'Required field';
                  else
                    return null;
                },
                decoration: InputDecoration(labelText: 'Products / services'),
                initialValue: _compState.products ?? '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButtonFormField(
                items: <String>[
                  'Consulting',
                  'Custom Development',
                  'Software Factory'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  _compState.classification = value;
                },
                validator: (value) {
                  return value == null ? 'Required field' : null;
                },
                decoration: InputDecoration(labelText: 'Classification'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
