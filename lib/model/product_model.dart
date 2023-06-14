class ProductModel {
  String? imageUrl;
  String? name;
  String? description;
  bool isLiked;
  double cost;
  String? id;
  String? category;

  ProductModel({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.isLiked,
    required this.cost,
    required this.id,
    required this.category,
  });

  factory ProductModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return ProductModel(
        id: snapshot['id'],
        cost: double.parse(snapshot['cost'].toString()),
        category: snapshot['category'] != null ? snapshot['category'] : '',
        description: snapshot['description'] != null
            ? snapshot['description'] as String
            : '',
        imageUrl:
            snapshot['imageUrl'] != null ? snapshot['imageUrl'] as String : '',
        isLiked:
            snapshot['isLiked'] != null ? snapshot['isLiked'] as bool : false,
        name: snapshot['name'] != null ? snapshot['name'] as String : '');
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'cost': cost,
      'description': description,
      'imageUrl': imageUrl,
      'isLiked': isLiked,
      'name': name,
      'category': category
    };
  }

  ProductModel changeLikeStatus() {
    return ProductModel(
        name: this.name,
        cost: this.cost,
        description: this.description,
        imageUrl: this.imageUrl,
        isLiked: !this.isLiked,
        id: this.id,
        category: this.category);
  }
}
