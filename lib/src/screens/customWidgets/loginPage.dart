import 'package:flutter/material.dart';

Widget loginBtn(verifyPhoneNo) => Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      elevation: 10,
                      color: Colors.red[700],
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: verifyPhoneNo,
                    ),
                  ],
                ),
              ],
            ))
      ],
    );
