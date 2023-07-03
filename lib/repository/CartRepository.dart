import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';
import 'package:fresh_fruit/model/product_model.dart';

abstract class CartRepository {
  Future<CartModel?> getCart(String uid);

  Future<void> addToCart({
    required ProductModel productModel,
    required int quantity,
    required String uid,
  });

  Future<void> updateQuantity({
    required OrderedProductModel productModel,
    required String uid,
  });

  Future<bool> deleteProductFromCart(
      {required OrderedProductModel productModel, required String uid});

  Future<bool> checkOutCart({
    required CartModel cartModel,
    required String uid,
  });

  Stream<QuerySnapshot<OrderedProductModel>> getCartItemsStream(String uid);
}
