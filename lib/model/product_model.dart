class ProductModel {
  String? avatar;
  String? name;
  String? description;
  bool isLiked;
  double cost;
  String? id;
  String? category;
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
    this.imageUrls = const [],
  });

  factory ProductModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return ProductModel(
        id: snapshot['id'],
        cost: snapshot['cost'] != null
            ? double.parse(snapshot['cost'].toString())
            : 0,
        category: snapshot['category'] != null ? snapshot['category'] : '',
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
            : []);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'cost': cost,
      'description': description,
      'avatar': avatar,
      'isLiked': isLiked,
      'name': name,
      'category': category,
      'unit': unit,
      'imageUrls': imageUrls?.isNotEmpty == true
          ? List.generate(imageUrls?.length ?? 0,
              (index) => imageUrls![index].toString()).toList()
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
