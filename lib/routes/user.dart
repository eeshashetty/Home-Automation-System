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

  String user = "Eesha Shetty";

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
          padding: const EdgeInsets.fromLTRB(0.0,55.0,0,0),
          child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {Navigator.of(context).popAndPushNamed('/');},
                icon: Icon(Icons.exit_to_app),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0,0.0,30.0,0.0),
              child: Row(
                children: <Widget>[
                 CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/images/pfp.jpeg'),),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: RichText(
                    text: new TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: <TextSpan>[
                        TextSpan(text: 'Welcome back!\n', style: TextStyle(fontSize: 20)),
                        TextSpan(text: ' $user', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF6A6A6A)),),
                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35.0,30.0,20.0,0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              RichText(
              text: new TextSpan(
                  style: Theme.of(context).textTheme.headline1,
          children: <TextSpan>[
                  TextSpan(text: 'Enable Bluetooth\n', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
                  TextSpan(text: _connected ? 'Connected' : 'Not Connected', style: TextStyle(fontSize: 12, color: _connected ? Colors.green : Colors.red),),
                  ],
              ),
              ),

                Padding(
                  padding: EdgeInsets.only(right: 10),
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
            ),
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 35, left: 32),
            child: Container(
                  width: MediaQuery.of(context).size.width*0.88,
                  padding: EdgeInsets.only(right: 20),
                  height: 54,
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
                                          print('Pressed');
                                          Navigator.of(context).pop();
                                          setState(() => _device = value);
                                          _connect(_device);

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
          ),
            SizedBox(height: 61,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  p!=1 ? Container(
                    width: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff518CFD)),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Icon(Icons.arrow_back_ios, color: Color(0xff518CFD),),
                      ),
                      iconSize: 13,
                      onPressed: () {
                        setState(()
                        {
                          p = p > 1 ? p - 1 : 3;
                          print(p);
                        }
                        );
                      },
                    ),
                  ) : Container(width: 32,),
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
                      height: 261,
                      width: 183,
                      decoration: BoxDecoration(
                          color: (p==1?_toggle1:p==2?_toggle2:_toggle3) ? Color(0xffE5EEFF) : Color(0xffF0F0F0),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 76.0),
                            child: Image(image: AssetImage(
                              p==1 ? (_toggle1 ? 'assets/images/lightson.png' : 'assets/images/lightsoff.png') :
                              p==3 ? (_toggle3 ? 'assets/images/lampon.png' : 'assets/images/lampoff.png')  :
                              p==2 ? (_toggle2 ? 'assets/images/fanon.png' : 'assets/images/fanoff.png') : 'assets/images/fanoff.png'
                            ), width: 100),
                          ),
                          Container(
                            width: 183,
                            height: 43,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9), bottomRight: Radius.circular(9)),
                              color: (p==1?_toggle1:p==2?_toggle2:_toggle3) ? Color(0xff518CFD) : Color(0xffC3C3C3),
                            ),
                            child: Text((p==1?_toggle1:p==2?_toggle2:_toggle3) ? 'ON' : 'OFF', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 17.44),),
                          )
                        ],
                      ),
                    ),
                  ),
                  p!=3 ? Container(
                    width: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff518CFD)),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Color(0xff518CFD)),
                      iconSize: 13,
                      onPressed: () {
                        setState(()
                        {
                          p = p < 3 ? p + 1 : 1;
                          print(p);
                        }
                        );
                      },
                    ),
                  ) : Container(width: 32,),
                ],
              ),
            ),
            ],
          ),
        ),
    );
  }
  bool high = false;
  void _sendMessage(code) async {
    connection.output.add(utf8.encode("$code"+"\r\n"));
    await connection.output.allSent;
  }

  void _connect(BluetoothDevice device) async {
    setState(() {
      _connected = false;
    });
    if (device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(device.address)
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
