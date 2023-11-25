import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarPage extends StatefulWidget {
  const EventCalendarPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.lime.shade400,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
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
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.lime.shade400,
            child: IconButton(
              onPressed: () {
                // Add on press event
              },
              icon: const Icon(Icons.add, color: Colors.white),
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
          'Fit Me',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Adjusted text color
          ),
        ),
        backgroundColor: Colors.lime.shade400,
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: buildBottomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey[850],
              child: TableCalendar(
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
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle:
                      const TextStyle(color: Colors.lightGreenAccent),
                  holidayTextStyle: const TextStyle(color: Colors.lime),
                  todayDecoration: const BoxDecoration(
                    color: Colors.lime,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                  selectedDecoration: BoxDecoration(
                    color: Colors.lime.shade400,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: const TextStyle(color: Colors.white),
                ),
                headerStyle: const HeaderStyle(
                  leftChevronIcon:
                      Icon(Icons.arrow_back_ios, color: Colors.lime),
                  rightChevronIcon:
                      Icon(Icons.arrow_forward_ios, color: Colors.lime),
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                  formatButtonVisible: false,
                ),
              ),
            ),
            buildRow('Brekfast'),
            buildRow('Second brekfast'),
            buildRow('Lunch'),
            buildRow('Dinner'),
            buildRow('Snack'),
            buildRow('Supper'),
          ],
        ),
      ),
    );
  }
}
