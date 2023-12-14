import 'package:fit_me/models/shoppingItem.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:fit_me/pages/auth/widget_tree.dart';
import 'package:shopping_cart/shopping_cart.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FitMe());
}

class FitMe extends StatelessWidget {
  const FitMe({super.key});

  @override
  Widget build(BuildContext context) {
    ShoppingCart.init<shoppingItemModel>();
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
    );
  }
}
