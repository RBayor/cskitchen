import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cskitchen/src/screens/homeScreens/pay.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/components/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderItems {
  List order;
  DateTime timeStamp;
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
  List<Map> myOrder = [];
  List prevOrder;
  String location;
  String transactionId;
  List<String> paymentNetwork = ["MTN", "VODA"];
  //String _selectedNetwork = "MTN";
  String email;

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
              title: Text(
                "Total: \nGhs ${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )),
            Expanded(
              child: MaterialButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Pay())),
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
    Widget okButton = FlatButton(
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

  Future<Widget> showOrderOptionDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Center(
              child: Text("Payment"),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(labelText: "email"),
                      onChanged: (value) {
                        this.email = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(labelText: "Location"),
                      onChanged: (value) {
                        this.location = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration:
                          InputDecoration(labelText: "Momo Transaction ID"),
                      onChanged: (value) {
                        this.transactionId = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            contentPadding: const EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  getDbOrder(id) async {
    DocumentReference db = Firestore.instance.collection("orders").document(id);

    await db.get().then((doc) {
      if (doc.exists) {
        prevOrder = doc.data["order"];
      }
    });
  }

  pay() {}

  placeCartOrder() async {
    var id = await widget.auth.currentUser();
    var db = Firestore.instance.collection("orders").document(id);
    Map order;
    await getDbOrder(id);

    if (prevOrder != null) {
      prevOrder.forEach((item) {
        myOrder.add(item);
      });
    }
    if (food != null) {
      await showOrderOptionDialog(context);

      if (location != null && transactionId != null) {
        for (int i = 0; i < food.length; i++) {
          order = {
            "food": food[i],
            "quantity": quantity[i],
            "price": price[i],
            "timeStamp": DateTime.now(),
            "location": this.location,
            "transactionId": this.transactionId,
          };
          myOrder.add(order);
        }
        print("\n\nMy order is $myOrder");
        OrderItems orderItems = OrderItems(order: myOrder);
        db.setData(orderItems.toJson()).then((val) {
          clearItems();
        });
        showAlertDialog(context, "", "Your order has been placed!");
      } else {
        showAlertDialog(context, "",
            "Please Enter location and transaction Id to confirm order");
      }
      setState(() {});
    } else {
      showAlertDialog(context, "", "Nothing in cart");
    }
  }

  clearItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.clear();
      food.clear();
      quantity.clear();
      price.clear();
      myOrder.clear();
      computeOrder();
    } catch (e) {
      print(e.message);
    }
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
      });
    } catch (e) {}
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
