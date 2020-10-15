import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'routes/user.dart';
import 'routes/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Automation System',
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: 'Montserrat', fontSize: 17.44, fontWeight: FontWeight.w500, color: Color(0xFF518CFD)),
          headline2: TextStyle(fontFamily: 'Montserrat', fontSize: 25.44, fontWeight: FontWeight.w400, color: Colors.black),
          headline3: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
          bodyText1: TextStyle(fontFamily: 'Montserrat', fontSize: 26, fontWeight: FontWeight.w600, color: Colors.black),
          bodyText2: TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF6A6A6A)),

        ),
      ),
      home: MyHomePage(title: 'Home Automation System'),
      routes: {
        '/signup': (_) => new SignUp(),
        '/user': (_) => new User(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 200,),
                Image(image: AssetImage('assets/images/logo_blue.png'), width: 187,),
                SizedBox(height: 9,),
                Text('Home Automation \nSystem', style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center,),
                SizedBox(height: 57,),
                RichText(
                  text: new TextSpan(
                    style: Theme.of(context).textTheme.headline2,
                    children: <TextSpan>[
                      new TextSpan(text: 'Welcome! '),
                      new TextSpan(text: 'User', style: TextStyle(fontWeight: FontWeight.bold))
                    ]
                  ),
                ),
                ],
            ),
                SizedBox(height: 155,),
                Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/user');
                      },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Color(0xFF518CFD),
                          borderRadius: BorderRadius.circular(9.0)
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 281.0, minHeight: 44.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Get Started",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3
                        ),
                      ),
                    ),
                  ),
                ),

              ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
