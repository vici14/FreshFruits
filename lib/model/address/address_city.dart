class City {
  int? id;
  String? name;
  String? nameWithType;

//  String slug;
//  String type;
//  String nameWithType;
//  int code;
//  int countryId;

  City({this.id, this.name, this.nameWithType});

  bool operator ==(dynamic other) =>
      other != null && other is City && this.name == other.name;

  @override
  int get hashCode => super.hashCode;
}
