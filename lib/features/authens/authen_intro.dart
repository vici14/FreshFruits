import 'package:flutter/material.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/route/AppRoute.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';

class AuthenIntroScreen extends StatelessWidget {
  const AuthenIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AppImageAsset.authenBackground,
          ),
          alignment: Alignment.topCenter,
          fit: BoxFit.fitWidth,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 353),
          Text(
            locale.language.AUTHEN_INTRO,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              wordSpacing: 1,
              color: tertiarySeedColor,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            locale.language.YOU_DONT_LOGIN_YET,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              height: 21 / 15,
              color: hexToColor('#7C7C7C'),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            child: Container(
              height: 55,
              width: 280,
              decoration: BoxDecoration(
                color: secondarySeedColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  locale.language.LOGIN_OR_SIGNUP,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    wordSpacing: 1,
                    color: hexToColor('#FFF9FF'),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRoute.authenScreen);
            },
          ),
        ],
      ),
    );
  }
}
