import 'package:cskitchen/src/auth.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/screens/appRoot.dart';

void main() => runApp(Cskitchen());

class Cskitchen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.red, elevation: 10.0)),
      title: 'Cs Kitchen',
      home: AppRoot(
        auth: Auth(),
      ),
    );
  }
}
