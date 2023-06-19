import 'package:fresh_fruit/model/product_model.dart';

class OrderedProductModel {
  String id;
  String? imageUrl;
  String? name;
  String? description;
  double? cost;
  String? category;
  int quantity;
  String? unit;

  OrderedProductModel({
    required this.id,
    this.cost,
    this.name,
    this.description,
    this.imageUrl,
    this.category,
    this.quantity = 0,
    this.unit,
  });

  factory OrderedProductModel.initial() {
    return OrderedProductModel(
        id: '0',
        quantity: 0,
        category: '',
        imageUrl: '',
        name: '',
        cost: 0,
        description: '');
  }

  factory OrderedProductModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return OrderedProductModel(
      id: snapshot['id'],
      category: snapshot['category'],
      cost: snapshot['cost'] != null
          ? double.parse(snapshot['cost'].toString())
          : 0,
      description: snapshot['description'] != null
          ? snapshot['description'] as String
          : '',
      imageUrl:
          snapshot['imageUrl'] != null ? snapshot['imageUrl'] as String : '',
      name: snapshot['name'] != null ? snapshot['name'] as String : '',
      quantity: snapshot['quantity'] != null ? snapshot['quantity'] as int : 0,
      unit: snapshot['unit'] != null ? snapshot['unit'] as String : '',
    );
  }

  factory OrderedProductModel.fromProductModel(
      {required ProductModel product, required int quantity}) {
    return OrderedProductModel(
        id: product.id ?? '0',
        category: product.category,
        imageUrl: product.imageUrl,
        description: product.description,
        cost: product.cost,
        name: product.name,
        unit: product.unit,
        quantity: quantity);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'category': category,
      'cost': cost,
      'description': description,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'name': name,
      'unit': unit,
    };
  }
}
