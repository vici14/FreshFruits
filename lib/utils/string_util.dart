import '../model/ordered_product_model.dart';

class StringUtil {
  static double calculateTotalCost(List<OrderedProductModel> list) {
    double _cost = 0;
    if (list.isEmpty) return 0;
    for (var i in list) {
      _cost += i.quantity * i.cost!.toDouble();
    }
    return _cost;
  }
}
