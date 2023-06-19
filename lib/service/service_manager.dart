import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/model/user_model.dart';

class ServiceManager {
  static final ServiceManager _instance = ServiceManager._internal();

  static final fireStore = FirebaseFirestore.instance;
  final CollectionReference productsCollection =
      fireStore.collection('products');
  static final CollectionReference usersCollection =
      fireStore.collection('users');
  final userRef = usersCollection.withConverter<UserModel>(
    fromFirestore: (snapshot, _) =>
        UserModel.fromQuerySnapshot(snapshot.data()!),
    toFirestore: (user, _) => user.toJson(),
  );

  factory ServiceManager() {
    return _instance;
  }

  Future<DocumentReference<CartModel>> getUserCurrentCart(String uid) async {
    try {
      var _user = await usersCollection.where('uid', isEqualTo: uid).get();
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

  Future<DocumentReference<UserModel>> getCurrentUserDocument(
      String uid) async {
    try {
      var _user = await usersCollection
          .where('uid', isEqualTo: uid)
          .withConverter(
            fromFirestore: (snapshot, _) =>
                UserModel.fromQuerySnapshot(snapshot.data()!),
            toFirestore: (UserModel user, _) => user.toJson(),
          )
          .get();
      AppLogger.i('getCurrentUserDocument ${uid} success');

      return _user.docs.first.reference;
    } catch (e) {
      AppLogger.e(e.toString());
      rethrow;
    }
  }

  Future<DocumentReference<ProductModel>> getCurrentProductDocument(
      String id) async {
    try {
      var _product = await productsCollection
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

  ServiceManager._internal() {
    //Singleton
    //create Firebase
    init();
  }

  void init() async {
    //create DB or sthg
  }

//====================PRODUCTS=======================
  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> list = [];
    var _products = await productsCollection.get();
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
    var _products = await productsCollection
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

        return _currentUser.get().then((value) => value.data());
      }
      return null;
    } catch (e) {
      AppLogger.e(e.toString());
    }
  }

  Future<bool> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var isCreated = createUser(uid: userCredential.user!.uid, email: email);
      if (isCreated) {
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

  bool createUser({required String uid, required String email}) {
    userRef.add(UserModel.initial(uid: uid, email: email));
    return true;
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
    _currentUser.update({
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
    _currentUser.update({
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
          .update({'name': name, 'phone': phone, 'address': address}).onError(
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
      await _currentUser.collection('cart').add(cartModel.toJson());
      AppLogger.i('createCollectionCart success');
    } catch (e) {
      AppLogger.e(e.toString());
    }
  }

  void updateHistory(
      {required CartModel cartModel, required String uid}) async {
    var _currentUser = await getCurrentUserDocument(uid);
    _currentUser
        .update({
          'orderHistory': FieldValue.arrayUnion([cartModel.toJson()])
        })
        .then((value) => AppLogger.i('updateHistory success'))
        .catchError((onError) => AppLogger.e(onError.toString()));
  }

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
    try{
      var _cart = await getUserCurrentCart(uid);
      var productInCart =
      await getProductExistedInCart(cart: _cart, productId: product.id);
      if (productInCart.docs.isNotEmpty) {
        ///if product existed,update quantity
        var _prod = await productInCart.docs.first.reference.get();
        productInCart.docs.first.reference
            .update({"quantity": (product.quantity)});

        AppLogger.i('updateQuantity success');

      }
    }catch(e){
      AppLogger.e(e.toString());
    }

  }

  void addToCart(
      {required ProductModel productModel,
      required int quantity,
      required String uid}) async {
    try{
      var orderItem = OrderedProductModel.fromProductModel(
          product: productModel, quantity: quantity);
      var _cart = await getUserCurrentCart(uid);
      var productInCart =
      await getProductExistedInCart(cart: _cart, productId: productModel.id!);
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

    }catch(e){
      AppLogger.e(e.toString());

    }

  }

  Future<CartModel?> getCart(String uid) async {
    var _cart = await getUserCurrentCart(uid)
        .then((value) => value.get().then((vak) => vak.data()));
    return _cart;
  }

  Future<bool> checkOutCart({
    required CartModel cartModel,
    required String uid,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
  }) async {
    try {
      var _cart = await getUserCurrentCart(uid);
      _cart
          .collection('orderedItems')
          .get()
          .then((value) => value.docs.forEach((element) {
                element.reference.delete();
              }));
      // await _cart
      //     .update(CartModel.initial().toJson())
      //     .onError((error, stackTrace) => false);
      await addToHistory(
              uid: uid,
              cartModel: cartModel,
              customerAddress: customerAddress,
              customerPhone: customerPhone,
              customerName: customerName)
          .onError((error, stackTrace) => false);
      AppLogger.i('checkOutCart success');

      return true;
    } catch (e) {
      AppLogger.e(e.toString());

    }
    return false;
  }

  Future<void> addToHistory({
    required CartModel cartModel,
    required String uid,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
  }) async {
    try{
      var _currentUser = await getCurrentUserDocument(uid);
      _currentUser.update({
        'orderHistory': FieldValue.arrayUnion([
          cartModel
              .withShippingInformation(
              customerName: customerName,
              customerPhone: customerPhone,
              customerAddress: customerAddress)
              .toJson()
        ])
      });
      AppLogger.i('addToHistory success');

    }catch(e){
      AppLogger.e(e.toString());

    }

  }
}
