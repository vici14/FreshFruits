import 'package:flutter/material.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';

extension ShadowContainer on Container {
  Container addShadow() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: AppColor.grey,
                spreadRadius: 0.8,
                blurRadius: 1,
                offset: Offset(0, 1.2)),
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.grey, width: 1)),
      child: this,
    );
  }
}

class CommonIconButton {
  final Function? onTap;

  const CommonIconButton({
    required this.onTap,
  });

  Widget buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        child: Center(
          child: SvgPicture.asset(
            AppImageAsset.iconBack,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ).addShadow(),
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
      ).addShadow(),
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
      ).addShadow(),
    );
  }
}
