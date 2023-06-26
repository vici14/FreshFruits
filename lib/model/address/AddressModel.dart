import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/address/AddressCity.dart';
import 'package:fresh_fruit/model/address/AddressDistricts.dart';
import 'package:fresh_fruit/model/address/AdressWards.dart';

class AddressModel {
  final City? city;
  final District? district;
  final Ward? ward;
  final String? currentAddress;

  AddressModel({
    this.city,
    this.district,
    this.ward,
    this.currentAddress,
  });

  String get getDisplayAddress =>
      '$currentAddress, ${locale.language.DELIVERY_ADDRESS_WARD} ${ward?.name},'
      ' ${locale.language.DELIVERY_ADDRESS_DISTRICT} ${district?.name},${city?.name}';

  factory AddressModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return AddressModel(
      city: City.fromQuerySnapshot(snapshot['city']),
      ward: Ward.fromQuerySnapshot(snapshot['ward']),
      district: District.fromQuerySnapshot(snapshot['district']),
      currentAddress: snapshot['currentAddress'] ?? "",
    );
  }

  Map<String, Object?> toJson() {
    return {
      "city": city?.toJson(),
      "district": district?.toJson(),
      "ward": ward?.toJson(),
      "currentAddress": currentAddress,
    };
  }
}
