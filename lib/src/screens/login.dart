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
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future loginUser(String mobile, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    setState(() {
      isloading = true;
    });

    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          await _auth
              .signInWithCredential(credential)
              .then((value) => Navigator.popAndPushNamed(context, "home"))
              .catchError((e) {
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          showInSnackBar("An Error Occured! Please try again");
        },
        codeSent: (String verificationId, [int forceResendToken]) {
          setState(() {
            isloading = false;
          });
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
                TextButton(
                  child: Text("Done"),
                  onPressed: () {
                    setState(() {
                      isloading = true;
                    });
                    FirebaseAuth auth = FirebaseAuth.instance;
                    var smsCode = _codeController.text.trim();
                    var _credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: smsCode,
                    );
                    auth.signInWithCredential(_credential).then((value) {
                      Navigator.of(context).popAndPushNamed("home");
                    }).catchError((e) {
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
    return isloading
        ? Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Image(
                    image: AssetImage("assets/cs_icon.png"),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/chips.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => isNumeric(phoneNo)
                                ? loginUser(phoneNo, context)
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please Enter a Valid Phone Number',
                                      ),
                                    ),
                                  ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("LOGIN"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
