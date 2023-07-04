import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
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
  TextEditingController? signUpOTPCtl;

  bool isPhoneNumberValid = false;
  bool showOTPField = false;

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
            labelText: 'Số điện thoại',
            suffixIcon: isPhoneNumberValid
                ? Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: SvgPicture.asset(
                AppImageAsset.iconGreenCheck,
                fit: BoxFit.scaleDown,
              ),
            )
                : const SizedBox(),
            onChange: (value) {
              // if (RegExp(
              //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              if (RegExp(r"(84|0[3|5|7|8|9])+([0-9]{8})\b")
                  .hasMatch(value ?? '')) {
                setState(() {
                  isPhoneNumberValid = true;
                });
              } else {
                setState(() {
                  isPhoneNumberValid = false;
                });
              }
            },
            keyboardType: TextInputType.phone,
          ),
          if (showOTPField) const SizedBox(height: 21),
          if (showOTPField)
            CommonTextField(
              controller: signUpOTPCtl ?? TextEditingController(),
              labelText: locale.language.OTP_CODE,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.phone,
              suffixIcon: const SizedBox(
                height: 0.0,
                width: 0.0,
                child: Center(
                    child: CircularProgressIndicator()
                ),
              ),
            ),
          const SizedBox(height: 21),
          CommonTextField(
            controller: signUpPasswordCtl ?? TextEditingController(),
            labelText: locale.language.PASSWORD,
            password: true,
          ),
          TextButton(
            onPressed: () {
              if (!showOTPField) {
                setState(() {
                  showOTPField = true;
                });
              }
              onSendOTPPress(context);
            },
            child: Text(
              locale.language.SEND_OTP,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 108.1 / 100,
                wordSpacing: 0.05,
                color: isPhoneNumberValid ? tertiarySeedColor : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 51),
          InkWell(
            onTap: () => onSignupClick(context),
            child: Container(
              height: 67,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primarySeedColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  locale.language.SIGNUP,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    wordSpacing: 1,
                    color: hexToColor('#FFF9FF'),
                  ),
                ),
              ),
            ),
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
          const SizedBox(height: 40),
        ],
      ),
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

  void onSendOTPPress(BuildContext context) async {
    if (!isPhoneNumberValid) return;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+84${(signUpUserNameCtl?.text.trim() ?? '').substring(
          1, 10)}',
      verificationCompleted: (_) {},
      timeout: const Duration(seconds: 120),
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(locale.language.OTP_CODE_SENT),
          ),
        );
      },
      codeAutoRetrievalTimeout: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(locale.language.OTP_CODE_SENT_FAIL),
          ),
        );
      },
    );
  }

  Future<bool> verifyOTP(
      {required String verificationId, required String smsCode}) async {
    UserCredential auth = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode));
    return auth.user != null;
  }
}
