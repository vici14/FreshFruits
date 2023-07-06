import 'package:fresh_fruit/extension/IterableExtension.dart';
import 'package:fresh_fruit/mock_data.dart';

import '../model/product_model.dart';
import '../repository/ProductRepositoryImpl.dart';
import '../repository/ProductRepository.dart';
import 'BaseViewModel.dart';

class ProductViewModel extends BaseViewModel {
  ProductViewModel._internal();

  static final ProductViewModel _instance = ProductViewModel._internal();

  factory ProductViewModel() {
    return _instance;
  }

  static ProductViewModel instance() => _instance;

  final ProductRepository _repository = ProductRepositoryImplement();

  //=======================FIELD VALUE=========================
  bool isLoadingProduct = false;
  List<ProductModel> products = [];
  List<ProductModel>? productsAfterLoggedIn;

  bool isLoadingVegetable = false;
  List<ProductModel> vegetableProducts = [];
  List<ProductModel> vegetableProductsAfterLoggedIn = [];

  bool isLoadingMeat = false;
  List<ProductModel> meatProducts = [];
  List<ProductModel> meatProductsAfterLoggedIn = [];

  bool isLoadingHouseWare = false;
  List<ProductModel> houseWareProducts = [];
  List<ProductModel> houseWareProductsAfterLoggedIn = [];

  bool isLoadingProductMore = false;

  //=======================FIELD VALUE=========================

  List<ProductModel> get getNewestProduct {
    if (products.isEmpty) return [];
    return products
        .where((element) =>
            element.popular
                .firstWhereOrNull((p) => p == Popular.LIKED.toName()) !=
            null)
        .toList();
  }

  List<ProductModel> get getHottestProduct {
    if (products.isEmpty) return [];
    return products
        .where((element) =>
    element.popular
        .firstWhereOrNull((p) => p == Popular.HOT.toName()) !=
        null)
        .toList();
  }

  Future<bool> getProducts() async {
    try {
      isLoadingProduct = true;
      notifyListeners();
      products = await _repository.getProducts();
      isLoadingProduct = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> getMeatProducts() async {
    try {
      isLoadingMeat = true;
      notifyListeners();
      meatProducts = await _repository.getProductsByCategory('meat');
      isLoadingMeat = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> getVegetableProducts() async {
    try {
      isLoadingVegetable = true;
      notifyListeners();
      vegetableProducts = await _repository.getProductsByCategory('vegetable');
      isLoadingVegetable = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> getHouseWareProducts() async {
    try {
      isLoadingHouseWare = true;
      notifyListeners();
      houseWareProducts = await _repository.getProductsByCategory('house_ware');
      isLoadingHouseWare = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> updateCategoryProductsAfterUserLoggedIn(
      List<ProductModel> favoriteProducts) async {
    try {
      setBusy(true);
      meatProductsAfterLoggedIn =
          await _updateProductByCategoryAfterUserLoggedIn(
              category: "meat", favoriteProducts: favoriteProducts);
      vegetableProductsAfterLoggedIn =
          await _updateProductByCategoryAfterUserLoggedIn(
              category: "vegetable", favoriteProducts: favoriteProducts);
      houseWareProductsAfterLoggedIn =
          await _updateProductByCategoryAfterUserLoggedIn(
              category: "house_ware", favoriteProducts: favoriteProducts);
      setBusy(false);
      return true;
    } catch (e) {
      print("updateCategoryProductsAfterUserLoggedIn:${e.toString()}");
    }
    return false;
  }

  Future<List<ProductModel>> _updateProductByCategoryAfterUserLoggedIn(
      {required String category,
      required List<ProductModel> favoriteProducts}) async {
    List<ProductModel> products = [];
    List<ProductModel> result = [];
    switch (category) {
      case "meat":
        await getMeatProducts();
        products = meatProducts;
        break;
      case "vegetable":
        await getVegetableProducts();
        products = vegetableProducts;
        break;
      case "house_ware":
        await getHouseWareProducts();
        products = houseWareProducts;
        break;
    }
    products.forEach((prod) {
      var needUpdatedProd = favoriteProducts
          .firstWhere((element) => element.id == prod.id, orElse: () => prod);
      prod.isLiked = needUpdatedProd.isLiked;
      result.add(prod);
    });
    return result;
  }

  Future<bool> getProductsAfterUserLoggedIn(
      List<ProductModel> favoriteProducts) async {
    List<ProductModel> products = [];
    try {
      var resp = await getProducts();
      if (products.isNotEmpty) {
        products.forEach((prod) {
          var needUpdatedProd = favoriteProducts.firstWhere(
              (element) => element.id == prod.id,
              orElse: () => prod);
          prod.isLiked = needUpdatedProd.isLiked;
          products.add(prod);
        });
        productsAfterLoggedIn = products;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("getProductsAfterUserLoggedIn:${e.toString()}");
    }
    return false;
  }
}
