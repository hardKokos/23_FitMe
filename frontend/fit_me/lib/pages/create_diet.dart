import 'package:flutter/material.dart';
import 'package:fit_me/calendar.dart';
import 'package:fit_me/search_for_product.dart';

class CreateDietPage extends StatefulWidget {
  const CreateDietPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateDietPageState createState() => _CreateDietPageState();
}

class _CreateDietPageState extends State<CreateDietPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create diet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Adjusted text color
          ),
        ),
        backgroundColor: Colors.lime.shade400,
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchForProduct()),
            );
          }

          // Firebase - home_page, article_detail_page, article_page, challenges_page
          // Think about layout of bottomNavigationBar in each page
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventCalendarPage()),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}
