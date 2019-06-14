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
        print('Error $e');
      }
    }
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
        body: Stack(
      children: <Widget>[
        ClipPath(
          child: Container(
            color: Colors.red.withOpacity(0.6),
          ),
          clipper: LoginClipper(),
        ),
        Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildInputs() + buildButtons(),
            ))
      ],
    ));
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            validator: (value) =>
                value.isEmpty ? "Please input an email" : null,
            onSaved: (value) => _email = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
            validator: (value) =>
                value.isEmpty ? "Please input a password" : null,
            onSaved: (value) => _password = value,
          ),
        ),
      ];
    } else {
      return [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Email Address'),
            validator: (value) =>
                value.isEmpty ? "Please input an email" : null,
            onSaved: (value) => _email = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Create Password'),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Create account"),
                      onPressed: () {
                        registerPage();
                      },
                    ),
                    RaisedButton(
                        child: Text(
                          "Login",
                        ),
                        onPressed: validateAndSubmit),
                  ],
                ),
                FlatButton(
                  child: Text("Reset Password"),
                  onPressed: () {},
                )
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
                child: Text("Already have an account? Login"),
                onPressed: loginPage,
              ),
              RaisedButton(
                child: Text(
                  "Register",
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
