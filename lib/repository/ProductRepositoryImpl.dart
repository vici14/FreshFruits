import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/repository/ProductRepository.dart';
import 'package:fresh_fruit/service/service_manager.dart';

class ProductRepositoryImplement extends ProductRepository {
  ServiceManager serviceManager = ServiceManager.instance();
  @override
  Future<bool> addToFavorite(String productId) {
    // TODO: implement addToFavorite
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    return await serviceManager.getProducts();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    return await serviceManager.getProductsByCategory(categoryId);
  }
}
