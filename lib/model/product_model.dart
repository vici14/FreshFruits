import 'package:fresh_fruit/model/ordered_product_model.dart';

enum ProductCategory {
  FOOD_AND_VEGE,
  MEATS,
  BAKERY,
  DAIRY,
  BEVERAGE,
  UNDEFINED
}

extension CategoryMap on String {
  ProductCategory toProdCategory() {
    switch (this) {
      case 'FOOD_AND_VEGE':
        return ProductCategory.FOOD_AND_VEGE;
      case 'BAKERY':
        return ProductCategory.BAKERY;
      case 'DAIRY':
        return ProductCategory.DAIRY;
      case 'BEVERAGE':
        return ProductCategory.BEVERAGE;
      default:
        return ProductCategory.UNDEFINED;
    }
  }
}

extension ProductCategoryName on ProductCategory {
  String toName() {
    switch (this) {
      case ProductCategory.FOOD_AND_VEGE:
        return 'FOOD_AND_VEGE';
      case ProductCategory.BAKERY:
        return 'BAKERY';
      case ProductCategory.DAIRY:
        return 'DAIRY';
      case ProductCategory.BEVERAGE:
        return 'BEVERAGE';
      default:
        return '';
    }
  }
}

enum Popular {
  HOT,
  LIKED,
}

extension PopularName on Popular {
  String toName() {
    switch (this) {
      case Popular.HOT:
        return 'HOT';
      case Popular.LIKED:
        return 'LIKED';
      default:
        return '';
    }
  }
}

class ProductModel {
  String? avatar;
  String? name;
  String? description;
  bool isLiked;
  double cost;
  String? id;
  ProductCategory? category;
  List<String> popular;

  String? unit;
  List<String>? imageUrls;

  ProductModel({
    required this.avatar,
    required this.name,
    required this.description,
    required this.isLiked,
    required this.cost,
    required this.id,
    required this.category,
    required this.unit,
    this.popular = const [],
    this.imageUrls = const [],
  });

  factory ProductModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    String _category = "";
    if (snapshot['category'] != null && snapshot['category'] is String) {
      _category = snapshot['category'] as String;
    }

    return ProductModel(
      id: snapshot['id'],
      cost: snapshot['cost'] != null
          ? double.parse(snapshot['cost'].toString())
          : 0,
      category:
          snapshot['category'] != null ? _category.toProdCategory() : null,
      description: snapshot['description'] != null
          ? snapshot['description'] as String
          : '',
      avatar: snapshot['avatar'] != null ? snapshot['avatar'] as String : '',
      isLiked:
          snapshot['isLiked'] != null ? snapshot['isLiked'] as bool : false,
      name: snapshot['name'] != null ? snapshot['name'] as String : '',
      unit: snapshot['unit'] != null ? snapshot['unit'] as String : '',
      imageUrls: snapshot['imageUrls'] != null
          ? List.generate(snapshot['imageUrls'].length,
              (index) => snapshot['imageUrls'][index] as String).toList()
          : [],
      popular: snapshot['popular'] != null
          ? List.generate(snapshot['popular'].length,
              (index) => snapshot['popular'][index] as String).toList()
          : [],
    );
  }
  factory ProductModel.fromOrderedProductModel(
      {required OrderedProductModel product, }) {
    return ProductModel(
        id: product.id ,isLiked:false,popular:[] ,
        category: product.category,
        avatar: product.avatar,
        description: product.description,
        cost: product.cost ?? 0,
        name: product.name,
        unit: product.unit,
        imageUrls:product.imageUrls,
         );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'cost': cost,
      'description': description,
      'avatar': avatar,
      'isLiked': isLiked,
      'name': name,
      'category': category?.toName(),
      'unit': unit,
      'imageUrls': imageUrls?.isNotEmpty == true
          ? List.generate(imageUrls?.length ?? 0,
              (index) => imageUrls![index].toString()).toList()
          : [],
      'popular': popular.isNotEmpty
          ? List.generate(popular.length, (index) => popular[index].toString())
          .toList()
          : [],
    };
  }

  ProductModel changeLikeStatus() {
    return ProductModel(
        name: this.name,
        cost: this.cost,
        description: this.description,
        avatar: this.avatar,
        isLiked: !this.isLiked,
        id: this.id,
        category: this.category,
        unit: unit);
  }
}
