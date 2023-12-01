import 'package:fit_me/calendar.dart';
import 'package:fit_me/pages/article_page.dart';
import 'package:fit_me/pages/challenges_page.dart';
import 'package:fit_me/pages/home_page.dart';
import 'package:fit_me/search_for_product.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() =>
      _MainPageState();
}

class _MainPageState
    extends State<MainPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
      EventCalendarPage(),
      SearchForProduct(),
      ArticlePage(),
      ChallengesPage(),
      EventCalendarPage(),
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
            Icons.search,
            color: Colors.white,
          ),
          label: 'Find product',
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
          label: 'Fit Shops',
          backgroundColor: Colors.black,
        ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
