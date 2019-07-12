import 'package:flutter/material.dart';

class CartProducts extends StatefulWidget {
  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  var cartItems = [
    {"food": "Fries with chicken", "price": 20, "quantity": 3}
  ];
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
