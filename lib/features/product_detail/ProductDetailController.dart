import 'package:flutter/foundation.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';
import 'package:fresh_fruit/model/product_model.dart';

class ProductDetailController extends ChangeNotifier{
  final ProductModel productModel;


  ProductDetailController(this.productModel);
  int _quantity =1;

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
    notifyListeners();
  }
}