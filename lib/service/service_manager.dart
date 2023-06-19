import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    var _user = await usersCollection.where('uid', isEqualTo: uid).get();
    var _cart = await _user.docs.first.reference
        .collection('cart')
        .withConverter<CartModel>(
            fromFirestore: (snapshot, _) =>
                CartModel.fromQuerySnapshot(snapshot.data()!),
            toFirestore: (cart, _) => cart.toJson())
        .get();
    return _cart.docs.first.reference;
  }

  Future<QuerySnapshot<OrderedProductModel>> getProductExistedInCart(
      {required DocumentReference<CartModel> cart,
      required String productId}) async {
    var productInCart = await cart
        .collection('orderedItems')
        .where("id", isEqualTo: productId)
        .withConverter<OrderedProductModel>(
            fromFirestore: (data, _) =>
                OrderedProductModel.fromQuerySnapshot(data.data()!),
            toFirestore: (orderedProduct, _) => orderedProduct.toJson())
        .get();
    return productInCart;
  }

  Future<DocumentReference<UserModel>> getCurrentUserDocument(
      String uid) async {
    var _user = await usersCollection
        .where('uid', isEqualTo: uid)
        .withConverter(
          fromFirestore: (snapshot, _) =>
              UserModel.fromQuerySnapshot(snapshot.data()!),
          toFirestore: (UserModel user, _) => user.toJson(),
        )
        .get();
    return _user.docs.first.reference;
  }

  Future<DocumentReference<ProductModel>> getCurrentProductDocument(
      String id) async {
    var _product = await productsCollection
        .where('id', isEqualTo: id)
        .withConverter(
          fromFirestore: (snapshot, _) =>
              ProductModel.fromQuerySnapshot(snapshot.data()!),
          toFirestore: (ProductModel prduct, _) => prduct.toJson(),
        )
        .get();
    return _product.docs.first.reference;
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
      print('product ne :${_products}');
      return list;
    } catch (e) {
      print(e);
    }
    return [];
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
      print('product by category ne  :${_products}');
      return list;
    } catch (e) {
      print('getProductsByCategory:${e.toString()}');
    }
    return [];
  }

//====================USER=======================

  Future<UserModel?> logOut() async {
    await FirebaseAuth.instance.signOut();
    return null;
  }

  Future<UserModel?> getCurrentUser() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var _currentUser = await getCurrentUserDocument(currentUser.uid);
      return _currentUser.get().then((value) => value.data());
    }
    return null;
  }

  Future<bool> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('signUpCredential${userCredential.credential?.token}');
      var isCreated = createUser(uid: userCredential.user!.uid, email: email);
      if (isCreated) {
        createCollectionCart(userCredential.user!.uid);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
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
      print('signInCredential${userCredential.additionalUserInfo}');
      if (userCredential != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
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
    _currentProduct
        .update({'isLiked': status})
        .then((value) => 'Update '
            'product  collection success')
        .catchError((onError) => print('failed '
            'to update collection'));
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
      return true;
    } catch (e) {
      print('updateProfile:${e.toString()}');
    }
    return false;
  }

  void createCollectionCart(String uid) async {
    CartModel cartModel = CartModel.initial();
    var _currentUser = await getCurrentUserDocument(uid);
    await _currentUser.collection('cart').add(cartModel.toJson());
  }

  void updateHistory(
      {required CartModel cartModel, required String uid}) async {
    var _currentUser = await getCurrentUserDocument(uid);
    _currentUser
        .update({
          'orderHistory': FieldValue.arrayUnion([cartModel.toJson()])
        })
        .then((value) => print('User Updated list'))
        .catchError((onError) => print('FAILED'));
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

  void addToCart(
      {required ProductModel productModel,
      required int quantity,
      required String uid}) async {
    var orderItem = OrderedProductModel.fromProductModel(
        product: productModel, quantity: quantity);
    var _cart = await getUserCurrentCart(uid);
    var productInCart =
        await getProductExistedInCart(cart: _cart, productId: productModel.id!);
    if (productInCart.docs.length > 0) {
      ///if product existed,update quantity
      var _prod = await productInCart.docs.first.reference.get();
      productInCart.docs.first.reference
          .update({"quantity": (_prod.data()!.quantity + quantity)});
    } else {
      ///if product non existed,add to collection
      var _a = await _cart.collection('orderedItems').add(orderItem.toJson());
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
      return true;
    } catch (e) {
      print('checkOutCart error :${e.toString()}');
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
  }
}
