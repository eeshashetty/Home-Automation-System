import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'user.dart';

class SignUp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  final codes = ['+7 840', '+93', '+355', '+213', '+1 684', '+376', '+244', '+1 264', '+1 268', '+54', '+374', '+297', '+247', '+61', '+672', '+43', '+994', '+1 242', '+973', '+880', '+1 246', '+1 268', '+375', '+32', '+501', '+229', '+1 441', '+975', '+591', '+387', '+267', '+55', '+246', '+1 284', '+673', '+359', '+226', '+257', '+855', '+237', '+1', '+238', '+ 345', '+236', '+235', '+56', '+86', '+61', '+61', '+57', '+269', '+242', '+243', '+682', '+506', '+385', '+53', '+599', '+537', '+420', '+45', '+246', '+253', '+1 767', '+1 809', '+670', '+56', '+593', '+20', '+503', '+240', '+291', '+372', '+251', '+500', '+298', '+679', '+358', '+33', '+596', '+594', '+689', '+241', '+220', '+995', '+49', '+233', '+350', '+30', '+299', '+1 473', '+590', '+1 671', '+502', '+224', '+245', '+595', '+509', '+504', '+852', '+36', '+354', '+91', '+62', '+98', '+964', '+353', '+972', '+39', '+225', '+1 876', '+81', '+962', '+7 7', '+254', '+686', '+965', '+996', '+856', '+371', '+961', '+266', '+231', '+218', '+423', '+370', '+352', '+853', '+389', '+261', '+265', '+60', '+960', '+223', '+356', '+692', '+596', '+222', '+230', '+262', '+52', '+691', '+1 808', '+373', '+377', '+976', '+382', '+1664', '+212', '+95', '+264', '+674', '+977', '+31', '+599', '+1 869', '+687', '+64', '+505', '+227', '+234', '+683', '+672', '+850', '+1 670', '+47', '+968', '+92', '+680', '+970', '+507', '+675', '+595', '+51', '+63', '+48', '+351', '+1 787', '+974', '+262', '+40', '+7', '+250', '+685', '+378', '+966', '+221', '+381', '+248', '+232', '+65', '+421', '+386', '+677', '+27', '+500', '+82', '+34', '+94', '+249', '+597', '+268', '+46', '+41', '+963', '+886', '+992', '+255', '+66', '+670', '+228', '+690', '+676', '+1 868', '+216', '+90', '+993', '+1 649', '+688', '+1 340', '+256', '+380', '+971', '+44', '+1', '+598', '+998', '+678', '+58', '+84', '+1 808', '+681', '+967', '+260', '+255', '+263'];
  var dropDownValue = '+91';
  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).backgroundColor,
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
            padding: const EdgeInsets.fromLTRB(45.0,0,45,0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: SizedBox(
                          // width: 303,
                          height: 64,
                          child: TextFormField(
                            controller: name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.all(20.0)
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Do not leave this field empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: Text('Name'),
                                ),
                              ),
                              ),
                    ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: SizedBox(
                          // width: 283,
                          height: 64,
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: EdgeInsets.all(20.0)
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Do not leave this field empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Text('Email'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Container(
                          height: 64,
                          // width: 283,
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffC3C3C3)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                              children: [
                          Container(
                          padding: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(color: Colors.black)
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropDownValue,
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropDownValue = newValue;
                                });
                              },
                              items: codes.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                      width: 60,
                                      padding: EdgeInsets.only(left: 20.0),
                                      child: Text(value)
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        ],
                        ),
                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0,left: 95),
                        child: SizedBox(
                          width: 225,
                          height: 64,
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20.0)
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Do not leave this field empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Text('Phone Number'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ],
                    ),
                  ),
          ),
          SizedBox(height: 160,),
          Container(
            height: 50.0,
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => User(user: name.text),
                    ),
                  );
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    color: Color(0xFF518CFD),
                    borderRadius: BorderRadius.circular(9.0)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 321.0, minHeight: 44.0),
                  alignment: Alignment.center,
                  child: Text(
                      "Create User",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



