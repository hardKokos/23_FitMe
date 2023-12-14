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
      body: Container(
        color: Colors.grey[850],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cart.cartItems[index];
                  var itemTotalPrice = item.price * item.quantity;
                  var itemQuantity = item.quantity;

                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        item.urlPhoto,
                        width: 100,
                        height: 100,),
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
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime.shade400,
                  ),
                onPressed: () {
                },
                child: const Text('Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
