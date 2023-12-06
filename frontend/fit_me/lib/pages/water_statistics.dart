import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'auth/auth.dart';
import 'package:fit_me/models/waterStatisticsModel.dart';

class WaterStatistics extends StatefulWidget {
  const WaterStatistics({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WaterStatisticsState createState() => _WaterStatisticsState();
}

class _WaterStatisticsState extends State<WaterStatistics> {
  final User? user = Auth().currentUser;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _waterAmount = 0;
  late WaterStatisticsModel _statistics;
  late String _statisticsId;
  bool _statisticsExist = false;

  @override
  void initState() {
    super.initState();
    print("XDinistate");
    _selectedDay = _focusedDay;
    DateTime? date = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 0, 0, 0, 0, 0);
    FirebaseFirestore.instance
        .collection('waterStatistics')
        .where('uid', isEqualTo: user?.uid)
        .where('date', isEqualTo: date)
        .get()
        .then((snapshots) {
          _displayWaterStatistics(snapshots.docs);
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<DocumentSnapshot>> fetchData() async {
    DateTime? date = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 0, 0, 0, 0, 0);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('waterStatistics')
        .where('uid', isEqualTo: user?.uid)
        .where('date', isEqualTo: date)
        .get();

    return snapshot.docs;
  }

  Future<void> updateWaterStatistic() async {
    setState(() {
      _waterAmount += 250;
    });

    if(_statisticsExist) {
      await FirebaseFirestore.instance
          .collection('waterStatistics')
          .doc(_statisticsId)
          .update({'waterAmount' : _waterAmount});
    }
    else {
      DateTime? date = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 0, 0, 0, 0, 0);
      Map<String, dynamic> data = {
        'uid': user?.uid,
        'date': date,
        'waterAmount': _waterAmount
      };

      DocumentReference documentReference = await FirebaseFirestore.instance.collection('waterStatistics').add(data);
      _statisticsExist = true;
      _statisticsId = documentReference.id;
    }
  }

  void _displayWaterStatistics(List<DocumentSnapshot> snapshots) {
    if(snapshots.isEmpty) {
      _statisticsExist = false;
      setState(() {
        _waterAmount = 0;
      });
    }
    else {
      _statisticsId =  snapshots[0].id;
      _statistics = WaterStatisticsModel.fromJson(snapshots[0].data() as Map<String, dynamic>);
      _statisticsExist = true;
      setState(() {
        _waterAmount = _statistics.waterAmount!;
      });
    }
  }


  Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _displayWaterStatistics(await fetchData());
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime yearAgo = DateTime.now().subtract(const Duration(days: 365));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Water',
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
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TableCalendar(
                firstDay: yearAgo,
                lastDay: DateTime.now(),
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
              // FutureBuilder<List<DocumentSnapshot>> (
              //   future: fetchData(),
              //   builder: (context, snapshot) {
              //     if(snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //     else if(snapshot.hasError) {
              //       return const Center(
              //         child: Text("Error has occurred..."),
              //       );
              //     }
              //     else {
              //       _displayWaterStatistics(snapshot.requireData);
              //       return
              //     }
              //   }
              // ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: [
                      Text(
                        _waterAmount.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 70,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "/ 2000 ml",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: updateWaterStatistic,
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.lime.shade400,
                        ),
                        child: const Text(
                          "+ 250 ml",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
