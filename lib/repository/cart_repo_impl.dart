import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/repository/cart_repository.dart';
import 'package:fresh_fruit/service/service_manager.dart';

import '../model/ordered_product_model.dart';

class CartRepositoryImplement extends CartRepository {
  ServiceManager serviceManager = ServiceManager();

  @override
  Future<void> addToCart(
      {required ProductModel productModel,
      required int quantity,
      required String uid}) async {
    return serviceManager.addToCart(
        productModel: productModel, uid: uid, quantity: quantity);
  }

  @override
  Future<void> deleteProductFromCart({required String productId}) {
    // TODO: implement deleteProductFromCart
    throw UnimplementedError();
  }

  @override
  Future<void> removeFromCart(
      {required String productId, required int quantity}) {
    // TODO: implement removeFromCart
    throw UnimplementedError();
  }

  @override
  Future<bool> checkOutCart({
    required CartModel cartModel,
    required String uid,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
  }) async {
    return await serviceManager.checkOutCart(
        cartModel: cartModel,
        uid: uid,
        customerAddress: customerAddress,
        customerPhone: customerPhone,
        customerName: customerName);
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
}
