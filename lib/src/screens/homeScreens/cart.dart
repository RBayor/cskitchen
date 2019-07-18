import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cskitchen/src/components/orders.dart';
import 'package:cskitchen/src/components/auth.dart';
import 'dart:math';

class OrderItems {
  final Map order;
  OrderItems({@required this.order});

  Map<String, dynamic> toJson() => {"order": order};
}

class Cart extends StatefulWidget {
  Cart(this.auth);
  final BaseAuth auth;
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var food = [], quantity = [], price = [];
  var totalPrice = 0.0;
  int orderNumber;

  @override
  void initState() {
    super.initState();
    getCartItems().then((onValue) {
      computeOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cartProducts(),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
              title: Text("Total: Ghs $totalPrice"),
            )),
            Expanded(
              child: MaterialButton(
                onPressed: placeCartOrder,
                child: Text(
                  "Place order",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.redAccent,
              ),
            )
          ],
        ),
      ),
    );
  }

  orderNum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    orderNumber = prefs.getInt("orderNumber");
    if (orderNumber == null) {
      orderNumber = 1;
    } else {
      orderNumber += 1;
    }
    prefs.setInt("orderNumber", orderNumber);
    setState(() {});
    print(orderNumber);
  }

  placeCartOrder() async {
    await orderNum();
    var id = await widget.auth.currentUser();
    var dbOrder = Firestore.instance.collection("orders").document(id);
    try {
      for (int i = 0; i < food.length; i++) {
        var order = {
          "food": food[i],
          "quantity": quantity[i],
          "price": price[i]
        };
        OrderItems myOrder = OrderItems(order: order);
        print("user: $id orders $order");

        Firestore.instance.runTransaction((Transaction tx) async {
          tx.set(dbOrder, {"Order $orderNumber": order});
        });
      }
    } catch (e) {}
  }

  Future getCartItems() async {
    computeOrder();
    food = await fetchCartPrefs("food");
    price = await fetchCartPrefs("price");
    quantity = await fetchCartPrefs("quantity");
    setState(() {});
  }

  fetchCartPrefs(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var items = prefs.getStringList(key);

    print("Fetch for $key  $items");
    return items;
  }

  computeOrder() {
    var temp = 0.0;
    try {
      for (int i = 0; i < food.length; i++) {
        temp += double.parse(quantity[i]) * double.parse(price[i]);
      }
      setState(() {
        totalPrice = temp;
        print("total price is $totalPrice");
      });
    } catch (e) {
      //print(e);
    }
  }

  Widget cartProducts() {
    if (food == null || food.isEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Empty Cart 😢",
            style: TextStyle(
                color: Colors.grey, fontSize: 30, fontFamily: "kalam Regular"),
          ),
          Icon(
            Icons.face,
            color: Colors.grey,
            size: 100,
          )
        ],
      ));
    } else {
      return ListView.builder(
        itemCount: food.length,
        itemBuilder: (_, index) {
          return Dismissible(
              background: Container(
                color: Colors.redAccent,
              ),
              key: Key(food[index]),
              onDismissed: (direction) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                  elevation: 10,
                  content: Text("${food[index]} has been removed"),
                ));
                food.removeAt(index);
                quantity.removeAt(index);
                price.removeAt(index);
                computeOrder();
                setState(() {});
              },
              child: Card(
                elevation: 10,
                child: ListTile(
                  title: Text(
                    "${food[index]}",
                    style: TextStyle(fontSize: 20, fontFamily: "kalam Regular"),
                  ),
                  subtitle: Text(
                    "Ghs ${price[index]}",
                    style: TextStyle(fontSize: 18, fontFamily: "kalam Regular"),
                  ),
                  trailing: Text(
                    "x ${quantity[index]}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ));
        },
      );
    }
  }
}
