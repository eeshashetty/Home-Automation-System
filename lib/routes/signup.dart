import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignUp> {
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

        ],
      ),
    );
  }
}