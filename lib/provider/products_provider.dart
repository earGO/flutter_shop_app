import 'package:flutter/material.dart';

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  /// We do it this way so that instead of a link to a certain
  /// memory cell with the _items, we just get an object with
  /// _items content - thus ensuring immutability
  List<Product> get items {
    return [..._items];
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: product.id,
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  void editProduct(Product product){
    final editedId = product.id;
    final editedProductIndex = _items.indexWhere((product)=>product.id==editedId);
    if(editedProductIndex!=null){
      _items[editedProductIndex] = product;
    } else {
      return;
    }
    notifyListeners();

  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findProductById(String productId) {
    return _items.firstWhere((prod) => prod.id == productId);
  }
}
