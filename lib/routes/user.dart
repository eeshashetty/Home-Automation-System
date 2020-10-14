import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class User extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<User> {
  // This widget is the root of your application.
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection connection;

  int _deviceState;

  bool _enabled = false;
  bool isDisconnecting = false;

  bool get isConnected => connection != null && connection.isConnected;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;

  bool _connected = false;
  bool _toggle1 = false;
  bool _toggle2 = false;
  bool _toggle3 = false;
  int p = 1;
  String dropdownValue = 'Select Device';

  @override
  void init() {
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0;

    enableBluetooth();

    FlutterBluetoothSerial.instance.onStateChanged()
    .listen((BluetoothState state){
      setState(() {
        _bluetoothState = state;
        if(_bluetoothState == BluetoothState.STATE_OFF) {
          _enabled = false;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }


  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
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
                TextSpan(text: _connected ? 'Connected' : 'Not Connected', style: TextStyle(fontSize: 12, color: _connected ? Colors.green : Colors.red),),
                ],
            ),
            ),

              Padding(
                padding: EdgeInsets.only(right: 25),
                child: Switch(
                  value: _enabled,
                  onChanged:  (value) async {
                    if(_enabled == false)
                      init();
                    if(_enabled) {
                      await FlutterBluetoothSerial.instance
                          .requestDisable();
                    }
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.75,
                  padding: EdgeInsets.only(right: 20),
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(9)
                  ),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<BluetoothDevice>(
                        items: _getDeviceItems(),
                        elevation: 16,
                        onChanged: (value) {
                          final name = value.name;
                          // const dialog =
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  AlertDialog(
                                    insetPadding: EdgeInsets.all(70),
                                    contentPadding: EdgeInsets.all(30),
                                    content: RichText(
                                      text: new TextSpan(
                                        style: TextStyle(color: Colors.black87, fontSize: 18),
                                        children: <TextSpan>[
                                          TextSpan(text: 'Connect to '),
                                          TextSpan(text: '$name?', style: TextStyle(fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _connect;
                                          setState(() => _device = value);
                                          },
                                        child: Text('YES'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('NO'),
                                      ),
                                    ],
                                  )
                          );
                        },
                        value: _devicesList.isNotEmpty ? _device : null,
                        icon: Icon(Icons.arrow_forward),
                        iconSize: 15,
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    await getPairedDevices().then((value) =>
                      show('Device List Refreshed'),
                    );
                  },
                )
              ],
            ),
          ),
            SizedBox(height: 100,),
            RichText(
              text: new TextSpan(
                  style: Theme.of(context).textTheme.headline2,
                  children: <TextSpan>[
                    new TextSpan(text:
                    p==1 ? 'Lights: ' :
                    p==3 ? 'Lamp: '  :
                    p==2 ? 'Fan: ' : 'assets/images/light.png'
                    ),
                    new TextSpan(text: (p==1?_toggle1:p==2?_toggle2:_toggle3) ? 'ON' : 'OFF', style: TextStyle(color: (p==1?_toggle1:p==2?_toggle2:_toggle3) ? Colors.green : Colors.red))
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
                      p = p > 1 ? p - 1 : 3;
                      print(p);
                    }
                    );
                  },
                ),
                MaterialButton(
                  onPressed: () {
                    print('Sending $p');
                    _sendMessage(p);
                    setState(() {
                    if(p==1)
                      _toggle1 = !_toggle1;
                    if(p==2)
                      _toggle2 = !_toggle2;
                    if(p==3)
                      _toggle3 = !_toggle3;
                    });},
                  child: Container(
                    height: 193,
                    width: 179,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ (p==1?_toggle1:p==2?_toggle2:_toggle3) ? Color(0xff191970) : Colors.black12, (p==1?_toggle1:p==2?_toggle2:_toggle3) ? Color(0xff4A4A8E) : Colors.black12] ,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage(
                          p==1 ? 'assets/images/light.png' :
                          p==3 ? 'assets/images/lamp.png'  :
                          p==2 ? 'assets/images/fan.png' : 'assets/images/light.png'
                        ), width: 100),
                        SizedBox(height: 15,),
                        Text(  p==1 ? 'Lights' :
                        p==3 ? 'Lamp'  :
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
                      p = p < 3 ? p + 1 : 1;
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
  void _sendMessage(code) async {
    connection.output.add(utf8.encode("$code"+"\r\n"));
    await connection.output.allSent;
    show('Sent $code');
  }

  void _connect() async {
    setState(() {
      _connected = false;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          show('Connected to Device!');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          show('Cannot connect, exception occurred');
          print(error);
        });

      }
    }
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left:20.0),
          child: Text('No Devices'),
        ),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
              child: Text(device.name)
            ),
          value: device,
          ));
      });
    }
    return items;
  }

Future show(
    String message, {
      Duration duration: const Duration(seconds: 3),
    }) async {
  await new Future.delayed(new Duration(milliseconds: 100));
  _scaffoldKey.currentState.showSnackBar(
    new SnackBar(
      content: new Text(
        message,
      ),
      duration: duration,
    ),
  );
}
}
