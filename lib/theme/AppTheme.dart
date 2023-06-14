import 'package:flutter/material.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';

import 'AppColor.dart';
import 'AppDimen.dart';
import 'AppFont.dart';
// Define your seed colors.
const Color primarySeedColor = Colors.green;
const Color secondarySeedColor = Color(0xFFC6D8AF);
const Color tertiarySeedColor = Color(0xFF6CA450);

class AppTheme {

  final ColorScheme schemeLight = SeedColorScheme.fromSeeds(
    brightness: Brightness.light,
    // Primary key color is required, like seed color ColorScheme.fromSeed.
    primaryKey: primarySeedColor,
    // You can add optional own seeds for secondary and tertiary key colors.
    secondaryKey: secondarySeedColor,
    tertiaryKey: tertiarySeedColor,
    // Tone chroma config and tone mapping is optional, if you do not add it
    // you get the config matching Flutter's Material 3 ColorScheme.fromSeed.
    tones: FlexTones.vivid(Brightness.light),
  );

// Make a dark ColorScheme from the seeds.
  final ColorScheme schemeDark = SeedColorScheme.fromSeeds(
    brightness: Brightness.dark,
    primaryKey: primarySeedColor,
    secondaryKey: secondarySeedColor,
    tertiaryKey: tertiarySeedColor,
    tones: FlexTones.vivid(Brightness.dark),
  );

// Make a high contrast light ColorScheme from the seeds.
  final ColorScheme schemeLightHc = SeedColorScheme.fromSeeds(
    brightness: Brightness.light,
    primaryKey: primarySeedColor,
    secondaryKey: secondarySeedColor,
    tertiaryKey: tertiarySeedColor,
    tones: FlexTones.highContrast(Brightness.light),
  );

// Make a ultra contrast dark ColorScheme from the seeds.
  final ColorScheme schemeDarkHc = SeedColorScheme.fromSeeds(
    brightness: Brightness.dark,
    primaryKey: primarySeedColor,
    secondaryKey: secondarySeedColor,
    tertiaryKey: tertiarySeedColor,
    tones: FlexTones.ultraContrast(Brightness.dark),
  );



  ThemeData lightTheme() {
    return ThemeData.from(
      colorScheme: schemeLight,
      textTheme: buildTextTheme(),
      useMaterial3: true,
    );
  }

  ThemeData darkTheme() {
    return ThemeData.from(
      colorScheme: schemeDark,
      textTheme: buildTextTheme(),
      useMaterial3: true,
    );
  }


  TextTheme buildTextTheme() {
    return const TextTheme(
      headlineSmall: TextStyle(
          fontSize: AppDimen.fontSize16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontFamily: AppFont.gilroy,
          letterSpacing: 0),
      headlineMedium: TextStyle(
          fontSize: AppDimen.fontSize18,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: AppFont.gilroy,
          letterSpacing: 0),
      headlineLarge: TextStyle(
          fontSize: AppDimen.fontSize20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: AppFont.gilroy,
          letterSpacing: 0),
      /*labelLarge: TextStyle(
          color: AppColor.blueMain,
          fontSize: AppDimen.fontSize12,
          fontFamily: AppFont.gilroy,
          letterSpacing: 0),
      labelSmall: TextStyle(
          color: Colors.black,
          fontSize: AppDimen.fontSize12,
          fontFamily: AppFont.inter,
          letterSpacing: 0),
      titleLarge: TextStyle(
          fontFamily: AppFont.gilroy,
          fontSize: AppDimen.fontSize18,
          color: AppColor.blueMain,
          fontWeight: FontWeight.w500,
          letterSpacing: 0),*/
      bodySmall: TextStyle(
          fontSize: AppDimen.fontSize12,
          color: Colors.black,
          fontFamily: AppFont.inter,
          letterSpacing: 0),
      bodyMedium: TextStyle(
          fontSize: AppDimen.fontSize14,
          color: Colors.black,
          fontFamily: AppFont.inter,
          letterSpacing: 0),
      bodyLarge: TextStyle(
          color: Colors.black,
          fontFamily: AppFont.inter,
          fontSize: AppDimen.fontSize16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0),
      /* bodyLarge: TextStyle(
          fontSize: AppDimen.fontSize22,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: AppFont.gilroy,
          letterSpacing: 0)*/
    );
  }

  ButtonThemeData buildButtonTheme() {
    return const ButtonThemeData(
      height: 46,
      padding: EdgeInsets.all(
        AppDimen.space8,
      ),
      textTheme: ButtonTextTheme.primary,
    );
  }

  static BoxDecoration roundedGreyBorder = BoxDecoration(
    border: Border.all(
      color: AppColor.borderGrey,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(AppDimen.radius20),
    ),
  );
  static BoxDecoration roundedStandardGreyBorder = const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
      color: Colors.white);

  static BoxDecoration roundedButtonDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColor.borderGrey));
}