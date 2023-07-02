import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
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

class SignUpScreen extends StatefulWidget {
  final Function onSignUpSuccess;

  const SignUpScreen({
    Key? key,
    required this.onSignUpSuccess,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserViewModel? userViewModel;

  TextEditingController? signUpNameCtl;
  TextEditingController? signUpUserNameCtl;
  TextEditingController? signUpPasswordCtl;

  bool isEmailValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userViewModel = Provider.of<UserViewModel>(context, listen: false);
    });

    signUpUserNameCtl = TextEditingController();
    signUpPasswordCtl = TextEditingController();
    signUpNameCtl = TextEditingController();
  }

  @override
  void dispose() {
    signUpUserNameCtl?.dispose();
    signUpPasswordCtl?.dispose();
    signUpNameCtl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child){
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 32),
              CommonTextField(
                controller: signUpNameCtl ?? TextEditingController(),
                labelText: locale.language.USERNAME,
              ),
              const SizedBox(height: 21),
              CommonTextField(
                controller: signUpUserNameCtl ?? TextEditingController(),
                labelText: 'Email',
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
                controller: signUpPasswordCtl ?? TextEditingController(),
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
                text:locale.language.SIGNUP ,onTap:()=> onSignupClick(context),
                isLoading: userViewModel.isSigningUp,
              ),
              const SizedBox(height: 25),
              Center(
                child: EasyRichText(
                  locale.language.ALREADY_HAVE_ACCOUNT_SIGNIN,
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
                      locale.language.ALREADY_HAVE_ACCOUNT_SIGNIN_PATTERN_1,
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

  void onSignupClick(BuildContext context) async {
    if ((signUpNameCtl?.text.isNotNullAndEmpty() ?? false) &&
        (signUpUserNameCtl?.text.isNotNullAndEmpty() ?? false) &&
        (signUpPasswordCtl?.text.isNotNullAndEmpty() ?? false)) {
      bool? isSignUpSuccess = await userViewModel?.signUpWithEmailAndPassword(
        name: signUpNameCtl?.text ?? '',
        email: signUpUserNameCtl?.text ?? '',
        password: signUpPasswordCtl?.text ?? '',
      );
      if (isSignUpSuccess ?? false) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã đăng ký thành công, bạn hãy đăng nhập!'),
          ),
        );
        widget.onSignUpSuccess();
      }
    }
  }
}
