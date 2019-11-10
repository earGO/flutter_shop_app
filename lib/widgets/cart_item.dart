import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart' show Cart;

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    this.title,
    this.quantity,
    this.price,
    this.id,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).primaryTextTheme.title.color,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_){
        Provider.of<Cart>(context,listen: false,).removeFromCart(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    '\$$price',
                    style: TextStyle(),
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('x $quantity'),
          ),
        ),
      ),
    );
  }
}
