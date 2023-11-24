import 'package:fit_me/calendar.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const FitMe());
}

class FitMe extends StatelessWidget {
  const FitMe({super.key});

@override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EventCalendarPage(),
    );
  }
}