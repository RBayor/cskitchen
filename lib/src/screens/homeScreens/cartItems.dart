import 'package:flutter/material.dart';

class CartItems extends StatefulWidget {
  final Map<String, dynamic> jsonObj;
  final String mykey;

  CartItems({this.jsonObj, this.mykey});
  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
          color: Colors.redAccent,
        ),
        key: Key(widget.mykey),
        onDismissed: (direction) {
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            elevation: 10,
            content: Text("${widget.jsonObj['Foodname']} has been removed"),
          ));
          // food.removeAt(index);
          // quantity.removeAt(index);
          // price.removeAt(index);
          // computeOrder();
          // setState(() {});
        },
        child: Card(
          elevation: 10,
          child: ListTile(
            title: Text(
              "${widget.jsonObj['foodName']}",
              style: TextStyle(fontSize: 20, fontFamily: "kalam Regular"),
            ),
            subtitle: Text(
              "Ghs ${widget.jsonObj['foodPrice']}",
              style: TextStyle(fontSize: 18, fontFamily: "kalam Regular"),
            ),
            trailing: Text(
              "x ${widget.jsonObj['foodQuantity']}",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ));
  }
}
