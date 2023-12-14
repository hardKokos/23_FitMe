import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_me/models/nutrients.dart';
import 'package:fit_me/models/product.dart';

final CollectionReference productsCollection =
    FirebaseFirestore.instance.collection('ProductsAdded');

Future<String> authUser() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  return auth.currentUser!.uid.toString();
}

Future<void> userSetup(String userName) async {
  final String uid = await authUser();
  await FirebaseFirestore.instance
      .collection('Users')
      .add({'userName': userName, 'uid': uid});
}

Future<void> addProduct(
  String? productName,
  double? productKcal,
  double? productFat,
  double? productCarbs,
  double? productProtein,
  double? productFiber,
  String? userId,
  bool? isSelected,
  String? mealType,
  String? foodId,
  String? image,
  double? productWeight,
) async {
  QuerySnapshot querySnapshot = await productsCollection
      .where('foodId', isEqualTo: foodId)
      .limit(1)
      .get();

  if (querySnapshot.docs.isEmpty) {
    await productsCollection.add({
      'productName': productName,
      'productKcal': productKcal,
      'productFat': productFat,
      'productCarbs': productCarbs,
      'productProtein': productProtein,
      'productFiber': productFiber,
      'userId': userId,
      'isSelected': isSelected,
      'mealType': mealType,
      'foodId': foodId,
      'image': image,
      'productWeight': productWeight,
    });
  } else {
    print('Product exists in database');
  }
}

Future<void> updateProduct(
  String? foodId,
  double? productKcal,
  double? productFat,
  double? productCarbs,
  double? productProtein,
  double? productFiber,
  double? productWeight,
  bool? isSelected,
) async {
  try {
    QuerySnapshot querySnapshot = await productsCollection
        .where('foodId', isEqualTo: foodId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var existingProduct = querySnapshot.docs.first;
      await existingProduct.reference.update({
        'isSelected': isSelected,
        'productKcal': productKcal,
        'productFat': productFat,
        'productCarbs': productCarbs,
        'productProtein': productProtein,
        'productFiber': productFiber,
        'productWeight': productWeight
      });
    }
  } catch (error) {
    print('Error updating product: $error');
  }
}

Future<List<Product>> searchForSelectedProducts() async {
  try {
    QuerySnapshot querySnapshot =
        await productsCollection.where('isSelected', isEqualTo: true).get();

    List<Product> selectedProducts = [];

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      Product product = Product(
        nutrients: Nutrients(
          kcal: data['productKcal'],
          carbs: data['productCarbs'],
          fat: data['productFat'],
          fiber: data['productFiber'],
          protein: data['productProtein'],
        ),
        image: data['image'],
        foodId: data['foodId'],
        isSelected: data['isSelected'],
        label: data['productName'],
      );

      selectedProducts.add(product);
    }

    return selectedProducts;
  } catch (error) {
    print('Błąd podczas wyszukiwania wybranych produktów: $error');

    return [];
  }
}

Future<void> deleteProduct(String? foodId, String? productName) async {
  try {
    QuerySnapshot querySnapshot = await productsCollection
        .where('foodId', isEqualTo: foodId)
        .where('productName', isEqualTo: productName)
        .limit(1)
        .get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      // Get the document reference and delete the document
      DocumentReference productReference = querySnapshot.docs.first.reference;
      await productReference.delete();

      // Print a success message or perform any additional actions
      print('Product deleted successfully');
    } else {
      // Print a message if no matching document was found
      print('Product not found');
    }
  } catch (error) {
    // Handle errors
    print('Error deleting product: $error');
  }
}
