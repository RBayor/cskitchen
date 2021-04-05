import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cskitchen/src/screens/homeScreens/materialPages/fooditem.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
            return CustomScrollView(
              slivers: [
                // SliverAppBar(
                //   expandedHeight: 200,
                //   backgroundColor: Colors.transparent,
                // title: Text(
                //   "Satisfy Yor Cravings!",
                //   style: TextStyle(
                //     fontSize: 25,
                //     color: Colors.white54,
                //     fontFamily: "kalam Regular",
                //   ),
                //   ),
                //   flexibleSpace: ClipRRect(
                //     borderRadius: BorderRadius.only(
                //       bottomLeft: Radius.circular(80),
                //     ),
                //     child: FlexibleSpaceBar(
                //       background: Stack(
                //         children: [
                //           Align(
                //             alignment: Alignment.bottomLeft,
                //             child: Padding(
                //               padding:
                //                   const EdgeInsets.only(right: 100, bottom: 10),
                // child: Container(
                //   height: 100,
                //   decoration: ShapeDecoration(
                //     shape: CircleBorder(),
                //     color: Colors.red,
                //   ),
                // ),
                //             ),
                //           ),
                //           Align(
                //             alignment: Alignment.topRight,
                //             child: Padding(
                //               padding: const EdgeInsets.only(
                //                 left: 100,
                //                 top: 50,
                //                 right: 50,
                //               ),
                //               child: Container(
                //                 height: 50,
                //                 width: 50,
                //                 decoration: ShapeDecoration(
                //                   shape: RoundedRectangleBorder(),
                //                   color: Colors.green,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       title: Container(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.end,
                //           mainAxisSize: MainAxisSize.max,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                // Text("GHS 0 delivery fee!"),
                // Text(
                //   "on first order",
                //   style: TextStyle(fontSize: 13),
                // ),
                //           ],
                //         ),
                //       ),
                //       centerTitle: true,
                //     ),
                //   ),
                // ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 15, right: 15),
                    child: Container(
                      height: 200,
                      child: Card(
                        color: Colors.blue[200],
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 150, top: 20),
                              child: Container(
                                height: 100,
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  color: Colors.green[300],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 300, top: 110),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/logo.png"),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "GHS 0 delivery fee!",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      "on first order",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "kalam Regular",
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      "Satisfy Your Cravings!",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black54,
                                        fontFamily: "kalam Regular",
                                      ),
                                    )
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
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
                                    width: (MediaQuery.of(context).size.width -
                                        20),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
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
                  ),
                )
              ],
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

//  ListView.builder(
//               shrinkWrap: false,
//               scrollDirection: Axis.vertical,
//               itemCount: documents.length,
//               itemBuilder: (_, index) {
//                 String? imgUrl = documents[index]["img"];
//                 return InkWell(
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Fooditem(
//                         documents[index]["food"],
//                         documents[index]["price"],
//                         imgUrl,
//                         documents[index]["foodDetails"],
//                       ),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       left: 10.0,
//                       right: 10,
//                       top: 10,
//                       bottom: 10,
//                     ),
//                     child: Card(
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       elevation: 5.0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15.0),
//                       ),
//                       child: Stack(
//                         children: <Widget>[
//                           FittedBox(
//                             clipBehavior: Clip.hardEdge,
//                             child: CachedNetworkImage(
//                               height: 250,
//                               width: (MediaQuery.of(context).size.width - 20),
//                               fit: BoxFit.cover,
//                               imageUrl: documents[index]["img"],
//                               placeholder: (_, __) =>
//                                   Image.asset("assets/cs_icon.png"),
//                             ),
//                           ),
//                           Positioned(
//                             top: 160,
//                             left: 5,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.black45,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10))),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "GHS ${documents[index]["price"]}",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 200,
//                             left: 5,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.black54,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10))),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "${documents[index]["food"]}",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
