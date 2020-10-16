import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:intlphonenumberinputtest/main.dart' as app;

class SignUp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 99.0, bottom: 20),
            child: Center(
                child: Image(width: 63,image: AssetImage('assets/images/logo_blue.png'))
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(46.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Create User',style: TextStyle(fontSize: 35, color: Colors.black, fontWeight: FontWeight.w700))),
          ),
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Name',
                      contentPadding: EdgeInsets.all(20.0)
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Do not leave this field empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Email',
                        contentPadding: EdgeInsets.all(20.0)
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Do not leave this field empty';
                      }
                      return null;
                    },

                  )
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}