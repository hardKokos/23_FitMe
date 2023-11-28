import 'dart:convert';
import 'package:fit_me/models/product.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;

class SearchForProduct extends StatefulWidget {
  const SearchForProduct({Key? key}) : super(key: key);

  @override
  State<SearchForProduct> createState() => _SearchForProductState();
}

class _SearchForProductState extends State<SearchForProduct> {
  final productTextFieldController = TextEditingController();
  List<Product> products = [];

  Widget _title() {
    return const Text('FitMe');
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
    if(upc.isEmpty) {
      return;
    }
    final response = await http
        .get(Uri.parse('https://api.edamam.com/api/food-database/v2/parser?app_id=$appID&app_key=$appKey&upc=$upc&nutrition-type=cooking'));

    Map<String, dynamic> responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    Product product = Product.fromJson(responseBody['hints'][0]['food']);

    if(context.mounted) {
      showProductOnModalBottomSheet(context, product);
    }
  }

  Future<void> searchForProduct() async {
    const String appID = '57af7125';
    const String appKey = '9e22e9b5a51e4da72f6e8caef869de76';
    String ingr = productTextFieldController.text;
    final response = await http
        .get(Uri.parse('https://api.edamam.com/api/food-database/v2/parser?app_id=$appID&app_key=$appKey&ingr=$ingr&nutrition-type=cooking'));
    Map<String, dynamic> responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    List<dynamic> hints = responseBody['hints'];
    List<Product> newProducts = [];
    for(var element in hints) {
      newProducts.add(Product.fromJson(element['food']));
    }

    setState(() {
      products = newProducts;
    });
  }

  Widget _scanProductButton(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: () => scanAndFindProduct(context),
        label: const Text('Scan code'),
        icon: const Icon(Icons.barcode_reader),
    );
  }


  Future<void> showProductOnModalBottomSheet(BuildContext context, Product product) async {
    showModalBottomSheet<Product>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 1000,
          // color: Colors.amber,
          // child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    product.image != null ? Image.network(
                      product.image!,
                      height: 100,
                      errorBuilder: (context, exception, stackTrace) {
                        return Image.network(
                          'https://static-00.iconduck.com/assets.00/no-image-icon-512x512-lfoanl0w.png',
                          height: 100,
                        );
                      },
                    ) : Image.network(
                      'https://static-00.iconduck.com/assets.00/no-image-icon-512x512-lfoanl0w.png',
                      height: 100,
                    ),
                    Text(product.label!),
                  ]
              ),
              Text('Calories: ${product.nutrients?.kcal}'),
              Text('Fat: ${product.nutrients?.fat}'),
              Text('Carbs: ${product.nutrients?.carbs}'),
              Text('Protein: ${product.nutrients?.protein}'),
              Text('Fiber: ${product.nutrients?.fiber}'),
              ElevatedButton(
                child: const Text('Add this product to your meal'),
                onPressed: () => Navigator.pop(context, product),
              ),
            ],
          ),
          // ),
        );
      },
    ).then((value) => {
      if(value != null) {
        Navigator.pop(context, jsonEncode(product.toJson()))
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
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
                    child: TextField(
                      controller: productTextFieldController,
                      decoration:  InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Search for a product...',
                        suffixIcon: InkWell(
                        onTap: searchForProduct,
                        child: const Icon(Icons.search),
                      )
                      ),
                    ),
                  ),
                  // const SizedBox(width: 20),

                ]
            ),
            products.isNotEmpty?Expanded(
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Card(
                      key: ValueKey(products[index].foodId),
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: products[index].image != null ? Image.network(
                            products[index].image!,
                            height: 50,
                          errorBuilder: (context, exception, stackTrace) {
                            return Image.network(
                                'https://static-00.iconduck.com/assets.00/no-image-icon-512x512-lfoanl0w.png',
                                height: 50,
                            );
                          },
                        ) : Image.network(
                          'https://static-00.iconduck.com/assets.00/no-image-icon-512x512-lfoanl0w.png',
                          height: 50,
                        ),
                        title: Text(products[index].label!),
                        subtitle: Text('${products[index].nutrients?.kcal} kcal'),
                        onTap: () => showProductOnModalBottomSheet(context, products[index]),
                      ),
                    );
                  },
              ),
            ) : const SizedBox(height:0.0),
          ],
        ),
      ),
      floatingActionButton: _scanProductButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}