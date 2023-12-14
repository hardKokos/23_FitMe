// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:fit_me/models/product.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:fit_me/models/constants.dart';
import 'package:fit_me/firebase.dart';
import 'package:customizable_counter/customizable_counter.dart';

class SearchForProduct extends StatefulWidget {
  const SearchForProduct({Key? key}) : super(key: key);

  @override
  State<SearchForProduct> createState() => _SearchForProductState();
}

class _SearchForProductState extends State<SearchForProduct> {
  final productTextFieldController = TextEditingController();
  TextEditingController counterTextController = TextEditingController();
  List<Product> products = [];
  List<Product> succesfullyAddedProducts = [];
  List<Product> selectedProducts = [];
  bool isSearchBarExpanded = false;
  late String chosenMeal;
  double counterValue = 100;
  int productIndex = 0;
  String? userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chosenMeal = ModalRoute.of(context)?.settings.arguments as String;
  }

  @override
  void dispose() {
    productTextFieldController.dispose();
    super.dispose();
  }

  Future<void> scanAndFindProduct(BuildContext buildContext) async {
    var scanResult = (await BarcodeScanner.scan());
    const String appID = '57af7125';
    const String appKey = '9e22e9b5a51e4da72f6e8caef869de76';
    String upc = scanResult.rawContent;
    if (upc.isEmpty) {
      return;
    }
    final response = await http.get(Uri.parse(
        'https://api.edamam.com/api/food-database/v2/parser?app_id=$appID&app_key=$appKey&upc=$upc&nutrition-type=cooking'));

    Map<String, dynamic> responseBody =
        jsonDecode(response.body) as Map<String, dynamic>;

    Product product = Product.fromJson(responseBody['hints'][0]['food']);

    if (context.mounted) {
      showProductOnModalBottomSheet(context, product, product.isSelected);
    }
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

    String? uid = await authUser();
    List<Product> produtsSelected = [];
    produtsSelected = await searchForSelectedProducts();

    setState(() {
      products = newProducts;
      userId = uid;
      selectedProducts = produtsSelected;
    });

    for (Product product in products) {
      if (product.label != null &&
          product.nutrients != null &&
          product.nutrients!.kcal != null &&
          product.nutrients!.fat != null &&
          product.nutrients!.carbs != null &&
          product.nutrients!.protein != null &&
          product.nutrients!.fiber != null &&
          product.foodId != null &&
          product.isSelected != null) {
        addProduct(
          product.label.toString(),
          (product.nutrients!.kcal! / 100) * counterValue,
          (product.nutrients!.fat! / 100) * counterValue,
          (product.nutrients!.carbs! / 100) * counterValue,
          (product.nutrients!.protein! / 100) * counterValue,
          (product.nutrients!.fiber! / 100) * counterValue,
          userId,
          product.isSelected!,
          chosenMeal,
          product.foodId!,
          product.image!,
          counterValue,
        );
        succesfullyAddedProducts.add(product);
      } else {
        print('Skipping product due to null properties: $product');
      }
    }
  }

  void updateProductAndRebuild(Product product) {
    setState(() {
      product.isSelected = true;
      succesfullyAddedProducts.add(product);
    });
    buildProductCard(product, productIndex);
  }

  Future<void> showProductOnModalBottomSheet(
      BuildContext context, Product product, bool? displayAddedProduct) async {
    if (displayAddedProduct == false) {
      showModalBottomSheet<Product>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                color: Colors.grey[850],
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildProductImage(product),
                    const SizedBox(height: 10),
                    Text(
                      product.label!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    buildNutrientText('Calories',
                        (product.nutrients!.kcal! / 100) * counterValue),
                    buildNutrientText(
                        'Fat', (product.nutrients!.fat! / 100) * counterValue),
                    buildNutrientText('Carbs',
                        (product.nutrients!.carbs! / 100) * counterValue),
                    buildNutrientText('Protein',
                        (product.nutrients!.protein! / 100) * counterValue),
                    buildNutrientText('Fiber',
                        (product.nutrients!.fiber! / 100) * counterValue),
                    const SizedBox(height: 20),
                    buildCounter(setState),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        double kcal =
                            (product.nutrients!.kcal! / 100) * counterValue;
                        double fat =
                            (product.nutrients!.fat! / 100) * counterValue;
                        double carbs =
                            (product.nutrients!.carbs! / 100) * counterValue;
                        double protein =
                            (product.nutrients!.protein! / 100) * counterValue;
                        double fiber =
                            (product.nutrients!.fiber! / 100) * counterValue;

                        updateProductAndRebuild(product);

                        updateProduct(
                          product.foodId!,
                          kcal,
                          fat,
                          carbs,
                          protein,
                          fiber,
                          counterValue,
                          true,
                        );

                        buildProductCard(product, productIndex);

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lime.shade400,
                      ),
                      child: const Text('Add this product to your meal'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } else {
      // Display the product differently, e.g., in a different widget or screen.
      // You can customize this part based on your requirements.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(product.label ?? ''),
            content: Column(
              children: [
                // You can customize this part with your specific UI for displaying product details
                Text(
                    'Calories: ${(product.nutrients?.kcal ?? 0.0).toStringAsFixed(2)} kcal'),
                Text(
                    'Fat: ${(product.nutrients?.fat ?? 0.0).toStringAsFixed(2)}'),
                // ... Add more product details as needed
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  deleteProduct(product.foodId, product.label);
                  setState(() {
                    succesfullyAddedProducts.remove(product);
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime.shade400,
                ),
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildCounter(StateSetter setState) {
    return CustomizableCounter(
      borderColor: Colors.lime.shade400,
      borderWidth: 2,
      borderRadius: 50,
      backgroundColor: Colors.lime.shade400,
      textColor: Colors.white,
      textSize: 22,
      count: 100,
      step: 10,
      minCount: 0,
      maxCount: 3000,
      incrementIcon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      decrementIcon: const Icon(
        Icons.remove,
        color: Colors.white,
      ),
      onCountChange: (count) {
        setState(() {
          counterValue = count.toDouble();
        });
      },
      onIncrement: (count) {
        count += 10;
      },
      onDecrement: (count) {
        count -= 10;
      },
    );
  }

  Widget buildNutrientText(String label, double? value) {
    return Text(
      '$label: ${value != null ? value.toStringAsFixed(2) : "N/A"}',
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget buildProductImage(Product product) {
    return product.image != null
        ? Image.network(
            product.image!,
            height: 75,
            errorBuilder: (context, exception, stackTrace) {
              return Image.network(
                Constants.noImagePlaceholder,
                height: 75,
              );
            },
          )
        : Image.network(
            Constants.noImagePlaceholder,
            height: 75,
          );
  }

  Widget buildProductCard(Product product, int index) {
    return Card(
      key: ValueKey(product.foodId),
      margin: const EdgeInsets.all(10),
      child: ListTile(
        tileColor: product.isSelected! ||
                selectedProducts.any((selectedProduct) =>
                    selectedProduct.isSelected == true &&
                    selectedProduct.foodId == product.foodId &&
                    selectedProduct.label == product.label)
            ? Colors.lime.shade400
            : Colors.grey[700],
        textColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        subtitleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        leading: buildProductImage(product),
        title: Text(product.label!),
        subtitle: Text('${product.nutrients?.kcal} kcal'),
        onTap: () {
          // Fetch data from database
          if (selectedProducts.any((selectedProduct) =>
              selectedProduct.isSelected == true &&
              selectedProduct.foodId == product.foodId &&
              selectedProduct.label == product.label)) {
            showProductOnModalBottomSheet(context, product, true);
          } else {
            showProductOnModalBottomSheet(context, product, product.isSelected);
          }
          setState(() {
            productIndex = index;
          });
        },
      ),
    );
  }

  Widget _scanProductButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => scanAndFindProduct(context),
      label: const Text('Scan code'),
      icon: const Icon(Icons.barcode_reader),
      backgroundColor: Colors.lime.shade400,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          chosenMeal,
          style: const TextStyle(
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: AnimSearchBar(
                    width: 400,
                    textController: productTextFieldController,
                    rtl: true,
                    onSuffixTap: () {
                      setState(() {
                        productTextFieldController.clear();
                        isSearchBarExpanded = !isSearchBarExpanded;
                      });
                    },
                    onSubmitted: (String product) {
                      searchForProduct(product);
                    },
                  ),
                ),
              ],
            ),
            succesfullyAddedProducts.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: succesfullyAddedProducts.length,
                      itemBuilder: (context, index) {
                        return buildProductCard(
                            succesfullyAddedProducts[index], index);
                      },
                    ),
                  )
                : const SizedBox(height: 0.0),
          ],
        ),
      ),
      floatingActionButton: _scanProductButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
