import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/edit_product.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../widgets/user_product_item.dart';

class UserProducts extends StatelessWidget {

  static const routeName = '/user-orders';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (ctx, i) => UserProductItem(
            title: productsData.items[i].title,
            imageUrl: productsData.items[i].imageUrl,
          ),
        ),
      ),
    );
  }
}
