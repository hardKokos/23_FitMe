import 'package:flutter/material.dart';
import 'package:fit_me/models/shoppingItem.dart';
import 'package:shopping_cart/shopping_cart.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cart = ShoppingCart.getInstance<shoppingItemModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your cart"),
      ),
      body: ListView.builder(
        itemCount: cart.cartItems.length,
        itemBuilder: (context, index) {
          final item = cart.cartItems[index];
          var itemTotalPrice = item.price * item.quantity;
          var itemQuantity = item.quantity;

          return Card(
            child: ListTile(
              leading: Image.network(item.urlPhoto),
              title: Text(item.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.extraInfo),
                  Text('Qt: $itemQuantity ' + 'Total: $itemTotalPrice \$ '),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.remove_shopping_cart),
                onPressed: () {
                  setState(() {
                    cart.decrementItemQuantity(item);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
