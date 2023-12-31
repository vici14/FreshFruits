import 'package:fresh_fruit/model/product_model.dart';

class OrderedProductModel {
  String id;
  String? avatar;
  String? name;
  String? description;
  double? cost;
  ProductCategory? category;
  int quantity;
  String? unit;
  List<String>? imageUrls;

  OrderedProductModel({
    required this.id,
    this.cost,
    this.name,
    this.description,
    this.avatar,
    this.category,
    this.quantity = 0,
    this.unit,
    this.imageUrls,
  });

  OrderedProductModel updateQuantity(int updatedQuantity) {
    return OrderedProductModel(
      id: id,
      category: category,
      cost: cost,
      description: description,
      avatar: avatar,
      name: name,
      quantity: updatedQuantity,
      unit: unit,
      imageUrls: imageUrls,
    );
  }

  factory OrderedProductModel.initial() {
    return OrderedProductModel(
        id: '0',
        quantity: 0,
        category: ProductCategory.UNDEFINED,
        imageUrls:[],
        avatar: '',
        name: '',
        cost: 0,
        description: '');
  }

  factory OrderedProductModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    String _category = "";
    if (snapshot['category'] != null &&
        snapshot['category'] is String) {
      _category = snapshot['category'] as String;
    }
    return OrderedProductModel(
      id: snapshot['id'],
      category: snapshot['category'] != null ? _category.toProdCategory() : null,
      cost: snapshot['cost'] != null
          ? double.parse(snapshot['cost'].toString())
          : 0,
      description: snapshot['description'] != null
          ? snapshot['description'] as String
          : '',
      avatar:
          snapshot['avatar'] != null ? snapshot['avatar'] as String : '',
      name: snapshot['name'] != null ? snapshot['name'] as String : '',
      quantity: snapshot['quantity'] != null ? snapshot['quantity'] as int : 0,
      unit: snapshot['unit'] != null ? snapshot['unit'] as String : '',
      imageUrls: snapshot['imageUrls'] != null
          ? List.generate(snapshot['imageUrls'].length,
              (index) => snapshot['imageUrls'][index] as String).toList()
          : [],
    );
  }

  factory OrderedProductModel.fromProductModel(
      {required ProductModel product, required int quantity}) {
    return OrderedProductModel(
        id: product.id ?? '0',
        category: product.category,
        avatar: product.avatar,
        description: product.description,
        cost: product.cost,
        name: product.name,
        unit: product.unit,
        imageUrls:product.imageUrls,
        quantity: quantity);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'category': category?.toName(),
      'cost': cost,
      'description': description,
      'avatar': avatar,
      'quantity': quantity,
      'name': name,
      'unit': unit,
      'imageUrls': imageUrls?.isNotEmpty == true
          ? List.generate(imageUrls?.length ?? 0,
              (index) => imageUrls![index].toString()).toList()
          : [],
    };
  }
}
