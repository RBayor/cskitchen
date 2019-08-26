import 'package:cskitchen/src/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/screens/appRoot.dart';
import 'package:flutter/services.dart';

void main() => runApp(Cskitchen());

class Cskitchen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(color: Colors.redAccent[700], elevation: 10.0),
          accentColor: Colors.redAccent),
      title: 'Cs Kitchen',
      home: AppRoot(
        auth: Auth(),
      ),
    );
  }
}
