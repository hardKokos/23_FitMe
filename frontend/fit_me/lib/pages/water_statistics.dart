import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'auth/auth.dart';
import 'package:fit_me/pages/circle_progress_indicator.dart';
import 'package:fit_me/models/waterStatisticsModel.dart';

class WaterStatistics extends StatefulWidget {
  const WaterStatistics({Key? key}) : super(key: key);

  @override
  State<WaterStatistics> createState() => _WaterStatisticsState();
}

class _WaterStatisticsState extends State<WaterStatistics> with TickerProviderStateMixin {
  final User? user = Auth().currentUser;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _waterAmount = 0;
  int _waterGoal = 2000;
  late WaterStatisticsModel _statistics;
  late String _statisticsId;
  bool _statisticsExist = false;
  late AnimationController _animationController;
  late Animation<int> _animation;
  late int _oldValue;
  late int _newValue;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _oldValue = 0;
    _newValue = 0;

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = IntTween(begin: _oldValue, end: _newValue).animate(_animationController);

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
    _animationController.dispose();
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
      _oldValue = _waterAmount;
      _newValue = _waterAmount + 250;
      _waterAmount += 250;
    });

    _animation = IntTween(begin: _oldValue, end: _newValue).animate(_animationController);
    _animationController.forward(from: 0.0);

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
      _newValue = 0;
      setState(() {
        _waterAmount = 0;
      });

      _animation = IntTween(begin: _oldValue, end: 0).animate(_animationController);
      _animationController.forward(from: 0.0);
      _oldValue = 0;
    }
    else {
      _statisticsId =  snapshots[0].id;
      _statistics = WaterStatisticsModel.fromJson(snapshots[0].data() as Map<String, dynamic>);
      _statisticsExist = true;
      _oldValue = _waterAmount;
      _newValue = _statistics.waterAmount!;
      _animationController.forward();
      setState(() {
        _waterAmount = _statistics.waterAmount!;
      });
      _animation = IntTween(begin: _oldValue, end: _newValue).animate(_animationController);
      _animationController.forward(from: 0.0);
      _oldValue = _newValue;
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
                  margin: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return CustomPaint(
                            foregroundPainter: CircleProgressIndicator(_animation.value, _waterGoal),
                            child: SizedBox(
                              width: 300,
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _animation.value.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 70,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '/ $_waterGoal ml',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: updateWaterStatistic,
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.blueAccent,
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
