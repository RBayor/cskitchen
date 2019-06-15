import 'package:flutter/material.dart';

Widget loginBtn(registerPage, validateAndSubmit, resetPasswordForm) => Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Create account",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        registerPage();
                      },
                    ),
                    RaisedButton(
                        elevation: 10,
                        color: Colors.red[700],
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: validateAndSubmit),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Reset Password",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: resetPasswordForm,
                    )
                  ],
                ),
              ],
            ))
      ],
    );
