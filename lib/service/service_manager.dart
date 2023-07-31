import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresh_fruit/AppViewModel.dart';
import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:fresh_fruit/model/BannerModel.dart';
import 'package:fresh_fruit/model/OrderModel.dart';
import 'package:fresh_fruit/model/PaymentMethodModel.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/model/user_model.dart';
import 'package:fresh_fruit/service/GoogleMapService.dart';
import 'package:fresh_fruit/service/storage_service.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';

class ServiceManager {
  ServiceManager._internal();

  static late final ServiceManager _instance = ServiceManager._internal();

  static ServiceManager instance() => _instance;

  //Firebase
  static final fireStore = FirebaseFirestore.instance;
  final CollectionReference productCollection =
      fireStore.collection('products');
  final CollectionReference orderCollection = fireStore.collection('orders');
  final CollectionReference bannerCollection = fireStore.collection('banners');
  final CollectionReference paymentMethodCollection =
      fireStore.collection('paymentMethods');
  static final CollectionReference userCollection =
      fireStore.collection('users');
  final userRef = userCollection.withConverter<UserModel>(
    fromFirestore: (snapshot, _) =>
        UserModel.fromQuerySnapshot(snapshot.data()!),
    toFirestore: (user, _) => user.toJson(),
  );

  static Future<void> init(AppFlavor appFlavor) async {
    GoogleMapService.init(appFlavor);
  }

  Future<void> delay({Duration? time}) async {
    await Future.delayed(time ?? Duration(milliseconds: 500));
  }

  //==================GOOGLE MAP==================//
  Future<dynamic> calculateDistance(
      {required List<String> origins,
      required List<String> destinations}) async {
    return await GoogleMapService.instance()
        .calculateDistance(origins: origins, destinations: destinations);
  }

  Future<GoogleGeocodingResponse> searchAddress(String address) async {
    return await GoogleMapService.instance().searchAddress(address);
  }

  Future<dynamic> getCurrentLocation(
      {required double latitude, required double longitude}) async {
    return await GoogleMapService.instance()
        .getCurrentLocation(latitude: latitude, longitude: longitude);
  }

//==================GOOGLE MAP==================//

// ==================RESOURCE==================//

  Future<List<BannerModel>> getBanners() async {
    var listBanner = await bannerCollection
        .withConverter<BannerModel>(
            fromFirestore: (snapshot, _) =>
                BannerModel.fromQuerySnapshot(snapshot.data()!),
            toFirestore: (banner, _) => banner.toJson())
        .get();
    return listBanner.docs.map((e) => e.data()).toList();
  }

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    var listPaymentMethods = await paymentMethodCollection
        .withConverter<PaymentMethodModel>(
            fromFirestore: (snapshot, _) =>
                PaymentMethodModel.fromQuerySnapshot(snapshot.data()!),
            toFirestore: (banner, _) => banner.toJson())
        .get();
    return listPaymentMethods.docs.map((e) => e.data()).toList();
  }

  // ==================RESOURCE==================//

  Future<DocumentReference<CartModel>> getUserCurrentCart(String uid) async {
    try {
      var _user = await userCollection.where('uid', isEqualTo: uid).get();
      var _cart = await _user.docs.first.reference
          .collection('cart')
          .withConverter<CartModel>(
              fromFirestore: (snapshot, _) =>
                  CartModel.fromQuerySnapshot(snapshot.data()!),
              toFirestore: (cart, _) => cart.toJson())
          .get();
      AppLogger.i('getUserCurrentCart ${uid} success');

      return _cart.docs.first.reference;
    } catch (e) {
      AppLogger.e(e.toString());
      rethrow;
    }
  }

  Future<QuerySnapshot<OrderedProductModel>> getProductExistedInCart(
      {required DocumentReference<CartModel> cart,
      required String productId}) async {
    try {
      var productInCart = await cart
          .collection('orderedItems')
          .where("id", isEqualTo: productId)
          .withConverter<OrderedProductModel>(
              fromFirestore: (data, _) =>
                  OrderedProductModel.fromQuerySnapshot(data.data()!),
              toFirestore: (orderedProduct, _) => orderedProduct.toJson())
          .get();

      AppLogger.i('getProductExistedInCart ${productId} success');
      return productInCart;
    } catch (e) {
      AppLogger.e(e.toString());
      rethrow;
    }
  }

  Future<DocumentReference<UserModel>?> getCurrentUserDocument(
      String uid) async {
    try {
      var _user = await userCollection
          .where('uid', isEqualTo: uid)
          .withConverter(
            fromFirestore: (snapshot, _) =>
                UserModel.fromQuerySnapshot(snapshot.data()!),
            toFirestore: (UserModel user, _) => user.toJson(),
          )
          .get();
      AppLogger.i('getCurrentUserDocument ${uid} success');

      return (_user.docs.isEmpty) ? null : _user.docs.first.reference;
    } catch (e) {
      AppLogger.e(e.toString());
      rethrow;
    }
  }

  Future<DocumentReference<ProductModel>> getCurrentProductDocument(
      String id) async {
    try {
      var _product = await productCollection
          .where('id', isEqualTo: id)
          .withConverter(
            fromFirestore: (snapshot, _) =>
                ProductModel.fromQuerySnapshot(snapshot.data()!),
            toFirestore: (ProductModel prduct, _) => prduct.toJson(),
          )
          .get();
      AppLogger.i('getCurrentProductDocument ${id} success');

      return _product.docs.first.reference;
    } catch (e) {
      AppLogger.e(e.toString());
      rethrow;
    }
  }

