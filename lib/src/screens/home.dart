import 'package:cskitchen/src/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void _signOut() async {
    try {
      await widget.auth.signOut().then((onValue){
      widget.onSignedOut();
    });
    }catch(e){
      print("Error signing out: $e");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cs Kitchen"),
        actions: <Widget>[
          IconButton(
            tooltip: "Logout",
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          )
        ],
      ),
    );
  }
}