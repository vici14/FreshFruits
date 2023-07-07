import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/PrimaryButton.dart';
import 'package:fresh_fruit/widgets/textfield/common_textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserViewModel? userViewModel;

  TextEditingController? loginUserNameCtl;
  TextEditingController? loginPasswordCtl;

  bool isEmailValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userViewModel = Provider.of<UserViewModel>(context, listen: false);
    });
    loginUserNameCtl = TextEditingController();
    loginPasswordCtl = TextEditingController();
  }

  @override
  void dispose() {
    loginPasswordCtl?.dispose();
    loginUserNameCtl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
        builder: (context,userViewModel,child){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 32),
          CommonTextField(
            controller: loginUserNameCtl ?? TextEditingController(),
            labelText: 'Số điện thoại',
            suffixIcon: isEmailValid
                ? Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: SvgPicture.asset(
                      AppImageAsset.iconGreenCheck,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                : const SizedBox(),
            onChange: (value) {
              if (RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value ?? '')) {
                    setState(() {
                      isEmailValid = true;
                    });
                  } else {
                    setState(() {
                      isEmailValid = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 21),
              CommonTextField(
                controller: loginPasswordCtl ?? TextEditingController(),
                labelText: locale.language.PASSWORD,
                password: true,
              ),
              const SizedBox(height: 16),
              Text(
                locale.language.FORGOT_PASSWORD,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 108.1 / 100,
                  wordSpacing: 0.05,
                  color: tertiarySeedColor,
                ),
              ),
              const SizedBox(height: 51),
              PrimaryButton(
                text: locale.language.LOGIN,
                onTap: () => onLoginClick(context),
                isLoading: userViewModel.isLoggingIn,
              ),
              const SizedBox(height: 25),
              Center(
                child: EasyRichText(
                  locale.language.DONT_HAVE_ACCOUNT_LOGIN,
                  defaultStyle: const TextStyle(
                    fontSize: 12,
                    height: 12.97 / 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: .05,
                    color: tertiarySeedColor,
                  ),
                  patternList: [
                    EasyRichTextPattern(
                      targetString:
                      locale.language.DONT_HAVE_ACCOUNT_LOGIN_PATTERN_1,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 12.97 / 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: .05,
                        color: surfaceSeedColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },

    );
  }

  void onLoginClick(BuildContext context) async {
    if ((loginUserNameCtl?.text.isNotNullAndEmpty() ?? false) &&
        (loginPasswordCtl?.text.isNotNullAndEmpty() ?? false)) {
      EasyLoading.showProgress(
        .3,
        status: 'Login...',
        maskType: EasyLoadingMaskType.clear,
      );
      bool? isSuccess = await userViewModel?.signInWithEmailAndPassword(
        context,
        email: '${loginUserNameCtl?.text ?? ' '}@freshfruit.com',
        password: loginPasswordCtl?.text ?? '',
      );
      EasyLoading.dismiss();
      if (isSuccess ?? false) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }
}
