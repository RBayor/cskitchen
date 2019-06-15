import 'package:flutter/material.dart';

Widget resetPasswordScreen(_email) => Column(
      children: <Widget>[
        CircleAvatar(
            radius: 65,
            backgroundColor: Colors.white,
            child: Image(
              image: AssetImage("assets/cs_logo.png"),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Reset Password",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                labelText: 'Email Address',
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                labelStyle: TextStyle(color: Colors.white)),
            validator: (value) =>
                value.isEmpty ? "Please input an email" : null,
            onSaved: (value) => _email = value,
          ),
        ),
      ],
    );

Widget resetPasswordBtn(loginPage, resetPassword) => Padding(
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: loginPage,
          ),
          RaisedButton(
            elevation: 10,
            color: Colors.red[700],
            child: Text(
              "Reset",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: resetPassword,
          ),
        ],
      ),
    );
