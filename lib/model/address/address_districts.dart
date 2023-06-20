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

  @override
  int get hashCode => super.hashCode;
}
