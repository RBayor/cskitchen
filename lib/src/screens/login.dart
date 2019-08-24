import 'dart:ui';
import 'package:cskitchen/src/screens/customWidgets/loginPage.dart';
import 'package:cskitchen/src/screens/customWidgets/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/components/auth.dart';

class Login extends StatefulWidget {
  Login({this.auth, this.onSignIn});
  final BaseAuth auth;
  final VoidCallback onSignIn;
  @override
  _LoginState createState() => _LoginState();
}

enum FormType { login, register }

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool isloading = false;
  FormType _formType = FormType.login;
  String phoneNo;
  String smsCode;
  String verificationId;

  Future<void> verifyPhone() async {
    validateAndSave();
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) {
      print("verified");
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print("${exception.message}");
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };
    print("Phone is $phoneNo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 10),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
    );
    //smsCodeDialog(context);
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
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    print("Current user is $user !!!!!!!!!!!!!!!!!!!!!!!!!!");
                    if (user != null) {
                      Navigator.of(context).pop();
                      print("Signed in as $user");
                      widget.onSignIn();
                    } else {
                      Navigator.of(context).pop();
                      signIn();
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
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((user) {});
    } catch (e) {
      print("${e.message}");
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void loginPage() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void registerPage() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

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
    switch (_formType) {
      case FormType.login:
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
      case FormType.register:
        return [
          CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white,
              child: Image(
                image: AssetImage("assets/cs_logo.png"),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Create New Account",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: 'Enter Phone Number',
                  icon: Icon(
                    Icons.phone_android,
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(color: Colors.white)),
              validator: (value) =>
                  value.isEmpty ? "Please input a valid number" : null,
              onSaved: (value) => phoneNo = value,
            ),
          ),
        ];
      default:
        return [null];
    }
  }

  List<Widget> buildButtons() {
    switch (_formType) {
      case FormType.login:
        return [loginBtn(registerPage, verifyPhone)];
      case FormType.register:
        return [registerBtn(loginPage, verifyPhone)];
      default:
        return [null];
    }
  }
}
