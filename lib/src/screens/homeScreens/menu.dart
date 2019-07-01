import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var db = Firestore.instance;

  Future getMenu() async {
    QuerySnapshot menu = await db.collection("menu").getDocuments();
    return menu.documents;
  }

  Future getFeatured() async {}

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 250,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/chips.jpg"),
                            fit: BoxFit.cover)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: RaisedButton(
                              onPressed: () {},
                              color: Colors.green,
                              child: Text(
                                "Ghs 20.00",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: FutureBuilder(
                future: getMenu(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return Padding(
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
                                        image:
                                            AssetImage("assets/fooditem.jpg"),
                                        fit: BoxFit.cover)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "${snapshot.data[index].data["food"]}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 10),
                                        child: RaisedButton(
                                          onPressed: () {},
                                          color: Colors.greenAccent[700],
                                          child: Text(
                                            "${snapshot.data[index].data["price"]}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
/**
 * ListView.builder(
                scrollDirection: Axis.horizontal,
                itemExtent: 250.0,
                itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.all(8),
                      child: Card(
                        elevation: 10,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/fooditem.jpg"),
                                  fit: BoxFit.cover)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Food Name",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  child: RaisedButton(
                                    onPressed: () {},
                                    color: Colors.greenAccent[700],
                                    child: Text(
                                      "Ghs 20.00",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
              ),
 */
