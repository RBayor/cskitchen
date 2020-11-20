import 'package:cskitchen/src/screens/home.dart';
import 'package:cskitchen/src/screens/login.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // final arguments = settings.arguments;
  switch (settings.name) {
    case 'home':
      return MaterialPageRoute(builder: (context) => Home());
    default:
      return MaterialPageRoute(builder: (context) => Login());
  }
}
