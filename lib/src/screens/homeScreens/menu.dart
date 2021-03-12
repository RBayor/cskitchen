import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cskitchen/src/screens/homeScreens/materialPages/fooditem.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // Future getMenu() async {
  //   var db = ;
  //   QuerySnapshot menu = db.collection("menu").get();
  //   FirebaseFirestore.instance.collection("menu").get()
  //   return menu.docs;
  // }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("menu").get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.vertical,
              itemCount: documents.length,
              itemBuilder: (_, index) {
                String? imgUrl = documents[index]["img"];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Fooditem(
                        documents[index]["food"],
                        documents[index]["price"],
                        imgUrl,
                        documents[index]["foodDetails"],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Stack(
                        children: <Widget>[
                          FittedBox(
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              height: 250,
                              width: (MediaQuery.of(context).size.width - 20),
                              fit: BoxFit.cover,
                              imageUrl: documents[index]["img"],
                              placeholder: (_, __) =>
                                  Image.asset("assets/cs_icon.png"),
                            ),
                          ),
                          Positioned(
                            top: 160,
                            left: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "GHS ${documents[index]["price"]}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 200,
                            left: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${documents[index]["food"]}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
