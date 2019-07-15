import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: userProfile(),
        )
      ],
    );
  }

  Widget userProfile() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 5,
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 5.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: CircleAvatar(
                radius: 50,
                child: Image.asset("assets/avatar.png"),
              ),
              title: Row(
                children: <Widget>[
                  Icon(Icons.phone),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("0500000001"),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
