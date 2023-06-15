const MOBILE_LENGTH = 10;
const INVALID_MOBILE_PATTERN = r'(^0[0-9])+([0-9]{8})+$';

class ValidationUtil {
  static bool isNumeric(String value) => isValid(value, r'^[0-9]+$');

  static bool isEmptyOrNullChars(String? value) =>
      value == null || value.isEmpty || value == 'null' || value == 'undefined';

  static bool isValid(String value, String regexPattern) =>
      RegExp(regexPattern).hasMatch(value);

  static bool isInValid(String value, String regexPattern) =>
      !isValid(value, regexPattern);

  static bool isMinLength(String value, int minLength) =>
      value.length < minLength;

  static String? isValidPhone(String phone) {
    if (!isEmptyOrNullChars(phone) &&
        phone.length == MOBILE_LENGTH &&
        !isInValid(phone, INVALID_MOBILE_PATTERN)) {
      return null;
    } else {
      return 'Vui lòng nhập đúng sđt';
    }
  }

  static String? isNotNullOrEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng điền thông tin';
    }
    return null;
  }

  static String? validateMobile(String? mobile) {
    if (isEmptyOrNullChars(mobile)) {
      return 'Quý khách vui lòng nhập số điện thoại';
    }
    if (isMinLength(mobile!, MOBILE_LENGTH) ||
        isInValid(mobile, INVALID_MOBILE_PATTERN)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }
}
