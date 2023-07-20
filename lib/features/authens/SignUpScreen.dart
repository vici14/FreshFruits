import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/utils/ValidationUtil.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/PrimaryButton.dart';
import 'package:fresh_fruit/widgets/textfield/common_textfield.dart';
import 'package:provider/provider.dart';

import 'OTPVerifyScreen.dart';

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
  TextEditingController? phoneController;

  bool isPhoneNumberValid = false;
  bool showOTPField = false;
  bool isOTPVerified = false;

  String? _phoneError;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userViewModel = Provider.of<UserViewModel>(context, listen: false);
    });

    phoneController = TextEditingController();
    signUpNameCtl = TextEditingController();
  }

  @override
  void dispose() {
    phoneController?.dispose();
    signUpNameCtl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              CommonTextField(
                controller: signUpNameCtl ?? TextEditingController(),
                labelText: locale.language.USERNAME,
              ),
              if (_nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top:AppDimen.space16),

                  child: Text(
                    _nameError ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 21),
              CommonTextField(
                controller: phoneController ?? TextEditingController(),
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
              if (_phoneError != null)
                Padding(
                  padding: const EdgeInsets.only(top:AppDimen.space16),
                  child: Text(
                    _phoneError ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 51),
              PrimaryButton(
                text: locale.language.SIGNUP,
                onTap: () => onSignupClick(context),
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
      },
    );
  }

  void onSignupClick(BuildContext context) async {

    _phoneError = ValidationUtil.isValidPhone(phoneController?.text ?? "");
    _nameError = ValidationUtil.validateFullName(signUpNameCtl?.text ?? "");
    if (!StringUtils.isNotNullAndEmpty(_phoneError) &&
        !StringUtils.isNotNullAndEmpty(_nameError)) {
      var _userLoggedIn = await showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        ),
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.5,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return ChangeNotifierProvider.value(
                  value: userViewModel,
                  child: OTPVerifyScreen(
                    phoneNumber: phoneController!.text.trim(),
                    name: signUpNameCtl?.text.trim(),
                  ),
                );
              });
        },
      );
      if (_userLoggedIn != null) {
        // Navigator.of(context).pop();
      }
    }
    setState((){

    });

    /* if (!isOTPVerified) {
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
    }*/
  }
}
