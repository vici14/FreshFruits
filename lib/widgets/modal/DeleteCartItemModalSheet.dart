import 'package:flutter/material.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/widgets/button/OutLineSecondaryButton.dart';
import 'package:fresh_fruit/widgets/button/PrimaryButton.dart';

import '../button/SecondaryButton.dart';

class DeleteCartItemModalSheet extends StatelessWidget {
  static const horizontalPadding = 15.0;
  final OrderedProductModel product;
  final Function() onPositiveButtonPressed;
  final Function() onNegativeButtonPressed;

  const DeleteCartItemModalSheet(
      {Key? key,
      required this.product,
      required this.onNegativeButtonPressed,
      required this.onPositiveButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.language.DELETE_FROM_CART_TITLE(product.name??""),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                  flex: 1,
                  child: OutLineSecondaryButton(
                    onTap: onNegativeButtonPressed,
                    content: locale.language.BUTTON_CANCEL,
                  )),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                  flex: 1,
                  child: SecondaryButton(
                    onTap: onPositiveButtonPressed,
                      text: locale.language.BUTTON_CONTINUE,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
