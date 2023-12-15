import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CupSizeSettings extends StatefulWidget {
  const CupSizeSettings({super.key, required this.cupSize});

  final int cupSize;

  @override
  State<CupSizeSettings> createState() => _CupSizeSettingsState();
}

class _CupSizeSettingsState extends State<CupSizeSettings> {
  final User? user = Auth().currentUser;
  late int _cupSize;
  late int _setValue;
  bool isValueChanged = false;

  @override
  void initState() {
    super.initState();
    _cupSize = widget.cupSize;
    _setValue = _cupSize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set cup size'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set the size of your cup.',
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
                      minValue: 100,
                      maxValue: 500,
                      step: 50,
                      value: _setValue,
                      onChanged: (value) {
                        setState(() {
                          _setValue = value;
                          if(_setValue != _cupSize) {
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
                      )
                  ),
                  const SizedBox(height: 30,),
                  const Text(
                    'Cup size (ml)',
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
                              'cupSize': _setValue,
                            });
                          });
                        });
                        _cupSize = _setValue;
                        Navigator.pop(context, _cupSize);

                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('Apply'),
                  ) : const SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}