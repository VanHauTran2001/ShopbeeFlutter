
import 'package:flutter/material.dart';
import 'package:saleshoppingapp/screens/chat/chat.dart';
import 'package:saleshoppingapp/screens/favorite/favorite.dart';
import 'package:saleshoppingapp/screens/home/home.dart';
import 'package:saleshoppingapp/screens/notification/notification.dart';
import 'package:saleshoppingapp/screens/profile/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MenuHome extends StatefulWidget {

  @override
  State<MenuHome> createState() => _HomeState();
}

class _HomeState extends State<MenuHome> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = [
    //Home screen
    Home(),
    //Favorite
    Favorite(),
    //Notification
    NotificationScreen(),
    //Chat
    Chat(),
    //Profile
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child:_widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      onTap: (index){
        setState(() {
          _selectedIndex = index;
        });
      },
      height: 55,
      color: Colors.teal,
      items: const [
        Icon(
          Icons.home,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.favorite,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.notifications,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.chat,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.person,
          size: 30,
          color: Colors.white,
        ),
      ],
    ),

    );
  }
}


