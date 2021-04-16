import 'package:cskitchen/src/components/auth.dart';
import 'package:cskitchen/src/screens/user/platinum.dart';
import 'package:cskitchen/src/screens/user/privacy.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({this.auth});
  final BaseAuth? auth;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();

  void _signOut() {
    try {
      widget.auth!.signOut();
      Navigator.of(context).pushReplacementNamed("login");
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
            ),
            child: ListView(
              children: <Widget>[
                ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Privacy())),
                  leading: Icon(
                    Icons.security,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Platinum())),
                  leading: Icon(
                    Icons.code,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    "Developer",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: _signOut,
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
