import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_fruit/model/ShippingDetailModel.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/repository/CartRepositoryImpl.dart';
import 'package:fresh_fruit/repository/CartRepository.dart';
import 'package:fresh_fruit/view_model/BaseViewModel.dart';

import '../model/cart_model.dart';
import '../model/ordered_product_model.dart';
import '../model/product_model.dart';

class CartViewModel extends BaseViewModel {
  final CartRepository _repository = CartRepositoryImplement();

  static final CartViewModel _instance = CartViewModel._internal();

  CartViewModel._internal();

  factory CartViewModel() => _instance;

  static CartViewModel instance() => _instance;

//=======================FIELD VALUE=========================
  CartModel? currentCart;
  bool isGetCart = false;
  double _totalCost = 0;

  double? _shippingFee;

  double? get shippingFee => _shippingFee;

  set shippingFee(double? value) {
    _shippingFee = value;
    notifyListeners();
  }

  double get totalCost => _totalCost;

  set totalCost(double value) {
    _totalCost = value;
    notifyListeners();
  }

  bool isUpdatingProductQuantity = false;

  void addToCart(
      {required ProductModel productModel,
      required int quantity,
      required String uid}) {
    _repository.addToCart(
        quantity: quantity, uid: uid, productModel: productModel);
  }

  void getCart(String uid) async {
    isGetCart = true;
    notifyListeners();
    currentCart = await _repository.getCart(uid);
    isGetCart = false;
    notifyListeners();
  }

  void updateOrderedProducts(List<OrderedProductModel> items) {
    currentCart = currentCart?.copyWith(orderedItems: items);
  }

  Future<bool> checkOutCart({
    required String uid,
    required String note,
    required String customerName,
    required String customerPhone,
    required DateTime orderCheckoutTime,
    required double totalCost,
    required ShippingDetailModel shippingDetail,
    required AddressModel addressModel,
    required DateTime deliveryTime,
    required PaymentMethod paymentMethod,
  }) async {
    currentCart = currentCart?.copyWith(
      paymentMethod: paymentMethod,
      deliveryTime: deliveryTime,
      addressModel: addressModel,
      orderCheckoutTime: orderCheckoutTime,
      customerName: customerName,
      customerPhone: customerPhone,
      note: note,
      shippingDetail: shippingDetail,
      totalCost: totalCost,
    );
    if (currentCart?.canCheckOut == true) {
      bool isSuccess = await _repository.checkOutCart(
        cartModel: currentCart!,
        uid: uid,
      );

      if (isSuccess) {
        getCart(uid);
        return true;
      }
    }

    return false;
  }

  Stream<QuerySnapshot<OrderedProductModel>> getCartItemStream(
      String uid) async* {
    var stream = _repository.getCartItemsStream(uid);

    yield* stream;
  }

  Future<void> updateQuantity(
      {required OrderedProductModel productModel, required String uid}) async {
    isUpdatingProductQuantity = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));

    ///delay for prevent spamming
    _repository.updateQuantity(productModel: productModel, uid: uid);
    isUpdatingProductQuantity = false;
    notifyListeners();
  }

  void updateCartShippingDetail(ShippingDetailModel shippingDetailModel) {
    currentCart = currentCart?.copyWith(shippingDetail: shippingDetailModel);
  }
}
