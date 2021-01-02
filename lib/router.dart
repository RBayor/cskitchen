import 'package:cskitchen/src/components/auth.dart';
import 'package:cskitchen/src/screens/home.dart';
import 'package:cskitchen/src/screens/homeScreens/cart.dart';
import 'package:cskitchen/src/screens/login.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // final arguments = settings.arguments;
  switch (settings.name) {
    case 'home':
      return MaterialPageRoute(builder: (context) => Home());
    case 'cart':
      return MaterialPageRoute(builder: (context) => Cart(Auth()));
    default:
      return MaterialPageRoute(builder: (context) => Login());
  }
}
