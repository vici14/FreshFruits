import 'dart:ui';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class AppColor {
  static const Color primary = Color(0xFFFECC4C);
  static const Color secondary = Color(0xFFF48567);
  static const Color greenMain = Color(0xff53B175);

  static const Color blueSecondary = Color(0xFFEDEDFD);
  static const Color greyScaffoldBackground = Color(0xffF6F6F6);
  static const blueFacebook = Color(0xff1877F2);
  static const Color grey = Color(0xffF2F2F2);
  static const Color textGrey = Color(0xff7c7c7c);

  static const Color lightYellow = Color(0xffFFDC67);
  static const Color mint = Color(0xff54E5AD);
  static const Color lightRed = Color(0xffFF7676);
  static const Color greenSwipe = Color(0xff96D8A1);
  static const Color greenRedeemed = Color(0xff00AA68);
  static const Color greenPurchase = Color(0xff6EE0A7);

  static const Color warningText = Color(0xffFF4A4A);
  static const Color redExpired = Color(0xffFF0000);
  static const Color lightRedChip = Color(0xffE8706C);
  static const Color golden = Color(0xffFFDC67);
  static const Color seashell = Color(0xffFCF5EE);
  static const Color metallicOrange = Color(0xffDA6317);
}
