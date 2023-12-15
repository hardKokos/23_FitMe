import 'package:fit_me/firebase.dart';
import 'package:fit_me/models/product.dart';
import 'package:fit_me/pages/search_for_product.dart';
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
  List<Product> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await updateSelectedProducts();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        updateSelectedProducts();
      });
    }
  }

  Future<void> updateSelectedProducts() async {
    selectedProducts = await searchForSelectedProducts(_selectedDay);
    setState(() {});
  }

  Future<void> _navigateToSearchForProduct(
      String mealType, DateTime? _selectedDay) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchForProduct(),
        settings: RouteSettings(arguments: {
          'mealType': mealType,
          'date': _selectedDay,
        }),
      ),
    );

    // Update products and refresh UI
    await updateSelectedProducts();
    setState(() {});
  }

  double calculateTotalDailyCalories() {
    double totalCalories = 0.0;

    for (var product in selectedProducts) {
      if (product.nutrients?.kcal != null) {
        totalCalories += product.nutrients!.kcal!;
      }
    }

    return totalCalories;
  }

  Widget buildTotalCalories() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Daily Calories:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '${calculateTotalDailyCalories().toStringAsFixed(2)} kcal',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(String mealType) {
    List<Product> filteredProducts = selectedProducts
        .where((product) =>
            product.mealType?.toLowerCase() == mealType.toLowerCase())
        .toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                mealType,
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
                  onPressed: () =>
                      _navigateToSearchForProduct(mealType, _selectedDay),
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    filteredProducts[index].label!,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${filteredProducts[index].nutrients!.kcal?.toStringAsFixed(2)} kcal',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
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
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.lime.shade400,
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.grey[850],
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
                    color: Colors.green,
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
            buildTotalCalories()
          ],
        ),
      ),
    );
  }
}
