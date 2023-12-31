import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_fruit/base/BaseProviderScreenState.dart';
import 'package:fresh_fruit/features/cart/CartController.dart';
import 'package:fresh_fruit/features/product_detail/ProductDetailScreen.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/route/AppRoute.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/view_model/CartViewModel.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/SecondaryButton.dart';
import 'package:fresh_fruit/widgets/common/CommonIconButton.dart';
import 'package:fresh_fruit/widgets/image/ImageCachedNetwork.dart';
import 'package:fresh_fruit/widgets/modal/DeleteCartItemModalSheet.dart';
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
        return StreamBuilder(
          stream: _stream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<OrderedProductModel>> snap) {
            List<OrderedProductModel> list = List.generate(
                snap.data?.docs.length ?? 0,
                (index) => snap.data!.docs[index].data()).toList();
            if (!snap.hasData) {
              return const Center(child: Text("Empty Cart"));
            }
            if (list.isEmpty) {
              return Center(
                child: Text(locale.language.CART_EMPTY_TEXT),
              );
            }
            return Stack(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimen.space16),
                    child: _buildProductsList(list, cartVM)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildSubmitButton(
                      totalCost: StringUtils.calculateTotalCost(list),
                      cartViewModel: cartVM,
                      items: list),
                ),
                cartVM.isUpdatingProductQuantity
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.secondary,
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSubmitButton({
    required CartViewModel cartViewModel,
    required double totalCost,
    required List<OrderedProductModel> items,
  }) {
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
            child: SecondaryButton(
                text: locale.language.BUTTON_NEXT,
                onTap: () {
                  if (items.isNotEmpty) {
                    cartViewModel.updateOrderedProducts(items);
                    Navigator.of(context).pushNamed(AppRoute.checkoutScreen);
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _buildProductsList(
      List<OrderedProductModel>? items, CartViewModel cartVM) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: items?.length ?? 0,
        itemBuilder: (context, index) =>
            _buildProductItem(items![index], cartVM));
  }

  Widget _buildProductItem(OrderedProductModel item, CartViewModel cartVM) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 28),
          padding: const EdgeInsets.only(right: 25),
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
                  imageUrl: item.avatar ?? "",
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
                          onTap: () async {
                            if (item.quantity > 1) {
                              cartVM.updateQuantity(
                                  productModel:
                                      item.updateQuantity(--item.quantity),
                                  uid: _userViewModel.currentUser?.uid ?? '');
                            } else {
                              await showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteCartItemModalSheet(
                                    product: item,
                                    onNegativeButtonPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    onPositiveButtonPressed: () {
                                      _cartViewModel.deleteFromCart(
                                          productModel: item,
                                          uid:
                                              _userViewModel.currentUser?.uid ??
                                                  "");
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              );
                            }
                          },
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(item.quantity.toString()),
                        ),
                        InkWell(
                          onTap: () {
                            cartVM.updateQuantity(
                                productModel:
                                    item.updateQuantity(++item.quantity),
                                uid: _userViewModel.currentUser?.uid ?? '');
                          },
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
            top: 14,
            right: 23,
            child: IconButton(
              icon: const Icon(
                Icons.info_outlined,
                size: 25,
                color: AppColor.secondary,
              ),
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                        initialChildSize: 0.5,
                        maxChildSize: 0.8, // full screen on scroll
                         builder: (BuildContext context,
                            ScrollController scrollController) {
                          return ProductDetailScreen(
                            args: ProductDetailScreenArgs(
                                ProductModel.fromOrderedProductModel(
                                    product: item),
                                scrollController: scrollController,
                                asModal: true),
                          );
                        });
                  },
                );
              },
            ))
      ],
    );
  }
}