//====================PRODUCTS=======================
  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> list = [];
    var _products = await productCollection.get();
    try {
      _products.docs.forEach((element) {
        var product = ProductModel.fromQuerySnapshot(
            element.data() as Map<String, dynamic>);
        list.add(product);
      });
      AppLogger.i('getProducts ${list.length} success');
      return list;
    } catch (e) {
      AppLogger.e(e.toString());
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    List<ProductModel> list = [];
    var _products = await productCollection
        .where('category', isEqualTo: category)
        .withConverter<ProductModel>(
            fromFirestore: (snapshot, _) =>
                ProductModel.fromQuerySnapshot(snapshot.data()!),
            toFirestore: (product, _) => product.toJson())
        .get();
    try {
      list = List.generate(
              _products.docs.length, (index) => _products.docs[index].data())
          .toList();
      AppLogger.i('getProductsByCategory ${category} success');

      return list;
    } catch (e) {
      AppLogger.e(e.toString());
    }
    return [];
  }

//====================USER=======================

  Future<UserModel?> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      AppLogger.i('logOut success');
    } catch (e) {
      AppLogger.e(e.toString());
    }
    return null;
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        var _currentUser = await getCurrentUserDocument(currentUser.uid);
        AppLogger.i('getCurrentUser ${currentUser.uid} success');

        return _currentUser?.get().then((value) => value.data());
      }
      return null;
    } catch (e) {
      AppLogger.e(e.toString());
    }
  }

  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var isCreated = await createUser(
        uid: userCredential.user!.uid,
        phone: email,
        name: name,
      );
      if (isCreated != null) {
        createCollectionCart(userCredential.user!.uid);
      }
      AppLogger.i(
          'signUpWithEmailAndPassword ${userCredential.user?.uid} success');

      return true;
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e.toString());

      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {}
    } catch (e) {}
    return false;
  }

  Future<UserModel?> signInWithPhoneCredential(
      {required String verificationId,
      required String smsCode,
      String? name}) async {
    try {
      UserCredential auth = await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode));
      var _resp = await createUser(
          uid: auth.user!.uid,
          phone: auth.user?.phoneNumber ?? "",
          name: name ?? auth.user?.phoneNumber ?? "");
      createCollectionCart(auth.user!.uid);
      return _resp;
    } catch (e) {
      AppLogger.e(e.toString(),
          extraMessage: 'sign in phone credential failed');
      return null;
    }
  }

  Future<UserModel?> createUser({
    required String uid,
    required String phone,
    required String name,
  }) async {
    try {
      var _existUser = await getCurrentUserDocument(uid);
      if (_existUser == null) {
        var _user = await userRef
            .add(UserModel.initial(uid: uid, phone: phone, name: name))
            .then((value) => value.get().then((v) => v.data()));
        // createCollectionCart(uid);
        return _user;
      }
      return _existUser.get().then((value) => value.data());
    } catch (e) {
      AppLogger.e(e.toString(), extraMessage: 'create User failed');
      return null;
    }
  }

  Future<bool> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      AppLogger.i(
          'signUpWithEmailAndPassword ${userCredential.additionalUserInfo} success');
      return true;
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e.toString());

      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {}
    }
    return false;
  }

  void likeProduct(
      {required String uid, required ProductModel productModel}) async {
    var _currentUser = await getCurrentUserDocument(uid);
    _currentUser?.update({
      'favoriteProducts': FieldValue.arrayUnion([productModel.toJson()])
    });
    //     .then((value) {
    //   updateProductLiked(
    //       productId: productModel.id ?? '', status: productModel.isLiked);
    //   print('add to favorite success');
    // }).catchError((onError) => print('failed add to favorite'));
  }

  void updateProductLiked(
      {required String productId, required bool status}) async {
    var _currentProduct = await getCurrentProductDocument(productId);
    _currentProduct.update({'isLiked': status}).then((value) {
      AppLogger.i('updateProductLiked success');
    }).catchError((onError) {
      AppLogger.e(onError.toString());
    });
  }

  void unlikeProduct(
      {required String uid, required ProductModel productModel}) async {
    var _currentUser = await getCurrentUserDocument(uid);
    _currentUser?.update({
      'favoriteProducts': FieldValue.arrayRemove([productModel.toJson()])
    });
    // .then((value) {
    //   updateProductLiked(
    //       productId: productModel.id ?? '', status: productModel.isLiked);
    //   print('remove from favorite success');
    // }).catchError((onError) => print('failed remove'));
  }

  Future<bool> updateProfile(
      {required String name,
      required String phone,
      required String address,
      required String uid}) async {
    try {
      var _currentUser = await getCurrentUserDocument(uid);
      _currentUser
          ?.update({'name': name, 'phone': phone, 'address': address}).onError(
              (error, stackTrace) => false);
      AppLogger.i('updateProfile success');

      return true;
    } catch (e) {
      AppLogger.e(e.toString());
    }
    return false;
  }

  void createCollectionCart(String uid) async {
    try {
      CartModel cartModel = CartModel.initial();
      var _currentUser = await getCurrentUserDocument(uid);
      var _cart = await _currentUser?.collection('cart').get();
      AppLogger.i('cart:${_cart}');
      if (_cart != null && _cart.size < 1) {
        await _currentUser?.collection('cart').add(cartModel.toJson());
      }

      AppLogger.i('createCollectionCart success');
    } catch (e) {
      AppLogger.e(e.toString(), extraMessage: 'createCollectionCart failed ');
    }
  }

  void createCollectionOrderHistory(String uid) async {
    try {
      CartModel cartModel = CartModel.initial();
      var _currentUser = await getCurrentUserDocument(uid);
      var _cart = await _currentUser?.collection('orderHistory').get();
      AppLogger.i('cart:${_cart}');
      if (_cart != null && _cart.size < 1) {
        await _currentUser?.collection('cart').add(cartModel.toJson());
      }

      AppLogger.i('createCollectionCart success');
    } catch (e) {
      AppLogger.e(e.toString(), extraMessage: 'createCollectionCart failed ');
    }
  }

  void updateHistory(
      {required CartModel cartModel, required String uid}) async {
    var _currentUser = await getCurrentUserDocument(uid);
    _currentUser
        ?.update({
          'orderHistory': FieldValue.arrayUnion([cartModel.toJson()])
        })
        .then((value) => AppLogger.i('updateHistory success'))
        .catchError((onError) => AppLogger.e(onError.toString()));
  }

  Future<bool> addShippingAddress(
      {required AddressModel address, required String uid}) async {
    try {
      await delay();

      var _currentUser = await getCurrentUserDocument(uid);
      _currentUser
          ?.update({
            'addresses': FieldValue.arrayUnion([address.toJson()])
          })
          .then((value) => AppLogger.i('add shipping Address success'))
          .catchError((onError) => AppLogger.e(onError.toString()));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateCurrentShippingAddress(
      {required AddressModel address, required String uid}) async {
    try {
      await delay();
      var _currentUser = await getCurrentUserDocument(uid);
      _currentUser
          ?.update({'currentAddress': address.toJson()})
          .then((value) => AppLogger.i('updateCurrentShippingAddress success'))
          .catchError((onError) => AppLogger.e(onError.toString()));
      return true;
    } catch (e) {
      rethrow;
    }
  }

// Future<List<AddressModel>> getAddresses(
//     {required AddressModel address, required String uid}) async {
//   try {
//     var _currentUser = await getCurrentUserDocument(uid);
//     _currentUser
//         .update({
//       'addresses': FieldValue.arrayUnion([address.toJson()])
//     })
//         .then((value) => AppLogger.i('add shipping Address success'))
//         .catchError((onError) => AppLogger.e(onError.toString()));
//     return [];
//   } catch (e) {
//     rethrow;
//   }
// }
//====================CART=======================

  Stream<QuerySnapshot<OrderedProductModel>> getStreamOrderedItemsInCart(
      String uid) async* {
    ///example for stream
    var _cart = await getUserCurrentCart(uid);
    var a = _cart.collection('orderedItems').withConverter<OrderedProductModel>(
        fromFirestore: (data, _) =>
            OrderedProductModel.fromQuerySnapshot(data.data()!),
        toFirestore: (orderedProduct, _) => orderedProduct.toJson());

    yield* a.snapshots();
  }

  void updateQuantity(
      {required OrderedProductModel product, required String uid}) async {
    try {
      var _cart = await getUserCurrentCart(uid);
      var productInCart =
          await getProductExistedInCart(cart: _cart, productId: product.id);
      if (productInCart.docs.isNotEmpty) {
        ///if product existed,update quantity
        var _prod = productInCart.docs
            .where((element) => product.id == element.data().id)
            .first;
        _prod.reference.update({"quantity": (product.quantity)});

        AppLogger.i('updateQuantity success');
      }
    } catch (e) {
      AppLogger.e(e.toString());
    }
  }

  Future<void> addToCart(
      {required ProductModel productModel,
      required int quantity,
      required String uid}) async {
    try {
      var orderItem = OrderedProductModel.fromProductModel(
          product: productModel, quantity: quantity);
      var _cart = await getUserCurrentCart(uid);
      var productInCart = await getProductExistedInCart(
          cart: _cart, productId: productModel.id ?? "");
      if (productInCart.docs.isNotEmpty) {
        ///if product existed,update quantity
        var _prod = await productInCart.docs.first.reference.get();
        productInCart.docs.first.reference
            .update({"quantity": (_prod.data()!.quantity + quantity)});
      } else {
        ///if product non existed,add to collection
        var _a = await _cart.collection('orderedItems').add(orderItem.toJson());
      }
      AppLogger.i('addToCart success');
    } catch (e) {
      AppLogger.e(e.toString());
    }
  }

  Future<bool> deleteFromCart(
      {required OrderedProductModel productModel, required String uid}) async {
    try {
      var _cart = await getUserCurrentCart(uid);
      var productInCart = await getProductExistedInCart(
          cart: _cart, productId: productModel.id ?? "");
      if (productInCart.docs.isNotEmpty) {
        await productInCart.docs.first.reference.delete();
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.e(e.toString(), extraMessage: 'delete From Cart');
      return false;
    }
  }

  Future<CartModel?> getCart(String uid) async {
    AppLogger.i('getCart $uid');

    var _cart = await getUserCurrentCart(uid)
        .then((value) => value.get().then((vak) => vak.data()));
    return _cart;
  }

  Future<bool> checkOutCart({
    required CartModel cartModel,
    required String uid,
  }) async {
    try {
      var orderAdded = await addToHistory(
        uid: uid,
        cartModel: cartModel,
      );
      if (orderAdded != null) {
        orderAdded = orderAdded.copyWith(
          shippingDetail: cartModel.shippingDetail,
        );
        await addOrderToCollection(orderAdded);
        AppLogger.i('checkOutCart success');
        var _cart = await getUserCurrentCart(uid);
        _cart
            .collection('orderedItems')
            .get()
            .then((value) => value.docs.forEach((element) {
                  element.reference.delete();
                }));

        return true;
      }
      return false;
    } catch (e) {
      AppLogger.e(e.toString());
    }
    return false;
  }

  //////// ORDER ////////
  Future<OrderModel?> addToHistory({
    required CartModel cartModel,
    required String uid,
  }) async {
    try {
      if (cartModel.canCheckOut) {
        var user = await userCollection.where('uid', isEqualTo: uid).get();
        var order = OrderModel.fromCart(cartModel);
        var orderHistoryCollection = user.docs.first.reference
            .collection('orderHistory')
            .withConverter<OrderModel>(
                fromFirestore: (snapshot, _) =>
                    OrderModel.fromQuerySnapshot(snapshot.data()!),
                toFirestore: (order, _) => order.toJson());
        var orderAdded = await orderHistoryCollection.add(order);
        await orderAdded.update({"id": orderAdded.id, "user": uid});
        return await orderAdded.get().then((value) => value.data());
      } else {
        AppLogger.i('cannot addToHistory');
        return null;
      }
    } catch (e) {
      AppLogger.e(e.toString());
      return null;
    }
  }

  Future<List<OrderModel>> getListOrder(String uid) async {
    try {
      var _user = await userCollection.where('uid', isEqualTo: uid).get();
      var _order = await _user.docs.first.reference
          .collection('orderHistory')
          .withConverter<OrderModel>(
              fromFirestore: (snapshot, _) =>
                  OrderModel.fromQuerySnapshot(snapshot.data()!),
              toFirestore: (cart, _) => cart.toJson())
          .get();
      AppLogger.i('getUserCurrentCart ${uid} success');

      return _order.docs.map((e) => e.data()).toList();
    } catch (e) {
      AppLogger.e(e.toString());
      rethrow;
    }
  }

  Future<bool> addOrderToCollection(OrderModel order) async {
    try {
      await orderCollection.add(order.toJson());
      return true;
    } catch (e) {
      AppLogger.e(e.toString(), extraMessage: "addOrderToCollection");
      return false;
    }
  }
}
