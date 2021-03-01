import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _codeController = TextEditingController();
  bool isloading = false;
  String phoneNo;
  String smsCode;
  String verificationId;
  static const String countryCode = "+233";

  Future loginUser(String mobile, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          await _auth
              .signInWithCredential(credential)
              .then((value) => Navigator.pushReplacementNamed(context, "home"))
              .catchError((e) {
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException);
        },
        codeSent: (String verificationId, [int forceResendToken]) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text("Enter Verification Code"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _codeController,
                  ),
                ],
              ),
              actions: [
                FlatButton(
                  child: Text("Done"),
                  onPressed: () {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    var smsCode = _codeController.text.trim();
                    var _credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: smsCode,
                    );
                    auth
                        .signInWithCredential(_credential)
                        .then((value) =>
                            Navigator.of(context).pushReplacementNamed("home"))
                        .catchError((e) {
                      print(e);
                    });
                  },
                )
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print("Hey here $verificationId");
        });
  }

  String onNumber(String val) {
    return phoneNo = countryCode + val;
  }

  bool isNumeric(String p) {
    if (p == null) {
      return false;
    }
    return double.tryParse(p) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.white,
                    child: Image(
                      image: AssetImage("assets/cs_logo.png"),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 30,
                    right: 30,
                    bottom: 10,
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      icon: Icon(
                        Icons.phone_android,
                        color: Colors.white,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onChanged: (value) => onNumber(value),
                  ),
                ),
                RaisedButton(
                  child: Text("Login"),
                  color: Colors.white,
                  onPressed: () =>
                      isNumeric(phoneNo) ? loginUser(phoneNo, context) : null,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
