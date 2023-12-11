import 'package:fit_me/models/shoppingItem.dart';
import 'package:fit_me/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_cart/shopping_cart.dart';
import 'package:badges/badges.dart' as badges;

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final cart = ShoppingCart.getInstance<shoppingItemModel>();
  late int cartItemCount;

  @override
  void initState() {
    super.initState();
    cartItemCount = cart.itemCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fit Me'),
        actions: [
          badges.Badge(
            badgeContent: Text(cartItemCount.toString()),
            position: badges.BadgePosition.topStart(),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );

                setState(() {
                  cartItemCount = cart.itemCount;
                });
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('ShoppingItems').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          var shoppingItemsData = snapshot.data!.docs;
          return ListView.builder(
            itemCount: shoppingItemsData.length,
            itemBuilder: (context, index) {
              var itemId = shoppingItemsData[index].id;
              var name = shoppingItemsData[index]['name'];
              var extraInfo = shoppingItemsData[index]['extraInfo'];
              var price = (shoppingItemsData[index]['price']);
              var imagePath = shoppingItemsData[index]['path'];

              return Card(
                child: ListTile(
                  leading: Image.network(imagePath),
                  title: Text(name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(extraInfo),
                      Text('$price \$ '),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      shoppingItemModel item = shoppingItemModel(
                        id: int.parse(itemId),
                        name: name,
                        extraInfo: extraInfo,
                        price: double.parse(price),
                        urlPhoto: imagePath,
                      );
                      cart.addItemToCart(item);
                      setState(() {
                        cartItemCount = cart.itemCount;
                      });
                    },
                    child: const Text('Add to Cart'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
