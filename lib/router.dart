import 'package:cskitchen/src/components/auth.dart';
import 'package:cskitchen/src/screens/home.dart';
import 'package:cskitchen/src/screens/homeScreens/cart.dart';
import 'package:cskitchen/src/screens/login.dart';
import 'package:cskitchen/src/screens/homeScreens/pay.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final arguments = settings.arguments;
  switch (settings.name) {
    case 'home':
      return MaterialPageRoute(builder: (context) => Home());
    case 'cart':
      return MaterialPageRoute(builder: (context) => Cart(Auth()));
    case 'pay':
      return MaterialPageRoute(builder: (context) => Pay(bill: arguments));
    case 'login':
      return MaterialPageRoute(builder: (context) => Login());
    default:
      return MaterialPageRoute(builder: (context) => Login());
  }
}
