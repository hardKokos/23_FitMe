import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DietPage extends StatefulWidget {
  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  String selectedDiet = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fit Me',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.lime.shade400,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('DietProducts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          var dietProductsData = snapshot.data!.docs;

          List<DocumentSnapshot> selectedDietBreakfast = [];
          List<DocumentSnapshot> selectedDietSecondBreakfast = [];
          List<DocumentSnapshot> selectedDietLunch = [];
          List<DocumentSnapshot> selectedDietSnack = [];
          List<DocumentSnapshot> selectedDietDinner = [];
          List<DocumentSnapshot> selectedDietSupper = [];

          dietProductsData.forEach((product) {
            var page = product['page'];
            var type = product['type'];

            if (page == selectedDiet) {
              if (type == 'breakfast') {
                selectedDietBreakfast.add(product);
              } else if (type == 'second breakfast') {
                selectedDietSecondBreakfast.add(product);
              } else if (type == 'lunch') {
                selectedDietLunch.add(product);
              } else if (type == 'snack') {
                selectedDietSnack.add(product);
              } else if (type == 'dinner') {
                selectedDietDinner.add(product);
              } else if (type == 'supper') {
                selectedDietSupper.add(product);
              }
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildPageSelectionMenu(),
                buildCategoryCard('Breakfast', selectedDietBreakfast),
                buildCategoryCard('Second Breakfast', selectedDietSecondBreakfast),
                buildCategoryCard('Lunch', selectedDietLunch),
                buildCategoryCard('Snack', selectedDietSnack),
                buildCategoryCard('Dinner', selectedDietDinner),
                buildCategoryCard('Supper', selectedDietSupper),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildPageSelectionMenu() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            'Select Diet:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          DropdownButton<String>(
            value: selectedDiet,
            items: ['1', '2', '3'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedDiet = newValue ?? '1';
              });
            },
          ),
        ],
      ),
    );
  }

Widget buildCategoryCard(String category, List<DocumentSnapshot> products) {
  return Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildAddButton(category, products),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            var productName = products[index]['name'];
            var productImage = products[index]['image'];
            var productKcal = products[index]['KCAL'];
            var productProtein = products[index]['PROTEIN'];
            var productCarbs = products[index]['CARBS'];
            var productFat = products[index]['FAT'];

            return ListTile(
              title: Text(productName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    productImage,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  Text('KCAL: $productKcal'),
                  Text('Protein: $productProtein'),
                  Text('Carbs: $productCarbs'),
                  Text('Fat: $productFat'),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

  Widget buildAddButton(String category, List<DocumentSnapshot> products) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.lime.shade400,
        child: IconButton(
          onPressed: () {
            showAddPopup(category, products);
          },
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void showAddPopup(String category, List<DocumentSnapshot> products) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Product to $category'),
          content: Column(
            children: [
              Text('Category: $category'),
              SizedBox(height: 10),
              Text('Products:'),
              buildProductList(products),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget buildProductList(List<DocumentSnapshot> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: products.map((product) {
        var productName = product['name'];
        return Text('- $productName');
      }).toList(),
    );
  }
}
