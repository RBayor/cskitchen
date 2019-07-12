import 'package:flutter/material.dart';

class Fooditem extends StatefulWidget {
  Fooditem(this.food, this.price, this.foodImage, this.foodDetails);
  final String food;
  final int price;
  final String foodImage;
  final foodDetails;

  @override
  _FooditemState createState() => _FooditemState();
}

class _FooditemState extends State<Fooditem> {
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
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "GHS ${widget.price}",
                  style: TextStyle(fontSize: 40, fontFamily: "Cookie"),
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.food}",
                  style: TextStyle(fontSize: 35, fontFamily: "Caveat Bold"),
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.foodDetails}",
                  style: TextStyle(fontSize: 20, fontFamily: "kalam Regular"),
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add to cart",
        child: Icon(Icons.add_shopping_cart),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
