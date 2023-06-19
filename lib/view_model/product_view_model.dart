import 'package:fresh_fruit/mock_data.dart';

import '../model/product_model.dart';
import '../repository/ProductRepositoryImpl.dart';
import '../repository/ProductRepository.dart';
import 'BaseViewModel.dart';

class ProductViewModel extends BaseViewModel {
  static final ProductViewModel _instance = ProductViewModel._internal();

  ProductViewModel._internal();

  factory ProductViewModel() {
    return _instance;
  }

  static ProductViewModel instance() => _instance;

  final ProductRepository _repository = ProductRepositoryImplement();

  //=======================FIELD VALUE=========================
  bool isLoadingProduct = false;
  List<ProductModel>? products = listCars;
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

  bool isLoadingProductMore=false;

  //=======================FIELD VALUE=========================

  void updateLikeStatus(ProductModel productModel) {
    ///use when like product at home
    productsAfterLoggedIn
        ?.firstWhere((element) => element.id == productModel.id)
        .isLiked = true;
    _updateLikeStatusInCategory(productModel: productModel);
    notifyListeners();
  }

  void _updateLikeStatusInCategory({required ProductModel productModel}) {
    switch (productModel.category) {
      case "meat":
        meatProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = true;
        break;
      case "vegetable":
        vegetableProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = true;
        break;
      case "house_ware":
        houseWareProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = true;
        break;
    }
  }

  void updateLikeStatusInCategory(ProductModel productModel) {
    ///use for like product at category
    switch (productModel.category) {
      case "meat":
        meatProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = true;
        break;
      case "vegetable":
        vegetableProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = true;
        break;
      case "house_ware":
        houseWareProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = true;
        break;
    }
    productsAfterLoggedIn
        ?.firstWhere((element) => element.id == productModel.id)
        .isLiked = true;
  }

  void updateUnLikeStatus(ProductModel productModel) {
    ///use when unlike product at home
    _updateUnLikeStatusInCategory(productModel: productModel);
    productsAfterLoggedIn
        ?.firstWhere((element) => element.id == productModel.id)
        .isLiked = false;
    notifyListeners();
  }

  void _updateUnLikeStatusInCategory({required ProductModel productModel}) {
    switch (productModel.category) {
      case "meat":
        meatProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = false;
        break;
      case "vegetable":
        vegetableProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = false;
        break;
      case "house_ware":
        houseWareProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = false;
        break;
    }
  }

  void updateUnLikeStatusInCategory(ProductModel productModel) {
    ///use for unlike product at category
    switch (productModel.category) {
      case "meat":
        meatProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = false;
        break;
      case "vegetable":
        vegetableProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = false;
        break;
      case "house_ware":
        houseWareProductsAfterLoggedIn
            .firstWhere((element) => element.id == productModel.id)
            .isLiked = false;
        break;
    }
    productsAfterLoggedIn
        ?.firstWhere((element) => element.id == productModel.id)
        .isLiked = false;
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
    List<ProductModel> _products = [];
    List<ProductModel> _result = [];
    switch (category) {
      case "meat":
        await getMeatProducts();
        _products = meatProducts;
        break;
      case "vegetable":
        await getVegetableProducts();
        _products = vegetableProducts;
        break;
      case "house_ware":
        await getHouseWareProducts();
        _products = houseWareProducts;
        break;
    }
    _products.forEach((prod) {
      var _needUpdatedProd = favoriteProducts
          .firstWhere((element) => element.id == prod.id, orElse: () => prod);
      prod.isLiked = _needUpdatedProd.isLiked;
      _result.add(prod);
    });
    return _result;
  }

  Future<bool> getProductsAfterUserLoggedIn(
      List<ProductModel> favoriteProducts) async {
    List<ProductModel> _products = [];
    try {
      var _resp = await getProducts();
      if (products != null && products!.isNotEmpty) {
        products?.forEach((prod) {
          var _needUpdatedProd = favoriteProducts.firstWhere(
              (element) => element.id == prod.id,
              orElse: () => prod);
          prod.isLiked = _needUpdatedProd.isLiked;
          _products.add(prod);
        });
        productsAfterLoggedIn = _products;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("getProductsAfterUserLoggedIn:${e.toString()}");
    }
    return false;
  }
}
