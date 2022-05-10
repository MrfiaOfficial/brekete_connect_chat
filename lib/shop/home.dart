import 'package:flutter/material.dart';
import 'package:group_chat_app/newshop/shope_home.dart';
import 'package:group_chat_app/pages/lib/main.dart';
import 'package:group_chat_app/shop/my_products.dart';
import 'package:group_chat_app/shop/pages/CartPage.dart';
import 'package:group_chat_app/shop/pages/ProfilePage1.dart';
import 'package:group_chat_app/shop/pages/SearchPage.dart';
import 'package:group_chat_app/utils/routes.dart';

class Homes extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Homes> {
  int selectedPosition = 0;
  List<Widget> listBottomWidget = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.search), title: Text("Search")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "My Products"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.person), title: Text("Account")),
        ],
        currentIndex: selectedPosition,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey.shade100,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (position) {
          setState(() {
            selectedPosition = position;
          });
        },
      ),
      body: Builder(builder: (context) {
        return listBottomWidget[selectedPosition];
      }),
    );
  }

  void addHomePage() {
    listBottomWidget.add(ShopsHomeScreen());
    // listBottomWidget.add(Searchs());
    listBottomWidget.add(MyProducts());
    // listBottomWidget.add(CartPage());
    // listBottomWidget.add(ProfilePage1());
  }
}
