import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cskitchen/src/screens/homeScreens/pay.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/components/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  Cart(this.auth);
  final BaseAuth auth;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var food = [], quantity = [], price = [];
  var totalPrice = 0.0;

  List? myOrder = [];
  String? location;
  String? transactionId;
  String? fullname;

  @override
  void initState() {
    super.initState();
    getCartItems().then((value) {
      myOrder = value;
      computeOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => cartProducts(context),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
              title: Text(
                "Total: \nGhs ${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )),
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  placeCartOrder();
                },
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

  showAlertDialog(BuildContext context, title, msg) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  Future<Widget?> showOrderOptionDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Center(
              child: Text("CsKitchen"),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText:
                              "Full Name (use the same name on payment)"),
                      onChanged: (value) {
                        this.fullname = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration:
                          InputDecoration(labelText: "Delivery Location"),
                      onChanged: (value) {
                        this.location = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            contentPadding: const EdgeInsets.all(10),
            actions: <Widget>[
              TextButton(
                child: Text("Done"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  placeCartOrder() async {
    var id = await widget.auth.currentUser();
    var phoneNumber = await widget.auth.currentPhone();
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    var orderDB = FirebaseFirestore.instance.collection("orders").doc(id);
    var orderHistory =
        FirebaseFirestore.instance.collection("orderHistory").doc("$timeStamp");

    if (myOrder != null) {
      await showOrderOptionDialog(context);
      if (fullname != null && location != null) {
        orderDB.set({
          "$timeStamp": myOrder,
        }, SetOptions(merge: true));
        orderHistory.set({
          "fullname": fullname,
          "location": location,
          "time": timeStamp,
          "myOrder": myOrder,
          "phone": phoneNumber
        });
        clearItems();
        Navigator.of(context).pushNamed("pay", arguments: totalPrice);
      }
    } else {
      showAlertDialog(
          context, "Cs Kitchen", "Please add items to the cart first");
    }
  }

  clearItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.clear();
      myOrder!.clear();
      computeOrder();
    } catch (e) {
      print(e);
    }
  }

  Future<List?> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List? purchase;
    try {
      List? items = jsonDecode(prefs.getString("cart")!);
      purchase = items;
    } catch (e) {}
    return purchase;
  }

  computeOrder() {
    var temp = 0.0;
    if (myOrder != null) {
      myOrder!.forEach((item) {
        temp += double.parse(item["foodQuantity"]) *
            double.parse(item["foodPrice"]);
      });
      setState(() {
        totalPrice = temp;
      });
    }
  }

  Future writeToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String orderedItem = json.encode(myOrder);
      prefs.setString("cart", orderedItem);
    } catch (e) {
      print(e);
    }
  }

  Widget cartProducts(context) {
    if (myOrder == null || myOrder!.isEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Empty Cart",
            style: TextStyle(
                color: Colors.grey, fontSize: 20, fontFamily: "kalam Regular"),
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
        itemCount: myOrder!.length,
        itemBuilder: (_, index) {
          var order = myOrder!;
          return Dismissible(
            background: Container(
              color: Colors.redAccent,
            ),
            key: Key("${order[index]['foodName']}$index"),
            onDismissed: (direction) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 1),
                  elevation: 10,
                  content: Text("${order[index]['foodName']} has been removed"),
                ),
              );
              setState(() {
                order.removeAt(index);
                computeOrder();
                writeToPref();
              });
            },
            child: Card(
              elevation: 10,
              child: ListTile(
                title: Text(
                  "${order[index]['foodName']}",
                  style: TextStyle(fontSize: 20, fontFamily: "kalam Regular"),
                ),
                subtitle: Text(
                  "Ghs ${order[index]['foodPrice']}",
                  style: TextStyle(fontSize: 18, fontFamily: "kalam Regular"),
                ),
                trailing: Text(
                  "x ${order[index]['foodQuantity']}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
