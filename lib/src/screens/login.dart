import 'dart:ui';
import 'package:cskitchen/src/screens/customWidgets/loginPage.dart';
import 'package:cskitchen/src/screens/customWidgets/register.dart';
import 'package:cskitchen/src/screens/customWidgets/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/components/auth.dart';

class Login extends StatefulWidget {
  Login({this.auth, this.onSignIn});
  final BaseAuth auth;
  final VoidCallback onSignIn;
  @override
  _LoginState createState() => _LoginState();
}

enum FormType { login, register, resetPass }

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool isloading = false;
  FormType _formType = FormType.login;
  String _email;
  String _password;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        isloading = true;
        setState(() {});
        if (_formType == FormType.login) {
          print("trying to login with  $_email and $_password");
          String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Sigined in as $userId');
        } else if (_formType == FormType.register) {
          print("trying to register");
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print('Registered as $userId');
        }
        widget.onSignIn();
      } catch (e) {
        isloading = false;
        showAlertDialog(context, e.message);
        setState(() {});
        print('${e.message}');
      }
    }
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

  void resetPasswordForm() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.resetPass;
    });
  }

  void resetPassword() async {
    isloading = true;
    if (validateAndSave()) {
      try {
        await widget.auth.resetPassword(_email).then((val) {
          print("");
          isloading = false;
          showAlertDialog(context, "Reset email Sent");
        });
      } catch (e) {
        isloading = false;
        showAlertDialog(context, e.message);
      }
    }
  }

  showAlertDialog(BuildContext context, msg) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Something went wrong"),
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
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(color: Colors.white)),
              validator: (value) =>
                  value.isEmpty ? "Please input an email" : null,
              onSaved: (value) => _email = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(color: Colors.white)),
              validator: (value) =>
                  value.isEmpty ? "Please input a password" : null,
              onSaved: (value) => _password = value,
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
                  labelText: 'Email Address',
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(color: Colors.white)),
              validator: (value) =>
                  value.isEmpty ? "Please input an email" : null,
              onSaved: (value) => _email = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Create Password',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(color: Colors.white)),
              validator: (value) =>
                  value.isEmpty ? "Please input a password" : null,
              onSaved: (value) => _password = value,
            ),
          ),
        ];
      case FormType.resetPass:
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
              "Reset Password",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: 'Email Address',
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(color: Colors.white)),
              validator: (value) =>
                  value.isEmpty ? "Please input an email" : null,
              onSaved: (value) => _email = value,
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
        return [loginBtn(registerPage, validateAndSubmit, resetPasswordForm)];
      case FormType.register:
        return [registerBtn(loginPage, validateAndSubmit)];
      case FormType.resetPass:
        return [resetPasswordBtn(loginPage, resetPassword)];
      default:
        return [null];
    }
  }
}
