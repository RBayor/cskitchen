import 'package:cskitchen/src/logic/auth.dart';
import 'package:cskitchen/src/screens/home.dart';
import 'package:cskitchen/src/screens/login.dart';
import 'package:flutter/material.dart';

class AppRoot extends StatefulWidget {
  AppRoot({this.auth});
  final BaseAuth auth;
  @override
  _AppRootState createState() => _AppRootState();
}

enum AuthState { signedIn, notSignedIn }

class _AppRootState extends State<AppRoot> {
  AuthState authState = AuthState.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authState = userId == null ? AuthState.notSignedIn : AuthState.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authState = AuthState.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authState = AuthState.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authState) {
      case AuthState.notSignedIn:
        return Login(
          auth: widget.auth,
          onSignIn: _signedIn,
        );
      case AuthState.signedIn:
        return Home(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
    return Scaffold(
      body: Text("not signed in error"),
    );
  }
}
