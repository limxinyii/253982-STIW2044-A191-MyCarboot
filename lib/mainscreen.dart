import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_2/tab_screen2.dart';
import 'package:lab_2/tab_screen3.dart';
import 'package:lab_2/tab_screen4.dart';
import 'package:lab_2/user.dart';
import 'tab_screen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreen(user: widget.user),
      TabScreen3(user: widget.user),
      //TabScreen2(user: widget.user),
      TabScreen4(user: widget.user),
    ];
  }

  String $pagetitle = "My Carboot";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.redAccent));
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text("Purchases"),
          ),
         /* BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus, ),
            title: Text("Delivery"),
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.person, ),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }
}
