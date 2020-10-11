import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class User extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<User> {
  // This widget is the root of your application.
  bool _enabled = false;
  bool _connec = false;
  bool _toggle = false;
  int p = 1;
  String dropdownValue = 'Select Device';

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0,80.0,0,0),
          child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  RichText(
                  text: new TextSpan(
                      style: Theme.of(context).textTheme.headline2,
                      children: <TextSpan>[
                        new TextSpan(text: 'Hello, '),
                        new TextSpan(text: 'User!', style: TextStyle(fontWeight: FontWeight.bold))
                      ]
                  ),
          ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Welcome back', style: Theme.of(context).textTheme.bodyText2),
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            RichText(
            text: new TextSpan(
                style: Theme.of(context).textTheme.headline1,
          children: <TextSpan>[
                TextSpan(text: 'Enable Bluetooth\n', style: TextStyle(fontSize: 20),),
                TextSpan(text: _connec ? 'Connected' : 'Not Connected', style: TextStyle(fontSize: 12, color: _connec ? Colors.green : Colors.red),),
                ],
            ),
            ),

              Padding(
                padding: EdgeInsets.only(right: 40),
                child: Switch(
                  value: _enabled,
                  onChanged: (value) {
                    setState(() {
                      _enabled = value;
                    });
                  },
                  // inactiveThumbColor: Colors.red,
                  activeColor: Colors.blue,
                ),
              )

              ],
            ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(right: 20),
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(9)
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: false,
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 15,
                    elevation: 11,
                    style: TextStyle(color: Colors.black45),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Select Device','One', 'Two', 'Free', 'Four']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 200,
                          height: 44,
                          child: Text(
                            value,
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xFF6A6A6A)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ),
          ),
            SizedBox(height: 100,),
            RichText(
              text: new TextSpan(
                  style: Theme.of(context).textTheme.headline2,
                  children: <TextSpan>[
                    new TextSpan(text:
                    p==0 ? 'Lights: ' :
                    p==1 ? 'Lamp: '  :
                    p==2 ? 'Fan: ' : 'assets/images/light.png'
                    ),
                    new TextSpan(text: _toggle ? 'ON' : 'OFF', style: TextStyle(color: _toggle ? Colors.green : Colors.red))
                  ]
              ),
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(()
                    {
                      p = p > 0 ? p - 1 : 2;
                      print(p);
                    }
                    );
                  },
                ),
                MaterialButton(
                  onPressed: () { setState(() {
                    _toggle = _toggle ? false : true ; print(_toggle);
                  });},
                  child: Container(
                    height: 193,
                    width: 179,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ _toggle ? Color(0xff191970) : Colors.black12, _toggle ? Color(0xff4A4A8E) : Colors.black12] ,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage(
                          p==0 ? 'assets/images/light.png' :
                          p==1 ? 'assets/images/lamp.png'  :
                          p==2 ? 'assets/images/fan.png' : 'assets/images/light.png'
                        ), width: 100),
                        SizedBox(height: 15,),
                        Text(  p==0 ? 'Lights' :
                        p==1 ? 'Lamp'  :
                        p==2 ? 'Fan' : 'assets/images/light.png'
                        , style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(()
                    {
                      p = p < 2 ? p + 1 : 0;
                      print(p);
                    }
                    );
                  },
                ),
              ],
            ),
            ],
          ),
        ),
    );
  }
}
