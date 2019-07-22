import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Purchase {
  final String food;
  final String price;
  final String quantity;
  final String img;
  final String foodDetails;

  Purchase(this.food, this.price, this.quantity, this.img, this.foodDetails);

  Purchase.fromJson(Map<String, dynamic> json)
      : food = json["foodName"],
        price = json["foodPrice"],
        quantity = json["foodQuantity"],
        img = json["foodImg"],
        foodDetails = json["foodDetails"];
}

class Fooditem extends StatefulWidget {
  Fooditem(this.food, this.price, this.foodImage, this.foodDetails);
  final String food;
  var price;
  final String foodImage;
  final foodDetails;

  @override
  _FooditemState createState() => _FooditemState();
}

class _FooditemState extends State<Fooditem> {
  List<String> cart = [];
  List<int> foodQuantity = [1, 2, 3, 4, 5];
  int _selectedQuantity = 1;

  Future _addToCart(String foodName, var foodPrice, int foodQuantity,
      String foodImg, String foodDetails) async {
    try {
      var myCart =
          '{"foodName" : "$foodName", "foodPrice" : "${foodPrice.toString()}", "foodQuantity": "${foodQuantity.toString()}", "foodImg": "$foodImg","foodDetail": "$foodDetails"}';

      Map cartMap = jsonDecode(myCart);
      var cart = Purchase.fromJson(cartMap);
      print("Adding ${cart.quantity} ${cart.food}");

      await _storeCart("food", cart.food);
      await _storeCart("quantity", cart.quantity);
      await _storeCart("price", cart.price);
      showAlertDialog(context, "Order", "${cart.food} has been added to cart");
    } catch (e) {}
  }

  _storeCart(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cartPurchase = (prefs.getStringList(key) ?? []);

    if (cartPurchase.isEmpty) {
      await prefs.setStringList(key, [val]);
    } else {
      cartPurchase.addAll([val]);
      await prefs.setStringList(key, cartPurchase);
    }
    setState(() {});
    print("Current $key ${prefs.getStringList(key)}");
  }

  _clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    showAlertDialog(context, "", "Cart Cleared");
  }

  showAlertDialog(BuildContext context, title, msg) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width - 10,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: NetworkImage(widget.foodImage))),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "GHS ${widget.price}",
                  style: TextStyle(fontSize: 40, fontFamily: "Cookie"),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.food}",
                  style: TextStyle(fontSize: 35, fontFamily: "Caveat Bold"),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.foodDetails}",
                  style: TextStyle(fontSize: 20, fontFamily: "kalam Regular"),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  width: 50,
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedQuantity,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedQuantity = newValue;
                        });
                      },
                      items: foodQuantity.map((quantity) {
                        return DropdownMenuItem(
                          child: Text(
                            "$quantity",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          value: quantity,
                        );
                      }).toList(),
                    ),
                  )),
            ),
          ),
          RaisedButton(
            child: Text("Clear Cart"),
            onPressed: _clearPrefs,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add to cart",
        child: Icon(Icons.add_shopping_cart),
        onPressed: () {
          _addToCart(widget.food, widget.price, _selectedQuantity,
              widget.foodImage, widget.foodDetails);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}