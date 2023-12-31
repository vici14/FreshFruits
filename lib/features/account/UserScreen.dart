import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fresh_fruit/AppViewModel.dart';
import 'package:fresh_fruit/features/account/account_tab.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/utils/ValidationUtil.dart';
import 'package:fresh_fruit/widgets/common/LanguageSwitch.dart';

import '../../view_model/product_view_model.dart';
import '../../view_model/UserViewModel.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_drawer.dart';
import 'package:provider/provider.dart';

import '../order/OrderHistoryScreen.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() {
    return _UserScreenState();
  }
}

class _UserScreenState extends State<UserScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  ProductViewModel? _productViewModel;
  bool canUpdateProfile = false;
  late UserViewModel _userViewModel;
  late AppViewModel _appViewModel;

  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _appViewModel = Provider.of<AppViewModel>(context, listen: false);
    if (_userViewModel.currentUser != null) {
      canUpdateProfile = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _productViewModel = Provider.of<ProductViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            _buildCusInfo(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    const AccountTab(),
                    OrderHistoryScreen(),
                  ],
                ),
              ),
            ),
            // userVM.isLoggedIn
            //     ? _buildIntro(userVM)
            //     : const SizedBox.shrink(),
            // userVM.isLoggedIn
            //     ? _buildInputForm()
            //     : const SizedBox.shrink(),
            // _buildRegisterButton(onTap: () {
            //   userVM.signUpWithEmailAndPassword(
            //       email: email, password: password);
            // }),
            // _buildSignInButton(
            //   onTap: () async {
            //     canUpdateProfile = true;
            //
            //     var _resp = await userVM.signInWithEmailAndPassword(context,
            //         email: email, password: password);
            //     if (_resp) {
            //       _productViewModel?.getProductsAfterUserLoggedIn(
            //           userVM.currentUser!.favoriteProducts!);
            //       _productViewModel
            //           ?.updateCategoryProductsAfterUserLoggedIn(
            //               userVM.currentUser!.favoriteProducts!);
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildCusInfo() {
    return Consumer<UserViewModel>(
      builder: (BuildContext context, UserViewModel userVM, Widget? child) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(226, 225, 225, 0.25),
                blurRadius: 10,
                spreadRadius: 28,
              )
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 36),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(),
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hexToColor('#FBF4E4'),
                          width: 3.3,
                        ),
                        borderRadius: BorderRadius.circular(13.2),
                      ),
                      child: SvgPicture.asset(AppImageAsset.defaultAvatar),
                    ),
                    SizedBox(
                      height: 24,
                      width: 40,
                      child: LanguageSwitch(
                        onChange: _appViewModel.changeLanguage,
                        isVietnamese: _appViewModel.isVietnamese ?? true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              userVM.isLoggedIn
                  ? Text(
                      userVM.currentUser?.name ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: tertiarySeedColor,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 5),
              userVM.isLoggedIn
                  ? Text(
                      userVM.currentUser?.email ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: tertiarySeedColor,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 24),
              SizedBox(
                height: 42,
                child: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  isScrollable: false,
                  indicator: UnderlineTabIndicator(
                    // borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      width: 2.0,
                      color: hexToColor('#A6CE3B'),
                    ),
                  ),
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 45),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 29 / 14,
                    color: Colors.red,
                  ),
                  // dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: locale.language.ACCOUNT),
                    Tab(text: locale.language.HISTORY),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIntro(UserViewModel userVM) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Tài khoản :"),
            Text(userVM.currentUser?.email ?? '')
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 12),
          child: Text(
            "Đổi password",
            style: TextStyle(
                color: Colors.red, decoration: TextDecoration.underline),
          ),
        ),
        const Text(
          'Lưu thông tin của bạn để tự động điền trong thông tin '
          'đặt hàng',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  bool isValidate() {
    return _formKey.currentState!.validate();
  }

  Widget _buildRegisterButton({required Function()? onTap}) {
    return Consumer(
      builder: (BuildContext context, UserViewModel userVM, Widget? child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(12)),
            height: 52,
            child: Center(
              child: userVM.isSigningUp
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      "Đăng kí ",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignInButton({required Function()? onTap}) {
    return Consumer(
      builder: (BuildContext context, UserViewModel userVM, Widget? child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(12)),
            height: 52,
            child: userVM.isLoggingIn
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Center(
                    child: Text(
                      "Đăng Nhập",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildCustomButton(
      {required String title, required Function()? onTap}) {
    return Consumer<UserViewModel>(
      builder: (BuildContext context, UserViewModel userVM, Widget? child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(12)),
            height: 52,
            child: Center(
              child: (userVM.isUpdatingProfile)
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
        );
      },
    );
  }
}
