import 'package:cskitchen/src/components/auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cskitchen/src/screens/homeScreens/menu.dart';
import 'package:cskitchen/src/screens/homeScreens/cart.dart';
import 'package:cskitchen/src/screens/homeScreens/profile.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  Home({this.auth, this.onSignedOut});
  final BaseAuth? auth;
  final VoidCallback? onSignedOut;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;

  late Menu menu;
  late Cart cart;
  late Profile profile;
  late List<Widget> pages;
  late Widget currentPage;

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
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: AssetImage("assets/cs_icon.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              currentPage,
              // ClipRRect(
              //   clipBehavior: Clip.antiAlias,
              //   borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(30),
              //     bottomRight: Radius.circular(30),
              //   ),
              //   child: Container(
              //     height: 80,
              //     decoration: BoxDecoration(
              //         color: Color(0xFFE34343),
              //         borderRadius: BorderRadius.only(
              //           bottomLeft: Radius.circular(35),
              //           bottomRight: Radius.circular(35),
              //         ),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey.withOpacity(0.3),
              //             spreadRadius: 5,
              //             blurRadius: 7,
              //             offset: Offset(0, 3), // changes position of shadow
              //           ),
              //         ]),
              //     child: Center(
              //       child: Padding(
              //         padding: const EdgeInsets.only(top: 30),
              //         child: Text(
              //           "Cs kitchen",
              //           style: TextStyle(
              //             fontSize: 20,
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          // Stack(
          //   children: [currentPage],
          // ),
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
        ),
      ],
    );
  }
}
