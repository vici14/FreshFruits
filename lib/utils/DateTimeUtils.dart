 import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'StringUtils.dart';

enum DateFormatType { ddMMYYYhhmm, ddMMYYY }

extension DateFormatFromType on DateFormatType {
  String format(String date) {
    initializeDateFormatting('en_SG', null);

    switch (this) {
      case DateFormatType.ddMMYYYhhmm:
        return DateFormat(
            'dd MMM yyyy, '
                'hh:mma',
            'en_SG')
            .format(DateTime.parse(date).toLocal());
      case DateFormatType.ddMMYYY:
        return DateFormat('dd MMM yyyy', 'en_SG')
            .format(DateTime.parse(date).toLocal());
    }
  }
}

class DateTimeUtils {


  static const String DATE_TIME_PATTERN_SERVER_SHORT = 'yyyy-MM-dd';

  static const String DATE_TIME_DATE_PICKER = 'yyyy-MM-dd hh:mm:ss.SSS';

  static const String SHORT_DATE_WITH_SLASH = 'dd/MM/yyyy';

  static const String SHORT_DATE_WITH_DASH = 'dd-MM-yyyy';

  static const String TIME = 'HH:mm';

  static const String STATEMENT_DATE = 'yyyy/MM/dd';

  static const String STATEMENT_DATE_WITHOUT_SIMPLE = 'yyyyMMdd';

  static const String CREDIT_STATEMENT_DATE_TO_REQUEST = 'yyyyMM';

  static const String DATE_TIME_INCLUDE_WEEKDAY =
      'EEEE, $SHORT_DATE_WITH_SLASH';

  static const String DATE_TIME_PATTERN_FULL = 'dd-MM-yyyy hh:mm';


  static String toDisplayString(
      DateTime? date, {
        String? pattern,
      }) {
    if (!StringUtils.isNotNullAndEmpty(pattern)) {
      pattern = DATE_TIME_PATTERN_FULL;
    }
    if (date == null) {
      return '';
    }
    try {
      return DateFormat(pattern).format(date);
    } catch (e) {
      AppLogger.e(
          'Parse String date: ${date.toString()} pattern: $pattern with error: ${e.toString()}');
      return '';
    }
  }
  String formatDateFromTimeZone(String? date,
      {required DateFormatType formatType}) {
    initializeDateFormatting('en_SG', null);
    if (!StringUtils.isNotNullAndEmpty(date)) return '';
    return formatType.format(date!);
  }

  String formatDateDDMMYY(String date) {
    initializeDateFormatting('en_SG', null);

    return DateFormat('dd MMM yyyy', 'en_SG')
        .format(DateTime.parse(date).toLocal());
  }
}
