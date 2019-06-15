import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
              child: Text(
                "Featured",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
              child: Text(
                "Menu",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 250,
              child: ListView.builder(
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
            ),
          ],
        )
      ],
    );
  }
}
