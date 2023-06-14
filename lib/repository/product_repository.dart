import 'package:fresh_fruit/model/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();

  Future<List<ProductModel>> getProductsByCategory(String categoryId);

  Future<bool> addToFavorite(String productId);
}
