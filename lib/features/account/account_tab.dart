import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fresh_fruit/extension/ContainerUIExt.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:provider/provider.dart';

import '../../model/address/AddressModel.dart';
import '../../route/AppRoute.dart';
import '../check_out/address/DeliveryAddressScreen.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({Key? key}) : super(key: key);

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 38),
              _buildItem(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoute.deliveryAddressScreen,
                    arguments: DeliveryAddressScreenParams(
                      onChangedAddressCallback: (AddressModel address) async {},
                    ),
                  );
                },
                title: locale.language.CHECK_OUT_SCREEN_DELIVERY_ADDRESS,
                subTitle: userViewModel
                        .currentUser?.currentAddress?.getDisplayAddress ??
                    "chưa có",
                icon: Icons.location_on,
              ),
              const SizedBox(height: 10),
              _buildItem(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoute.updateProfileScreen);
                },
                title: locale.language.UPDATE_PROFILE_TITLE,
                subTitle: locale.language.UPDATE_PROFILE_SUBTITLE,
                assetPath: AppImageAsset.icUserEdit,
              ),
              const SizedBox(height: 10),
              _buildItem(
                onTap: () {},
                title: locale.language.RESET_PASSWORD_TITLE,
                subTitle: locale.language.RESET_PASSWORD_SUBTITLE,
                assetPath: AppImageAsset.icResetPassword,
              ),
              const SizedBox(height: 10),
              _buildItem(
                onTap: () {
                  userViewModel.logOut();
                },
                title: locale.language.LOG_OUT_TITLE,
                subTitle: locale.language.LOG_OUT_SUBTITLE,
                icon: Icons.exit_to_app,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem({
    required Function onTap,
    required String title,
    required String subTitle,
    IconData? icon,
    String? assetPath,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(AppDimen.space16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.grey, width: 1),
        ),
        child: Row(
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: 25,
                    color: AppColor.primary,
                  )
                : SvgPicture.asset(
                    assetPath ?? '',
                    width: 25,
                    height: 25,
                    color: AppColor.primary,
                  ),
            const SizedBox(width: 24.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  const SizedBox(width: 3),
                  Text(
                    subTitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColor.textGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
