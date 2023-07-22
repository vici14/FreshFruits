import 'package:flutter/material.dart';
import 'package:fresh_fruit/extension/ContainerUIExt.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';

class CommonIconButton {
  final Function? onTap;

  const CommonIconButton({
    required this.onTap,
  });

  static Widget buildBackButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColor.seashell,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: SvgPicture.asset(
            AppImageAsset.iconBack,
            color: AppColor.metallicOrange,
          ),
        ),
      ),
    );
  }

  static Widget buildLocationButton(BuildContext context, Function() onTap) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 36,
        width: 36,
        child: const Center(
          child: Icon(
            Icons.location_on,
            color: AppColor.primary,
          ),
        ),
      ).addWhiteBoxShadow(),
    );
  }

  Widget buildFilterButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        child: Center(
          child: SvgPicture.asset(
            AppImageAsset.iconFilter,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ).addWhiteBoxShadow(),
    );
  }

  Widget buildNotificationButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        child: Center(
          child: SvgPicture.asset(
            AppImageAsset.iconNotification,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ).addWhiteBoxShadow(),
    );
  }

  static Widget buildCartItemDeleteButton(
      BuildContext context, Function onTap) {
    return InkWell(
      onTap: () => onTap,
      child: Container(
        height: 36,
        width: 36,
        child: Center(
          child: SvgPicture.asset(
            AppImageAsset.iconCartItemDelete,
            color: AppColor.secondary,
          ),
        ),
      ).addWhiteBoxShadow(),
    );
  }
}
