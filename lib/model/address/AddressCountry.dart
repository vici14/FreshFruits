class Country {
  int? id;
  String? name;
  String? nameWithType;

//  String slug;
//  String type;
//  String nameWithType;
//  int code;
//  int countryId;

  factory Country.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return Country(
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

  Country({  this.id,   this.name,   this.nameWithType});
}
