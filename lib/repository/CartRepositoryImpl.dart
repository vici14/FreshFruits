import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/repository/CartRepository.dart';
import 'package:fresh_fruit/service/service_manager.dart';

import '../model/ordered_product_model.dart';

class CartRepositoryImplement extends CartRepository {
  ServiceManager serviceManager = ServiceManager.instance();

  @override
  Future<void> addToCart(
      {required ProductModel productModel,
      required int quantity,
      required String uid}) async {
    return await serviceManager.addToCart(
        productModel: productModel, uid: uid, quantity: quantity);
  }

  @override
  Future<bool> deleteProductFromCart(
      {required OrderedProductModel productModel, required String uid}) async {
    return await serviceManager.deleteFromCart(
        productModel: productModel, uid: uid);
  }


  @override
  Future<bool> checkOutCart({
    required CartModel cartModel,
    required String uid,
  }) async {
    return await serviceManager.checkOutCart(
      cartModel: cartModel,
      uid: uid,
    );
  }

  @override
  Future<CartModel?> getCart(String uid) async {
    return await serviceManager.getCart(uid);
  }

  @override
  Stream<QuerySnapshot<OrderedProductModel>> getCartItemsStream(
      String uid) async* {
    yield* serviceManager.getStreamOrderedItemsInCart(uid);
  }

  @override
  Future<void> updateQuantity(
      {required OrderedProductModel productModel, required String uid}) async {
    serviceManager.updateQuantity(product: productModel, uid: uid);
  }
}
