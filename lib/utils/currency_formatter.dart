import 'package:intl/intl.dart';

class CurrencyFormatter {
  final NumberFormat decimalFormat = NumberFormat.decimalPattern('en_US');

  String toDisplayValue(num? value,
      {String? currency, bool isShowDecimal = false}) {
    if (value == null) return '';
    if (isShowDecimal) {
      return currency == null
          ? decimalFormat.format(value)
          : decimalFormat.format(value) + currency;
    }
    return currency == null
        ? decimalFormat.format(value).split('.').first
        : decimalFormat.format(value).split('.').first + " " + currency;
  }
}
