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
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                NetworkImage(snapshot.data[index].data["img"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onPressed: () {},
                                color: Colors.transparent,
                                child: Text(
                                  "Ghs ${snapshot.data[index].data["price"]}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
            },
          );
        }
      },
    );
  }
}
/**
 *  Container(
                      height: MediaQuery.of(context).size.height / 3.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data[index].data["img"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, bottom: 10),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {},
                              color: Colors.transparent,
                              child: Text(
                                "${snapshot.data[index].data["food"]}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, bottom: 10),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {},
                              color: Colors.transparent,
                              child: Text(
                                "Ghs ${snapshot.data[index].data["price"]}",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
 */
/**
 * Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${snapshot.data[index].data["food"]}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Material(
                                  child: Text(
                                    "Ghs ${snapshot.data[index].data["price"]}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height / 5,
                                child: Image.network(
                                  snapshot.data[index].data["img"],
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
 */
