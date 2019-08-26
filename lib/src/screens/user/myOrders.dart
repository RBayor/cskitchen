import 'package:cskitchen/src/components/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreviousOrders extends StatefulWidget {
  PreviousOrders(this.auth);
  final BaseAuth auth;
  @override
  _PreviousOrdersState createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders> {
  Future getPreviousOrders() async {
    var id = await widget.auth.currentUser();
    var db = Firestore.instance;
    DocumentSnapshot orders = await db.collection("orders").document(id).get();
    return orders.data['order'];
  }

  @override
  void initState() {
    super.initState();
    getPreviousOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: FutureBuilder(
        future: getPreviousOrders(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return Container(
                      child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: ListTile(
                        title: Text(
                            "${snapshot.data[index]['food'].toUpperCase()}"),
                        trailing: Text("${snapshot.data[index]['quantity']}"),
                      ),
                    ),
                  ));
                },
              );
            } else {
              return Container(
                  child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: ListTile(
                    title: Text("No purchase yet!"),
                    trailing: Text("Go buy something"),
                  ),
                ),
              ));
              ;
            }
          }
        },
      ),
    );
  }
}
