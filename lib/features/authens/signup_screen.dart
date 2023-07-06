import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String? verId;

  TextEditingController? signUpNameCtl;
  TextEditingController? signUpUserNameCtl;
  TextEditingController? signUpPasswordCtl;
  TextEditingController? signUpOTPCtl;

  FocusNode signUpOTPFC = FocusNode();

  bool isPhoneNumberValid = false;
  bool showOTPField = false;
  bool isOTPVerified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userViewModel = Provider.of<UserViewModel>(context, listen: false);
    });

    signUpUserNameCtl = TextEditingController();
    signUpPasswordCtl = TextEditingController();
    signUpNameCtl = TextEditingController();
    signUpOTPCtl = TextEditingController();
    signUpOTPFC.addListener(() {
      if (!signUpOTPFC.hasFocus) {
        if (signUpOTPCtl?.text.length != 6 || verId == null) return;
        verifyOTP(
            verificationId: verId ?? '', smsCode: signUpOTPCtl?.text ?? '');
      }
    });
  }

  @override
  void dispose() {
    signUpUserNameCtl?.dispose();
    signUpPasswordCtl?.dispose();
    signUpNameCtl?.dispose();
    signUpOTPFC.dispose();
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
              focusNode: signUpOTPFC,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.phone,
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void onSignupClick(BuildContext context) async {
    if (!isOTPVerified) {
      EasyLoading.showToast(
        locale.language.VERIFY_OTP_FIRST,
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    }
    if ((signUpNameCtl?.text.isNotNullAndEmpty() ?? false) &&
        (signUpUserNameCtl?.text.isNotNullAndEmpty() ?? false) &&
        (signUpPasswordCtl?.text.isNotNullAndEmpty() ?? false)) {
      bool? isSignUpSuccess = await userViewModel?.signUpWithEmailAndPassword(
        name: signUpNameCtl?.text ?? '',
        email: '${signUpUserNameCtl?.text ?? ' '}@freshfruit.com',
        password: signUpPasswordCtl?.text ?? '',
      );
      if (isSignUpSuccess ?? false) {
        if (!mounted) return;
        EasyLoading.showToast(
          'Đã đăng ký thành công, bạn hãy đăng nhập!',
          toastPosition: EasyLoadingToastPosition.bottom,
        );
        widget.onSignUpSuccess();
      }
    } else {
      EasyLoading.showToast(
        locale.language.INPUT_FULL_SIGNUP_INFO,
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    }
  }

  void onSendOTPPress(BuildContext context) async {
    if (!isPhoneNumberValid) return;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber:
          '+84${(signUpUserNameCtl?.text.trim() ?? '').substring(1, 10)}',
      verificationCompleted: (_) {},
      timeout: const Duration(seconds: 120),
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          verId = verificationId;
        });
        EasyLoading.showToast(
          locale.language.OTP_CODE_SENT,
          toastPosition: EasyLoadingToastPosition.bottom,
        );
      },
      codeAutoRetrievalTimeout: (_) {
        if(isOTPVerified) return;
        EasyLoading.showToast(
          locale.language.OTP_CODE_SENT_FAIL,
          toastPosition: EasyLoadingToastPosition.bottom,
        );
      },
    );
  }

  Future verifyOTP(
      {required String verificationId, required String smsCode}) async {
    EasyLoading.showProgress(
      .3,
      status: 'Verifying...',
      maskType: EasyLoadingMaskType.clear,
    );
    UserCredential auth = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode));
    EasyLoading.dismiss();
    setState(() {
      isOTPVerified = auth.user != null;
    });
    if (isOTPVerified) {
      EasyLoading.showSuccess(
        'Verify success',
        maskType: EasyLoadingMaskType.clear,
      );
    } else {
      EasyLoading.showError(
        'Verify fail',
        maskType: EasyLoadingMaskType.clear,
      );
    }
  }
}
