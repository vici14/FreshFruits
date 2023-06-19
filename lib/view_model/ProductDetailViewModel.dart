import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/repository/CartRepositoryImpl.dart';
import 'package:fresh_fruit/repository/CartRepository.dart';
import 'package:fresh_fruit/view_model/BaseViewModel.dart';

class ProductDetailViewModel extends BaseViewModel {
  CartRepository _repository = CartRepositoryImplement();
  final ProductModel productModel;

  ProductDetailViewModel(this.productModel);

  int quantity = 1;

  increaseQuantity() {
    quantity += 1;
    notifyListeners();
  }

  decreaseQuantity() {
    if (quantity > 0) {
      quantity -= 1;
    }
    notifyListeners();
  }

  double get totalCost {
    if (quantity > 1) {
      return productModel.cost * quantity;
    } else if (quantity == 0) {
      return 0;
    }
    return productModel.cost;
  }

  void addToCart(
      {required ProductModel productModel,
      required int quantity,
      required String uid}) {
    _repository.addToCart(
        quantity: quantity, uid: uid, productModel: productModel);
  }
}
