import 'package:flutter/cupertino.dart';
import 'package:fresh_fruit/db/DatabaseManager.dart';
import 'package:fresh_fruit/model/address/AddressCity.dart';
import 'package:fresh_fruit/model/address/AddressDistricts.dart';
import 'package:fresh_fruit/model/address/AdressWards.dart';

class AddDeliveryAddressController extends ChangeNotifier {
  final DatabaseManager _databaseManager = DatabaseManager.instance;
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Ward> wards = [];
  List<District> districts = [];
  City currCity =
      City(id: 79, nameWithType: "Hồ Chí Minh", name: "Thành phố Hồ Chí Minh");

  District? _currDistrict;
  Ward? _currWard;

  AddDeliveryAddressController() {
    getDistrict();
  }

  District? get currDistrict => _currDistrict;

  set currDistrict(District? value) {
    _currDistrict = value;
    notifyListeners();
  }

  Future<void> getWards(String districtId) async {
    wards = await _databaseManager.queryWard(districtId);
    print('wards.length${wards.length}');
  }

  Future<void> getDistrict() async {
    districts = await _databaseManager.queryDistrict();
    print('districts.length${districts.length}');
  }

  Ward? get currWard => _currWard;

  set currWard(Ward? value) {
    _currWard = value;
    notifyListeners();
  }

  String? _currStreet;

  String? get currStreet => _currStreet;

  set currStreet(String? value) {
    _currStreet = value;
    notifyListeners();
  }
}
