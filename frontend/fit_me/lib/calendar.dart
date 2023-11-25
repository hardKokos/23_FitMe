import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarPage extends StatefulWidget {
  const EventCalendarPage({Key? key}) : super(key: key);

  @override
  _EventCalendarPageState createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends State<EventCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      showUnselectedLabels: true,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.blue,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_month,
            color: Colors.black,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          label: 'Find product',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.create,
            color: Colors.black,
          ),
          label: 'Create diet',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.directions_run,
            color: Colors.black,
          ),
          label: 'Daily activities',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.coffee,
            color: Colors.black,
          ),
          label: 'Water',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_bag,
            color: Colors.black,
          ),
          label: 'Fit Shops',
        ),
      ],
    );
  }

  Widget buildRow(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime threeYearsAgo =
        DateTime.now().subtract(const Duration(days: 3 * 365));
    DateTime threeYearsForth =
        DateTime.now().add(const Duration(days: 3 * 365));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TableCalendar(
            firstDay: threeYearsAgo,
            lastDay: threeYearsForth,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          buildRow('Text 1'),
          buildRow('Text 2'),
          buildRow('Text 3'),
          buildRow('Text 4'),
          buildRow('Text 5'),
        ],
      ),
    );
  }
}
