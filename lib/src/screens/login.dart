import 'dart:ui';
import 'package:cskitchen/src/screens/customWidgets/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/components/auth.dart';

class Login extends StatefulWidget {
  Login({this.onSignIn});
  final VoidCallback onSignIn;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool isloading = false;
  String phoneNo;
  String smsCode;
  String verificationId;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> verifyPhone() async {
    validateAndSave();
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) async {
      print("verified $verificationId}");
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print("${exception.message}");
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      print("verId $verId ");
    };

    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
    )
        .then((onValue) {
      smsCodeDialog(context);
    });
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter Verification Code"),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: () async {
                  await signIn();
                  FirebaseAuth.instance.currentUser().then((user) {
                    print("Current user is $user !!!!!!!!!!!!!!!!!!!!!!!!!!");
                    if (user != null) {
                      Navigator.of(context).pop();
                      print("Signed in as $user");
                      widget.onSignIn();
                      setState(() {});
                    } else {
                      Navigator.of(context).pop();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: this.verificationId, smsCode: this.smsCode);
      await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        print("signed in with user -> $user");
      });
    } catch (e) {
      print("${e.message}");
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  showAlertDialog(BuildContext context, String title, String msg) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Scaffold(
          body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/chips.jpg"), fit: BoxFit.cover)),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    } else {
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/chips.jpg"),
                      fit: BoxFit.cover)),
            ),
            Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: buildInputs() + buildButtons(),
                  ),
                ))
          ],
        ),
      );
    }
  }

  List<Widget> buildInputs() {
    return [
      CircleAvatar(
          radius: 65,
          backgroundColor: Colors.white,
          child: Image(
            image: AssetImage("assets/cs_logo.png"),
          )),
      Padding(
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              labelText: 'Phone Number',
              icon: Icon(
                Icons.phone_android,
                color: Colors.white,
              ),
              labelStyle: TextStyle(color: Colors.white)),
          validator: (value) =>
              value.isEmpty ? "Please input a valid phone number" : null,
          onSaved: (value) => phoneNo = value,
        ),
      ),
    ];
  }

  List<Widget> buildButtons() {
    return [loginBtn(verifyPhone)];
  }
}
