import 'package:intl/intl.dart';

class CurrencyFormatter {
  final NumberFormat decimalFormat = NumberFormat.decimalPattern('en_US');

  String toDisplayValue(num? value,
      {String? unit, String currency = 'đ', bool isShowDecimal = false}) {
    if (value == null) return '';
    if (isShowDecimal) {
      return decimalFormat.format(value) + currency;
    }
    return unit == null
        ? decimalFormat.format(value).split('.').first + currency
        : '${decimalFormat.format(value).split('.').first}$currency/$unit';
  }
}
