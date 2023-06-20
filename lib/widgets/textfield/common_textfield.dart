import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_fruit/theme/AppColor.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? labelText;
  final String? placeholder;
  final bool password;
  final String? Function(String?)? validator;
  final void Function()? onCompleted;
  final bool isShowIcon;
  final String? Function(String?)? onChange;
  final bool autoValidate;
  final Decoration? customDecoration;
  final Widget? suffixIcon;
  final bool readOnly;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final EdgeInsets? scrollPadding;
  final EdgeInsets? contentPadding;
  final void Function(String)? onSubmit;
  final void Function(bool)? onFocusChange;
  final bool autoFocus;
  final TextInputAction? textInputAction;
  final int? maxLength;

  const CommonTextField({
    Key? key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.labelText,
    this.placeholder = '',
    this.password = false,
    this.validator,
    this.onCompleted,
    this.isShowIcon = false,
    this.onChange,
    this.suffixIcon,
    this.autoValidate = false,
    this.readOnly = false,
    this.suffixWidget,
    this.prefixWidget,
    this.focusNode,
    this.inputFormatters,
    this.errorText,
    this.scrollPadding,
    this.onSubmit,
    this.onFocusChange,
    this.customDecoration,
    this.contentPadding,
    this.autoFocus = false,
    this.textInputAction,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isHaveError = errorText == null || (errorText ?? '').isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText != null
            ? Text(
              labelText ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 29 / 14,
                color: hexToColor('#7C7C7C'),
              ),
            )
            : Container(),
        Container(
          height: 44,
          decoration: customDecoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              prefixWidget ?? Container(),
              Expanded(
                child: Focus(
                  onFocusChange: onFocusChange,
                  child: TextFormField(
                    maxLength: maxLength ?? 150,
                    scrollPadding: scrollPadding ?? const EdgeInsets.all(0),
                    autovalidateMode: autoValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: contentPadding ??
                          const EdgeInsets.fromLTRB(0, 8, 16, 12),
                      fillColor: Colors.transparent,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: placeholder,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 29 / 16,
                        color: hexToColor('#B1B1B1'),
                      ),
                      filled: true,
                      suffixIcon: suffixIcon,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: hexToColor('#E2E2E2'),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: hexToColor('#E2E2E2'),
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: hexToColor('#E2E2E2'),
                        ),
                      ),
                    ),
                    cursorWidth: 1.0,
                    controller: controller,
                    onEditingComplete: onCompleted,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 29 / 26,
                      color: hexToColor('#030303'),
                    ),
                    keyboardType: keyboardType,
                    obscureText: password,
                    autocorrect: false,
                    onChanged: onChange,
                    readOnly: readOnly,
                    focusNode: focusNode,
                    inputFormatters: inputFormatters,
                    onFieldSubmitted: onSubmit,
                    autofocus: autoFocus,
                    textInputAction: textInputAction,
                  ),
                ),
              ),
              suffixWidget ?? const SizedBox(),
            ],
          ),
        ),
        isHaveError
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  errorText ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                    color: hexToColor('#FF3B30'),
                  ),
                ),
              )
      ],
    );
  }
}
