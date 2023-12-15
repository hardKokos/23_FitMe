import 'package:fit_me/calendar.dart';
import 'package:fit_me/pages/daily_activities_page.dart';
import 'package:fit_me/pages/diet_page.dart';
import 'package:fit_me/pages/home_page.dart';
import 'package:fit_me/pages/shop_page.dart';
import 'package:fit_me/pages/water_statistics.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const EventCalendarPage(),
    DietPage(),
    DailyActivitiesPage(),
    const WaterStatistics(),
    ShopPage(),
    HomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.create,
              color: Colors.white,
            ),
            label: 'Create diet',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.directions_run,
              color: Colors.white,
            ),
            label: 'Daily activities',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.coffee,
              color: Colors.white,
            ),
            label: 'Water',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag,
              color: Colors.white,
            ),
            label: 'Shopping',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box,
              color: Colors.white,
            ),
            label: 'Account',
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lime.shade400,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
