import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';

class StringUtils {

  String displayAddress(AddressModel addressModel){
    return  '${addressModel.currentAddress}, ${locale.language
        .DELIVERY_ADDRESS_WARD} ${addressModel.ward?.name},'
        ' ${locale.language.DELIVERY_ADDRESS_DISTRICT} ${addressModel
        .district?.name},${addressModel.city?.name}';
  }

  static double calculateTotalCost(List<OrderedProductModel> list) {
    double _cost = 0;
    if (list.isEmpty) return 0;
    for (var i in list) {
      _cost += i.quantity * i.cost!.toDouble();
    }
    return _cost;
  }
  static bool isNotNullAndEmpty(String? value) {
    return value != null &&
        value.isNotEmpty &&
        value != "" &&
        value != 'null' &&
        value != 'undefined';
  }

  static String? trim(String? value) {
    if (value != null) {
      return value.trim().replaceAll(RegExp(r'\s+\b|\b\s'), '');
    }
    return value;
  }

  static String formatMobileNumber(String value) {
    if (!isNotNullAndEmpty(value)) return value;
    var trimmed = trim(value);
    var regExp = RegExp('[0-9]');
    trimmed = regExp.allMatches(trimmed!).map((m) => m.group(0)).join('');
    if (trimmed.startsWith('84')) {
      return trimmed.replaceFirstMapped('84', (match) => '0');
    }
    return trimmed;
  }

  static String hideCardNumber(String? cardNumber) {
    if (!StringUtils.isNotNullAndEmpty(cardNumber)) return '';

    int cardLength = cardNumber?.length ?? 0;

    if (cardLength == 0) {
      return '';
    }

    String fourLastNumber =
        cardNumber?.substring(cardLength - 4, cardLength) ?? '';
    return 'XXXX-XXXX-XXXX-$fourLastNumber';
  }

  static String show4LastNumber(String? cardNumber) {
    if (!StringUtils.isNotNullAndEmpty(cardNumber)) return '';

    int cardLength = cardNumber?.length ?? 0;

    if (cardLength == 0) {
      return '';
    }

    return cardNumber?.substring(cardLength - 4, cardLength) ?? '';
  }
}

extension StringNotNullOrEmpty on String? {
  bool isNotNullAndEmpty() {
    return this != null &&
        (this?.isNotEmpty ?? false) &&
        this != "" &&
        this != 'null' &&
        this != 'undefined';
  }
}
