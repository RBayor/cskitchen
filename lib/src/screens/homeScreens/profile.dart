import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cskitchen/src/components/auth.dart';
import 'package:cskitchen/src/screens/user/myOrders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  Profile({this.auth});
  final BaseAuth auth;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();
  int _phoneNumber;
  addPhoneNumber(BuildContext context, title) {
    int _phoneNum;
    Widget submitBtn = RaisedButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        formKey.currentState.save();
        setState(() {
          _phoneNumber = _phoneNum;
        });
        print(_phoneNum);
        Navigator.of(context).pop();
      },
    );
    Widget cancelBtn = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Form(
        key: formKey,
        child: TextFormField(
          decoration: InputDecoration(labelText: "New Phone Number"),
          onSaved: (value) {
            _phoneNum = int.parse(value);
            setPhoneNumber();
          },
        ),
      ),
      actions: [cancelBtn, submitBtn],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  setPhoneNumber() async {
    var id = await widget.auth.currentUser();
    var db = Firestore.instance.collection("orders").document(id);

    /*db.updateData(
      {"phone": _phoneNumber},
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: userProfile(),
        ),
        Expanded(
          child: Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
                          Icons.home,
                          color: Colors.redAccent,
                        ),
                        title: Text("Address"),
                      ),
                      Divider(),
                      ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.redAccent,
                        ),
                        title: Text("Wallet"),
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
                ),
              )),
        )
      ],
    );
  }

  Widget userProfile() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        print("hello");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        addPhoneNumber(context, "Phone Number");
                      },
                      child: Icon(
                        Icons.phone,
                        color: Colors.redAccent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        _phoneNumber == null
                            ? "054 000 0000"
                            : "0${_phoneNumber.toString()}",
                        style: TextStyle(
                            fontSize: 18, fontFamily: "kalam Regular"),
                      ),
                    )
                  ],
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "My Wallet",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Ghs 0.00",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
