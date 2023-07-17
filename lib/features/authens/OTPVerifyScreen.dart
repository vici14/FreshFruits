import 'package:flutter/material.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

import '../../language/LanguagesManager.dart';

class OTPVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerifyScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OTPVerifyScreen> createState() {
    return _OTPVerifyScreenState();
  }
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 6;
  bool hasError = false;
  String? errorMessage;
  UserViewModel? _userViewModel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userViewModel = Provider.of<UserViewModel>(context, listen: false);
      _userViewModel?.verifyPhoneNumber(widget.phoneNumber);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(AppDimen.space16),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.language.OTP_VERIFYING,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
            ),
            const SizedBox(
              height: AppDimen.space16,
            ),
            Text(
              locale.language.OTP_VERIFYING_INFO(
                  StringUtils().getVietnamesePhoneNumber(widget.phoneNumber)),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: AppDimen.space16,
            ),
            PinCodeTextField(
              autofocus: true,
              controller: controller,
              hideCharacter: false,
              highlight: true,
              defaultBorderColor: Colors.black,
              hasTextBorderColor: AppColor.greenMain,
              maxLength: pinLength,
              hasError: hasError,
              onTextChanged: (text) {
                setState(() {
                  hasError = false;
                });
              },
              onDone: (String code) async {
                var _resp = await _userViewModel?.verifyOTP(code);
                if (_resp != null) {
                  _userViewModel?.refreshCurrentUser();
                  Navigator.of(context).pop(_resp);
                }
              },
              pinBoxWidth: 50,
              pinBoxHeight: 64,
              hasUnderline: true,
              wrapAlignment: WrapAlignment.spaceAround,
              pinBoxDecoration:
                  ProvidedPinBoxDecoration.defaultPinBoxDecoration,
              pinTextStyle: TextStyle(fontSize: 22.0),
              pinTextAnimatedSwitcherTransition:
                  ProvidedPinBoxTextAnimation.scalingTransition,
//                    pinBoxColor: Colors.green[100],
              pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
//                    highlightAnimation: true,
              highlightAnimationBeginColor: Colors.black,
              highlightAnimationEndColor: Colors.white12,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
