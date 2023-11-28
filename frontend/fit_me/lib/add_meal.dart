import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'calendar.dart';
import 'models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Here add a page with search bar to search api for products and display them with information
class AddMealPage extends StatefulWidget {
  const AddMealPage({Key? key}) : super(key: key);

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  TextEditingController textController = TextEditingController();
  int _currentIndex = 0;
  List<Product> products = [];
  String product = '';
  bool isSearchBarExpanded = false;

  @override
  void initState() {
    super.initState();
    isSearchBarExpanded = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> searchForProduct(String product) async {
    const String appID = '57af7125';
    const String appKey = '9e22e9b5a51e4da72f6e8caef869de76';
    final response = await http.get(Uri.parse(
        'https://api.edamam.com/api/food-database/v2/parser?app_id=$appID&app_key=$appKey&ingr=$product&nutrition-type=cooking'));
    Map<String, dynamic> responseBody =
        jsonDecode(response.body) as Map<String, dynamic>;

    List<dynamic> hints = responseBody['hints'];
    List<Product> newProducts = [];
    for (var element in hints) {
      newProducts.add(Product.fromJson(element['food']));
    }

    setState(() {
      products = newProducts;
    });
  }

  Widget buildText(String text) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          double.tryParse(text)?.toStringAsFixed(2) ?? text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget buildProductWidget(Product product) {
    return Container(
      //color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${product.label}',
              style: TextStyle(
                color: Colors.lime.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                buildText('${product.nutrients?.kcal} kcal'),
                buildText('${product.nutrients?.protein} protein'),
                buildText('${product.nutrients?.fat} fat'),
                buildText('${product.nutrients?.carbs} carbs'),
                buildText('${product.nutrients?.fiber} fiber'),
                Spacer(),
                Checkbox(
                  value: product.isSelected ?? false,
                  onChanged: (bool? value) {
                    // Decide if you want to add product to the meal
                    setState(() {
                      product.isSelected = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fit Me',
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
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventCalendarPage()),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
              child: AnimSearchBar(
                width: 400,
                textController: textController,
                rtl: true,
                onSuffixTap: () {
                  setState(() {
                    textController.clear();
                    isSearchBarExpanded = !isSearchBarExpanded;
                  });
                },
                onSubmitted: (String product) {
                  // Api call
                  searchForProduct(product);
                },
              ),
            ),
            // Build rows for food here?
            for (var product in products) buildProductWidget(product)
          ],
        ),
      ),
    );
  }
}
