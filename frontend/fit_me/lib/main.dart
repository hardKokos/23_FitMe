import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_me/calendar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:fit_me/widget_tree.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FitMe());
}

class FitMe extends StatelessWidget {
  const FitMe({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WidgetTree(),
    );
  }
}
