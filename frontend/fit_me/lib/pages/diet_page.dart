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
      backgroundColor: Colors.grey[850],
      body: StreamBuilder(
        stream:
        FirebaseFirestore.instance.collection('DietProducts').snapshots(),
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
                buildCategoryCard(
                    'Second Breakfast', selectedDietSecondBreakfast),
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
          const Text(
            'Select Diet:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: selectedDiet,
            dropdownColor: Colors.grey[800],
            items: ['1', '2', '3'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
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
      color: Colors.grey[800],
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
                  style: const TextStyle(
                    color: Colors.white,
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
                title: Text(
                  productName,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        Image.network(
                          productImage,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 30,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kcal: $productKcal',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              'Protein: $productProtein',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              'Carbs: $productCarbs',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              'Fat: $productFat',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
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
          backgroundColor: Colors.grey[800],
          title: Text(
            'Add Product to $category',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          content: Column(
            children: [
              Text(
                'Category: $category',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Products:',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              buildProductList(products),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        return Text(
          '- $productName',
          style: const TextStyle(
            color: Colors.white,
          ),
        );
      }).toList(),
    );
  }
}
