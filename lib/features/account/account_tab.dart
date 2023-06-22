import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:provider/provider.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 38),
          _buildItem(
            onTap: () {},
            title: locale.language.PUSH_NOTIFICATION_TITLE,
            subTitle: locale.language.PUSH_NOTIFICATION_SUBTITLE,
            assetPath: AppImageAsset.iconNotification,
          ),
          _buildItem(
            onTap: () {},
            title: locale.language.ACCOUNT_PRIVACY_TITLE,
            subTitle: locale.language.ACCOUNT_PRIVACY_SUBTITLE,
            assetPath: AppImageAsset.iconLocker,
          ),
          _buildItem(
            onTap: () {},
            title: locale.language.FAQS_TITLE,
            subTitle: locale.language.FAQS_SUBTITLE,
            assetPath: AppImageAsset.iconFAQS,
          ),
          _buildItem(
            onTap: () {
             userViewModel.logOut();
            },
            title: locale.language.LOG_OUT_TITLE,
            subTitle: locale.language.LOG_OUT_SUBTITLE,
            assetPath: AppImageAsset.iconLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required Function onTap,
    required String title,
    required String subTitle,
    required String assetPath,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.only(
          left: 29,
          top: 18,
          bottom: 23,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              assetPath,
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 24.5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(width: 3),
                Text(subTitle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
