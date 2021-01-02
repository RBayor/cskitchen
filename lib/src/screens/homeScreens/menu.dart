import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cskitchen/src/screens/homeScreens/materialPages/fooditem.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Future getMenu() async {
    var db = FirebaseFirestore.instance;
    QuerySnapshot menu = await db.collection("menu").get();
    return menu.docs;
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
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              String imgUrl = snapshot.data[index]["img"];
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Fooditem(
                            snapshot.data[index]["food"],
                            snapshot.data[index]["price"],
                            imgUrl,
                            snapshot.data[index]["foodDetails"],
                          )),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: ListTile(
                    leading: Container(child: Image.network(imgUrl)),
                    title: Text(
                      snapshot.data[index]["food"],
                    ),
                    subtitle: Text('Ghs ${snapshot.data[index]["price"]}'),
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

// Card(
//                       clipBehavior: Clip.antiAlias,
//                       elevation: 5.0,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25.0)),
//                       child: Container(
//                         height: MediaQuery.of(context).size.height / 3.3,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: NetworkImage(snapshot.data[index]["img"]),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 10, bottom: 10),
//                               child: RaisedButton(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 onPressed: () {},
//                                 color: Colors.transparent,
//                                 child: Text(
//                                   "Ghs ${snapshot.data[index]["price"]}",
//                                   style: TextStyle(
//                                       fontSize: 20, color: Colors.red),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )),
