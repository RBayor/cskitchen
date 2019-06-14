import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cskitchen/src/auth.dart';
import 'package:cskitchen/src/clipArt.dart';

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
        if (_formType == FormType.login) {
          print("trying to login");
          String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Sigined in as $userId');
        } else {
          print("trying to register");
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print('Registered as $userId');
        }
        widget.onSignIn();
      } catch (e) {
        _detailsSnackbar(e.message);
        print('${e.message}');
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _detailsSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text("$message"),
      duration: Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/chips.jpg"), fit: BoxFit.cover)),
          child: Stack(
            children: <Widget>[
              /*BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                decoration:
                    new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              )),*/
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
        ));
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
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
    } else {
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
            decoration: InputDecoration(
                labelText: 'Phone Number',
                icon: Icon(
                  Icons.phone,
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
    }
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return [
        Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Create account",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        registerPage();
                      },
                    ),
                    RaisedButton(
                        elevation: 10,
                        color: Colors.red[700],
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: validateAndSubmit),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Reset Password",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ))
      ];
    } else {
      return [
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: loginPage,
              ),
              RaisedButton(
                elevation: 10,
                color: Colors.red[700],
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: validateAndSubmit,
              ),
            ],
          ),
        )
      ];
    }
  }
}
