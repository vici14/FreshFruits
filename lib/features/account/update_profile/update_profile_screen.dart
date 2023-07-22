import 'package:flutter/material.dart';
import 'package:fresh_fruit/base/BaseProviderScreenState.dart';
import 'package:fresh_fruit/features/account/update_profile/update_profile_controller.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/PrimaryButton.dart';
import 'package:fresh_fruit/widgets/textfield/common_textfield.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends BaseProviderScreenState<
    UpdateProfileScreen, UpdateProfileController> {
  UserViewModel? userViewModel;
  TextEditingController nameCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userViewModel = Provider.of<UserViewModel>(context, listen: false);
      if (userViewModel?.currentUser != null) {
        nameCtl.text = userViewModel?.currentUser?.name ?? '';
      }
    });
  }

  @override
  initLocalController() {
    return UpdateProfileController();
  }

  @override
  String appBarTitle() => '';

  @override
  Widget buildContent(BuildContext context, localState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImageAsset.manager,
              height: 98,
            ),
            const SizedBox(height: 26),
            Text(
              locale.language.UPDATE_PROFILE_TITLE,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              locale.language.UPDATE_PROFILE_SUBTITLE,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColor.textGrey,
              ),
            ),
            const SizedBox(height: 35),
            CommonTextField(
              controller: nameCtl,
              labelText: locale.language.USERNAME,
            ),
            PrimaryButton(text: 'Cập nhật', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
