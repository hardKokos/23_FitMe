import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WaterGoalSettings extends StatefulWidget {
  const WaterGoalSettings({super.key, required this.waterGoal});

  final int waterGoal;

  @override
  State<WaterGoalSettings> createState() => _WaterGoalSettingsState();
}

class _WaterGoalSettingsState extends State<WaterGoalSettings> {
  final User? user = Auth().currentUser;
  late int _waterGoal;
  late int _setValue;
  bool isValueChanged = false;

  @override
  void initState() {
    super.initState();
    _waterGoal = widget.waterGoal;
    _setValue = _waterGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set target'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Good health starts with staying hydrated! Set a daily water intake target to stay on track.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 50,),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumberPicker(
                      minValue: 500,
                      maxValue: 6000,
                      step: 100,
                      value: _setValue,
                      onChanged: (value) {
                        setState(() {
                          _setValue = value;
                          if(_setValue != _waterGoal) {
                            isValueChanged = true;
                          }
                          else {
                            isValueChanged = false;
                          }
                        });
                      },
                    selectedTextStyle: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 29,
                    ),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                  ),
                  const SizedBox(height: 30,),
                  const Text(
                    'Daily water intake (ml)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30,),
                  isValueChanged
                      ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isValueChanged = false;

                        FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: user?.uid).get().then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            FirebaseFirestore.instance.collection('Users').doc(doc.id).update({
                              'waterGoal': _setValue,
                            });
                          });
                        });
                        _waterGoal = _setValue;
                        Navigator.pop(context, _waterGoal);

                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('Apply'),

                  ) : const SizedBox(),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}