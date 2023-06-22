class Ward {
  int? id;
  String? name;

//  String slug;
//  String type;
  String? nameWithType;

//  int code;
//  int countryId;

  Ward({this.id, this.name, this.nameWithType});

  factory Ward.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return Ward(
      id: snapshot['id'] ?? '',
      name: snapshot['name'] ?? '',
      nameWithType: snapshot['nameWithType'] ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'nameWithType': nameWithType,
    };
  }
}
