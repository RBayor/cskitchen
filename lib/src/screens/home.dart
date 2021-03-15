import 'package:cskitchen/src/components/auth.dart';
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
                  Icons.fastfood_outlined,
                  color: Colors.white,
                ),
                label: "Menu",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart_outlined,
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
