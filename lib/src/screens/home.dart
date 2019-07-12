import 'package:cskitchen/src/logic/auth.dart';
import 'package:cskitchen/src/logic/clipArt.dart';
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

  void _signOut() async {
    try {
      await widget.auth.signOut().then((onValue) {
        widget.onSignedOut();
      });
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    menu = Menu();
    cart = Cart();
    profile = Profile();
    pages = [menu, cart, profile];
    currentPage = menu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cs Kitchen",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: "Logout",
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: GeneralClip(),
          ),
          currentPage
        ],
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
              title: Text(
                "Menu",
                style: TextStyle(color: Colors.white),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              title: Text(
                "cart",
                style: TextStyle(color: Colors.white),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
