import 'package:flutter/material.dart';
import 'package:fresh_fruit/base/BaseProviderScreenState.dart';
import 'package:fresh_fruit/features/check_out/CheckOutController.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/route/AppRoute.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/widgets/button/PrimaryButton.dart';

import '../../theme/AppColor.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() {
    return _CheckOutScreenState();
  }
}

class _CheckOutScreenState
    extends BaseProviderScreenState<CheckOutScreen, CheckOutController> {
  @override
  String appBarTitle() {
    return locale.language.CHECK_OUT_SCREEN_HEADER;
  }

  @override
  bool enableBackButton() {
    return true;
  }

  @override
  bool enableSafeAreaBottom() {
    return true;
  }

  @override
  CheckOutController initLocalController() {
    return CheckOutController();
  }

  @override
  Color? setBackgroundColor() {
    return AppColor.greyScaffoldBackground;
  }

  @override
  Widget buildContent(BuildContext context, CheckOutController localState) {
    return Stack(children: [
      Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimen.space16, vertical: AppDimen.space16),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMethodItem(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoute
                        .addDeliveryAddressScreen);
                  },
                  title: locale.language.CHECK_OUT_SCREEN_DELIVERY_ADDRESS,
                  value: '2464 Royal Ln. Mesa, New Jersey 45463'),
              _buildMethodItem(
                  onTap: () {},
                  title: locale.language.CHECK_OUT_SCREEN_DELIVERY_METHOD,
                  value: 'Standard Delivery ( + 2.99 )'),
              _buildMethodItem(
                  onTap: () {},
                  title: locale.language.CHECK_OUT_SCREEN_SHIPPING_TIME,
                  value: '2464 Royal Ln. Mesa, New Jersey 45463'),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: _buildSubmitButton(totalCost: 0),
      )
    ]);
  }

  Widget _buildInformation() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Icon(
          Icons.info_outline,
          color: AppColor.secondary,
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            locale.language.CHECK_OUT_SCREEN_SHIPPING_INFORMATION,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: AppColor.textGrey,
                fontStyle: FontStyle.italic),
          ),
        )
      ],
    );
  }

  Widget _buildMethodItem(
      {required String title,
      required String value,
      required Function() onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.only(top: 18, left: 27, bottom: 25),
        margin: const EdgeInsets.only(bottom: AppDimen.space12),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: AppDimen.space8,
            ),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColor.textGrey),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton({required double totalCost}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimen.space16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInformation(),
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimen.space16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.language.CART_TOTAL,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  CurrencyFormatter().toDisplayValue(totalCost, currency: "đ"),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColor.secondary),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimen.space16),
            child: PrimaryButton(
                text: locale.language.BUTTON_CONFIRM, onTap: () {}),
          )
        ],
      ),
    );
  }
}
