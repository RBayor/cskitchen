import 'package:flutter/material.dart';

Widget registerBtn(loginPage, validateAndSubmit) => Padding(
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text(
              "Already have an account? Login",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: loginPage,
          ),
          RaisedButton(
            elevation: 10,
            color: Colors.red[700],
            child: Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: validateAndSubmit,
          ),
        ],
      ),
    );
