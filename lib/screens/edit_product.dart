import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../provider/products_provider.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocuNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formGlobalKey = GlobalKey<FormState>();
  var _isInit = true;
  var _newUserProduct = Product(
    id: null,
    title: '',
    imageUrl: '',
    price: 0.0,
    description: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _newUserProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findProductById(productId);
        _initValues = {
          'title': _newUserProduct.title,
          'description': _newUserProduct.description,
          'price': _newUserProduct.price.toString(),
          'imageUrl': '',
          'id': _newUserProduct.id,
          'isFavorite': _newUserProduct.isFavorite,
        };
        _imageUrlController.text = _newUserProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocuNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    if (_formGlobalKey.currentState.validate()) {
      _formGlobalKey.currentState.save();
      if (_newUserProduct.id != null) {
        Provider.of<ProductsProvider>(context).editProduct(_newUserProduct);
      } else {
        Provider.of<ProductsProvider>(context).addProduct(_newUserProduct);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formGlobalKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a product title.';
                  }
                  return null;
                },
                onSaved: (value) => {
                  _newUserProduct = Product(
                    title: value,
                    price: _newUserProduct.price,
                    description: _newUserProduct.description,
                    id: _newUserProduct.id,
                    imageUrl: _newUserProduct.imageUrl,
                    isFavorite: _newUserProduct.isFavorite,
                  )
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocuNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: (value) => {
                  _newUserProduct = Product(
                    title: _newUserProduct.title,
                    price: double.parse(value),
                    description: _newUserProduct.description,
                    id: _newUserProduct.id,
                    imageUrl: _newUserProduct.imageUrl,
                    isFavorite: _newUserProduct.isFavorite,
                  )
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocuNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a product description.';
                  }
                  if (value.length < 10) {
                    return 'Please provide more detailed description.';
                  }
                  return null;
                },
                onSaved: (value) => {
                  _newUserProduct = Product(
                    title: _newUserProduct.title,
                    price: _newUserProduct.price,
                    description: value,
                    id: _newUserProduct.id,
                    imageUrl: _newUserProduct.imageUrl,
                    isFavorite: _newUserProduct.isFavorite,
                  )
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Container(
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter Image URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                        Navigator.of(context).pop();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a product image URL.';
                        }
                        if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Please provide a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please provide a valid URL.';
                        }
                        return null;
                      },
                      onSaved: (value) => {
                        _newUserProduct = Product(
                          title: _newUserProduct.title,
                          price: _newUserProduct.price,
                          description: _newUserProduct.description,
                          id: _newUserProduct.id,
                          imageUrl: value,
                          isFavorite: _newUserProduct.isFavorite,
                        )
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
