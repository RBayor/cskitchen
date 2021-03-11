import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isDelivery = false;
  static const deliveryCharge = 4;

  List? myOrder = [];
  String? location = "";
  String? transactionId;
  String? fullname = "";

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
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Center(
              child: Column(
                children: [
                  Text(
                    "Cs kitchen",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Delivery will be included during payment",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
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
                      decoration: InputDecoration(
                          labelText: "Location (Landmark if Pickup)"),
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
                child: Text("PICK UP"),
                onPressed: () {
                  isDelivery = false;
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("DELIVERY"),
                onPressed: () {
                  isDelivery = true;
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  placeCartOrder() async {
    if (myOrder != null) {
      await showOrderOptionDialog(context).then((value) {
        switch (isDelivery) {
          case true:
            return sendOrderDelivery();
          case false:
            return sendOrderPickup();
          default:
            return null;
        }
      });
    } else {
      showAlertDialog(
          context, "Cs Kitchen", "Please add items to the cart first");
    }
  }

  sendOrderPickup() async {
    var id = await widget.auth.currentUser();
    var phoneNumber = await widget.auth.currentPhone();
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    var orderDB = FirebaseFirestore.instance.collection("orders").doc(id);
    var orderHistory =
        FirebaseFirestore.instance.collection("orderHistory").doc("$timeStamp");

    if (fullname != null && fullname != "") {
      print("sending order");
      orderDB.set({
        "$timeStamp": myOrder,
      }, SetOptions(merge: true));
      orderHistory.set({
        "fullname": fullname!.toLowerCase(),
        "location": "pick-up",
        "time": timeStamp,
        "myOrder": myOrder,
        "phone": phoneNumber,
        "isDelivery": isDelivery,
      });
      clearItems();
      Navigator.of(context).pushNamed("pay", arguments: totalPrice);
    } else {
      showAlertDialog(context, "Cs Kitchen", "Please Enter a Valid Name");
    }
  }

  sendOrderDelivery() async {
    var id = await widget.auth.currentUser();
    var phoneNumber = await widget.auth.currentPhone();
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    var orderDB = FirebaseFirestore.instance.collection("orders").doc(id);
    var orderHistory =
        FirebaseFirestore.instance.collection("orderHistory").doc("$timeStamp");

    if (fullname != null &&
        location != null &&
        location!.isNotEmpty &&
        fullname!.isNotEmpty) {
      print("sending order");
      orderDB.set({
        "$timeStamp": myOrder,
      }, SetOptions(merge: true));
      orderHistory.set({
        "fullname": fullname!.toLowerCase(),
        "location": location!.toLowerCase(),
        "time": timeStamp,
        "myOrder": myOrder,
        "phone": phoneNumber,
        "isDelivery": isDelivery,
      });
      clearItems();
      Navigator.of(context)
          .pushNamed("pay", arguments: (totalPrice + deliveryCharge));
    } else {
      showAlertDialog(
          context, "Cs Kitchen", "Please Enter a Valid Name and Location");
    }
  }

  Future<void> clearItems() async {
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
