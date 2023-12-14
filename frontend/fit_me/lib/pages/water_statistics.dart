import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_me/pages/cup_size_settings.dart';
import 'package:fit_me/pages/water_goal_settings.dart';
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
  late String _userDocumentId;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _waterAmount = 0;
  int _waterGoal = 2000;
  int _cupSize = 250;
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

    FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: user?.uid).get().then((QuerySnapshot querySnapshot) {
      _userDocumentId = querySnapshot.docs[0].id;
      _waterGoal = (querySnapshot.docs[0].data() as Map<String, dynamic>)['waterGoal'];
      _cupSize = (querySnapshot.docs[0].data() as Map<String, dynamic>)['cupSize'];
    });

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

  Future<void> updateWaterStatistic(int value) async {
    if(_waterAmount == 0 && value < 0) {
      return;
    }

    setState(() {
      _oldValue = _waterAmount;
      _newValue = _waterAmount + value;
      if(_newValue < 0) {
        _newValue = 0;
        _waterAmount = 0;
      }
      else {
        _waterAmount += value;
      }
    });

    _animation = IntTween(begin: _oldValue, end: _newValue).animate(_animationController);
    _animationController.forward(from: 0.0);

    if(_statisticsExist) {
      await FirebaseFirestore.instance
          .collection('waterStatistics')
          .doc(_statisticsId)
          .update({'waterAmount' : _waterAmount});
      print("XDDD");
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
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.lime.shade400,
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'setTarget',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  child: Text('Set target'),
                ),
                const PopupMenuItem(
                  value: 'setCupSize',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  child: Text('Set cup size'),
                ),

              ];
            },
            onSelected: (value) {
              if (value == 'setTarget') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaterGoalSettings(waterGoal: _waterGoal)),
                ).then((result) {
                  if (result != null) {
                    setState(() {
                      _waterGoal = result;
                    });
                  }
                });
              }
              else if(value == 'setCupSize') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CupSizeSettings(cupSize: _cupSize)),
                ).then((result) {
                  if (result != null) {
                    setState(() {
                      _cupSize = result;
                    });
                  }
                });
              }
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => updateWaterStatistic(-_cupSize),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                            ),
                            child: const Icon(Icons.remove),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "$_cupSize ml",
                            style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () => updateWaterStatistic(_cupSize),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }



}
