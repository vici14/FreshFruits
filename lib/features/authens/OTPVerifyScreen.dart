import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

import '../../language/LanguagesManager.dart';

const SECOND_COUNTDOWN = 120;

class OTPVerifyScreen extends StatefulWidget {
  final String phoneNumber;
  final String? name;

  const OTPVerifyScreen({
    super.key,
    required this.phoneNumber,
    this.name,
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
  int _currentSeconds = SECOND_COUNTDOWN;
  late Timer _timer;
  bool shouldRetry = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userViewModel = Provider.of<UserViewModel>(context, listen: false);
      _userViewModel?.verifyPhoneNumber(
          phoneNumber: widget.phoneNumber,
          name: widget.name,
          codeSentCallback: () {
            _startTimer();
          });
    });

    super.initState();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_currentSeconds < 1) {
          shouldRetry = true;
          _timer.cancel();
        } else {
          _currentSeconds--;
        }
      });
    });
  }

  void _restartTimer() {
    setState(() {
      shouldRetry = false;
      _currentSeconds = SECOND_COUNTDOWN;
    });
    _userViewModel?.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        name: widget.name,
        codeSentCallback: () {
          _startTimer();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userVM, child) {
        return Material(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimen.space16),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.language.OTP_VERIFYING,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 22),
                    ),
                    const SizedBox(
                      height: AppDimen.space16,
                    ),
                    Text(
                      locale.language.OTP_VERIFYING_INFO(StringUtils()
                          .getVietnamesePhoneNumber(widget.phoneNumber)),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: AppDimen.space16,
                    ),
                    userVM.isVerifyingPhone
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.greenMain,
                            ),
                          )
                        : PinCodeTextField(
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
                            pinBoxWidth: MediaQuery.of(context).size.width / 8,
                            pinBoxHeight: 64,
                            hasUnderline: true,
                            wrapAlignment: WrapAlignment.spaceAround,
                            pinBoxDecoration: ProvidedPinBoxDecoration
                                .defaultPinBoxDecoration,
                            pinTextStyle: TextStyle(fontSize: 22.0),
                            pinTextAnimatedSwitcherTransition:
                                ProvidedPinBoxTextAnimation.scalingTransition,
//                    pinBoxColor: Colors.green[100],
                            pinTextAnimatedSwitcherDuration:
                                Duration(milliseconds: 300),
//                    highlightAnimation: true,
                            highlightAnimationBeginColor: Colors.black,
                            highlightAnimationEndColor: Colors.white12,
                            keyboardType: TextInputType.number,
                          ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0.9,-0.9),
                child: shouldRetry
                    ? TextButton(
                        onPressed: () {
                          _restartTimer();
                        },
                        child: Text("Thử lại"))
                    : Text(
                        '${_currentSeconds}s',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
