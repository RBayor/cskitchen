import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cskitchen/src/screens/homeScreens/materialPages/fooditem.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Future getMenu() async {
    var db = Firestore.instance;
    QuerySnapshot menu = await db.collection("menu").getDocuments();
    return menu.documents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMenu(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              String imgUrl = snapshot.data[index].data["img"];
              return InkWell(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Fooditem(
                                snapshot.data[index].data["food"],
                                snapshot.data[index].data["price"],
                                imgUrl,
                                snapshot.data[index].data["foodDetails"],
                              )),
                    ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10.0,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  snapshot.data[index].data["img"]),
                              fit: BoxFit.cover)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "${snapshot.data[index].data["food"]}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: RaisedButton(
                                onPressed: () {},
                                color: Colors.greenAccent[700],
                                child: Text(
                                  "${snapshot.data[index].data["price"]}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
