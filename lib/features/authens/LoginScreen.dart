import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fresh_fruit/features/authens/OTPVerifyScreen.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/PrimaryButton.dart';
import 'package:fresh_fruit/widgets/textfield/common_textfield.dart';
import 'package:provider/provider.dart';

import '../../utils/ValidationUtil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserViewModel? userViewModel;

  TextEditingController? phoneController;
  bool isPhoneNumberValid = false;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userViewModel = Provider.of<UserViewModel>(context, listen: false);
    });
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 32),
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
                Text(
                  _phoneError ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red),
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
    _phoneError = ValidationUtil.isValidPhone(phoneController?.text ?? "");
    if (!StringUtils.isNotNullAndEmpty(_phoneError)) {
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
                  ),
                );
              });
        },
      );
      if (_userLoggedIn != null) {
        // Navigator.of(context).pop();
      }
    }
  }
}
