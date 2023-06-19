import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_fruit/base/BaseProviderScreenState.dart';
import 'package:fresh_fruit/features/cart/CartController.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/utils/ValidationUtil.dart';
import 'package:fresh_fruit/view_model/cart_viewmodel.dart';
import 'package:fresh_fruit/view_model/user_viewmodel.dart';
import 'package:fresh_fruit/widgets/button/SecondaryButton.dart';
import 'package:fresh_fruit/widgets/common/CommonIconButton.dart';
import 'package:fresh_fruit/widgets/image/ImageCachedNetwork.dart';
import 'package:fresh_fruit/widgets/my_app_bar.dart';
import 'package:fresh_fruit/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState
    extends BaseProviderScreenState<CartScreen, CartController> {
  double shipCost = 0;
  List<OrderedProductModel>? list;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  late CartViewModel _cartViewModel;
  late UserViewModel _userViewModel;
  Stream<QuerySnapshot<OrderedProductModel>>? _stream;

  @override
  void initState() {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    _stream = _cartViewModel
        .getCartItemStream(_userViewModel.currentUser?.uid ??
            ''
                '')
        .asBroadcastStream();

    super.initState();
  }

  @override
  initLocalController() {
    return CartController();
  }

  @override
  void didChangeDependencies() {
    if (_userViewModel.isLoggedIn) {
      _cartViewModel.getCart(_userViewModel.currentUser?.uid ?? '');
    }

    super.didChangeDependencies();
  }

  @override
  String appBarTitle() {
    return locale.language.CART_SCREEN_HEADER;
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
  Widget buildContent(BuildContext context, localState) {
    return Consumer<CartViewModel>(
      builder: (BuildContext context, CartViewModel cartVM, Widget? child) {
        if (!_userViewModel.isLoggedIn) {
          return Center(
            child: Text(locale.language.USER_NOT_LOGGED_IN),
          );
        }
        if (cartVM.isGetCart) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimen.space16),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const Text('Nhập tên và địa chỉ người nhận'),
                    // _buildInputForm(),
                    // const Text("Chi tiết đơn hàng"),
                    StreamBuilder(
                      stream: _stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<OrderedProductModel>>
                              snap) {
                        if (!snap.hasData) {
                          return const Center(child: Text("Empty Cart"));
                        }

                        List<OrderedProductModel> list = List.generate(
                            snap.data!.docs.length,
                            (index) => snap.data!.docs[index].data()).toList();
                        return Column(
                          children: [
                            _buildProductsList(list),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildSubmitButton(
                onTap: () async {
                  // bool isSuccess = await cartVM.checkOutCart(
                  //   totalCost:
                  //   StringUtils.calculateTotalCost(list),
                  //   products: list,
                  //   uid: _userViewModel.currentUser?.uid ?? '',
                  //   customerName: _nameController.text,
                  //   customerPhone: _phoneController.text,
                  //   customerAddress: _addressController.text,
                  // );
                  // if (isSuccess) {
                  //   _userViewModel.refreshCurrentUser();
                  // }
                },
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton({required Function()? onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimen.space16),
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                Text(CurrencyFormatter().toDisplayValue(0, currency: "đ")),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimen.space16),
            child: SecondaryButton(
                text: locale.language.BUTTON_NEXT, onTap: () {}),
          )
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return Consumer<UserViewModel>(
      builder: (BuildContext context, UserViewModel userVM, Widget? child) {
        if (userVM.isLoggedIn && userVM.currentUser != null) {
          _phoneController.text = userVM.currentUser?.phone ?? '';
          _nameController.text = userVM.currentUser?.name ?? '';
          _addressController.text = userVM.currentUser?.address ?? '';
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
                // _buildCustomButton(
                //     onTap: () {
                //       if (isValidate()) {
                //         userVM.updateProfile(
                //             name: _nameController.text,
                //             phone: _phoneController.text,
                //             address: _addressController.text);
                //       }
                //     },
                //     title: "Cập nhật thông tin"),
              ],
            ));
      },
    );
  }

  Widget _buildProductsList(List<OrderedProductModel>? items) {
    return Column(
      children: [
        ...List.generate(items!.length, (index) {
          var item = items[index];
          return _buildProductItem(item);
        })
      ],
    );
  }

  Widget _buildProductItem(OrderedProductModel item) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 28),
          padding: EdgeInsets.only(right: 25),
          height: 156,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColor.grey,
              ),
              color: Colors.white),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 32,
                ),
                child: ImageCachedNetwork(
                  imageUrl: item.imageUrl ?? "",
                  height: 65,
                  width: 70,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: AppDimen.space10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDimen.space12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: EasyRichText(
                              '${CurrencyFormatter().toDisplayValue(item.cost, currency: 'đ')}/${item.unit}',
                              patternList: [
                                EasyRichTextPattern(
                                  targetString: CurrencyFormatter()
                                      .toDisplayValue(item.cost, currency: 'đ'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: AppColor.secondary),
                                ),
                                EasyRichTextPattern(
                                  targetString: item.unit,
                                  style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppColor.textGrey),
                                ),
                              ],
                            ),

                          )
                        ],
                      ),
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(color: AppColor.grey)),
                              child: const Center(
                                child: Icon(Icons.remove),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(item.quantity.toString()),
                          ),
                          InkWell(
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(color: AppColor.grey)),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: AppColor.greenMain,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
            top: 14,
            right: 23,
            child: CommonIconButton.buildCartItemDeleteButton(context, () {}))
      ],
    );
  }
}
