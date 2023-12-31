import 'package:fit_me/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_me/pages/auth/auth.dart';
import 'package:fit_me/pages/login_register_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainPage();
          } else {
            return const LoginPage();
          }
        });
  }
}
