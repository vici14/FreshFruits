import 'package:flutter/material.dart';
import 'package:fresh_fruit/utils/ValidationUtil.dart';

import '../../view_model/product_view_model.dart';
import '../../view_model/UserViewModel.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() {
    return _UserScreenState();
  }
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  ProductViewModel? _productViewModel;
  bool canUpdateProfile = false;
  late UserViewModel _userViewModel;

  @override
  void initState() {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (_userViewModel.currentUser != null) {
      canUpdateProfile = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    String email = 'cuongchau19@gmail.com';
    String password = '123456789';
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: MyDrawer(),
        appBar: const CommonAppBar(
          title: "Tài khoản",
        ),
        body: Consumer<UserViewModel>(
          builder: (BuildContext context, UserViewModel userVM, Widget? child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    userVM.isLoggedIn
                        ? _buildIntro(userVM)
                        : const SizedBox.shrink(),
                    userVM.isLoggedIn
                        ? _buildInputForm()
                        : const SizedBox.shrink(),
                    _buildRegisterButton(onTap: () {
                      userVM.signUpWithEmailAndPassword(
                          email: email, password: password);
                    }),
                    _buildSignInButton(
                      onTap: () async {
                        canUpdateProfile = true;

                        var _resp = await userVM.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (_resp) {
                          _productViewModel?.getProductsAfterUserLoggedIn(
                              userVM.currentUser!.favoriteProducts!);
                          _productViewModel
                              ?.updateCategoryProductsAfterUserLoggedIn(
                                  userVM.currentUser!.favoriteProducts!);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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

  Widget _buildInputForm() {
    return Consumer<UserViewModel>(
      builder: (BuildContext context, UserViewModel userVM, Widget? child) {
        if (userVM.isLoggedIn && canUpdateProfile) {
          _phoneController.text = userVM.currentUser!.phone!;
          _nameController.text = userVM.currentUser!.name!;
          _addressController.text = userVM.currentUser!.address!;
          canUpdateProfile = false;
        }
        return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      border: Border.all(width: 1, color: Colors.green)),
                  child: TextFormField(
                    validator: (val) => ValidationUtil.isNotNullOrEmpty(val),
                    controller: _nameController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        hintText: "Họ và tên ",
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      border: Border.all(width: 1, color: Colors.green)),
                  child: TextFormField(
                    validator: (val) => ValidationUtil.isNotNullOrEmpty(val),
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        hintText: "Số điện thoại ",
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      border: Border.all(width: 1, color: Colors.green)),
                  child: TextFormField(
                    controller: _addressController,
                    validator: (val) => ValidationUtil.isNotNullOrEmpty(val),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        hintText: "Địa chỉ người nhận ",
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                _buildCustomButton(
                    onTap: () {
                      canUpdateProfile = true;
                      if (isValidate()) {
                        userVM.updateProfile(
                            name: _nameController.text,
                            phone: _phoneController.text,
                            address: _addressController.text);
                      }
                      canUpdateProfile = false;
                      setState(() {});
                    },
                    title: "Cập nhật thông tin"),
              ],
            ));
      },
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
