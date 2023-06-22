class District {
  int? id;
  String? name;
  String? nameWithType;

//  String slug;
//  String type;
//  String nameWithType;
//  int code;
//  int countryId;

  District({this.id, this.name, this.nameWithType});

  bool operator ==(dynamic other) =>
      other != null && other is District && this.name == other.name;

  factory District.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return District(
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

  @override
  int get hashCode => super.hashCode;
}
