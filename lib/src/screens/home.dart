import 'package:cskitchen/src/components/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/screens/homeScreens/menu.dart';
import 'package:cskitchen/src/screens/homeScreens/cart.dart';
import 'package:cskitchen/src/screens/homeScreens/profile.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  Home({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;

  Menu menu;
  Cart cart;
  Profile profile;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    super.initState();
    menu = Menu();
    cart = Cart(Auth());
    profile = Profile(
      auth: Auth(),
    );
    pages = [menu, cart, profile];
    currentPage = menu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cs kitchen",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[currentPage],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.fastfood,
              color: Colors.white,
            ),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: "cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
