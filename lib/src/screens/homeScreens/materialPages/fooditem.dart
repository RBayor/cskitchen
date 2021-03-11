import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cskitchen/src/class/Purchase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fooditem extends StatefulWidget {
  Fooditem(
    this.food,
    this.price,
    this.foodImage,
    this.foodDetails,
  );
  final String? food;
  final price;
  final String? foodImage;
  final foodDetails;

  @override
  _FooditemState createState() => _FooditemState();
}

class _FooditemState extends State<Fooditem> {
  List<String> cart = [];
  List<int> foodQuantity = [1, 2, 3, 4, 5];
  int? _selectedQuantity = 1;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showInSnackBar(String value) {
    scaffoldMessengerKey.currentState!
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future _addToCart(
    String? foodName,
    var foodPrice,
    int? foodQuantity,
    String? foodImg,
    String? foodDetails,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List purchaseArr = [];
    var myCart =
        '{"foodName" : "$foodName", "foodPrice" : "${foodPrice.toString()}", "foodQuantity": "${foodQuantity.toString()}", "foodImg": "$foodImg","foodDetail": "$foodDetails" }';

    try {
      await getCartItems().then((value) {
        if (value != null) {
          purchaseArr.addAll(value);
        }
      });

      Map cartMap = jsonDecode(myCart);
      purchaseArr.add(Purchase.fromJson(cartMap as Map<String, dynamic>));
      String orderedItem = json.encode(purchaseArr);
      prefs.setString("cart", orderedItem);

      showInSnackBar(
          '${cartMap["foodQuantity"]} orders of ${cartMap["foodName"]} have been added to cart');
    } catch (e) {
      print(e);
    }
  }

  Future<List?> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List? purchase;
    try {
      List? items = jsonDecode(prefs.getString("cart")!) ?? null;
      purchase = items;
    } catch (e) {
      print(e);
    }
    return purchase;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(
                  color: Colors.red,
                ),
                floating: true,
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: widget.foodImage!,
                  placeholder: (_, __) => Image.asset("assets/cs_icon.png"),
                )
                    // Container(
                    //   color: Colors.white,
                    //   child: Image(
                    //     fit: BoxFit.cover,
                    //     image: NetworkImage(widget.foodImage!),
                    //   ),
                    // ),
                    ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "GHS ${widget.price}",
                              style:
                                  TextStyle(fontSize: 25, fontFamily: "Cookie"),
                            ),
                          )),
                    ),
                    // Container(
                    //   child: Padding(
                    //       padding: const EdgeInsets.only(left: 20, top: 10),
                    //       child: Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Text(
                    //           "Delivery GHS ${widget.deliveryFee}",
                    //           style: TextStyle(
                    //             fontSize: 16,
                    //           ),
                    //         ),
                    //       )),
                    // ),
                    Container(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${widget.food}",
                              style: TextStyle(
                                  fontSize: 35, fontFamily: "Caveat Bold"),
                            ),
                          )),
                    ),
                    Container(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${widget.foodDetails}",
                              style: TextStyle(
                                  fontSize: 20, fontFamily: "kalam Regular"),
                            ),
                          )),
                    ),
                    Container(
                      child: Padding(
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
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      value: quantity,
                                    );
                                  }).toList(),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                child: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  _addToCart(
                    widget.food,
                    widget.price,
                    _selectedQuantity,
                    widget.foodImage,
                    widget.foodDetails,
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              onPressed: () {
                Navigator.of(context).popAndPushNamed("cart");
              },
              child: Text(
                "Checkout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
