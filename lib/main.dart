import 'package:cskitchen/src/auth.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/screens/appRoot.dart';

void main() => runApp(Cskitchen());

class Cskitchen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      title: 'Cs Kitchen',
      home: AppRoot(
        auth: Auth(),
      ),
    );
  }
}
