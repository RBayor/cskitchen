import 'package:cskitchen/src/components/auth.dart';
import 'package:cskitchen/src/screens/user/myOrders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({this.auth});
  final BaseAuth auth;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();
  int _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PreviousOrders(widget.auth))),
                      leading: Icon(
                        Icons.fastfood,
                        color: Colors.redAccent,
                      ),
                      title: Text("My orders"),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        Icons.security,
                        color: Colors.redAccent,
                      ),
                      title: Text("Privacy Policy"),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        Icons.warning,
                        color: Colors.redAccent,
                      ),
                      title: Text("Terms of Use"),
                    ),
                  ],
                ),
              )),
        )
      ],
    );
  }
}
