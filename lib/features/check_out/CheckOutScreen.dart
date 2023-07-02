import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fresh_fruit/FreshFruitsApp.dart';
import 'package:fresh_fruit/base/BaseProviderScreenState.dart';
import 'package:fresh_fruit/features/check_out/CheckOutController.dart';
import 'package:fresh_fruit/features/check_out/address/DeliveryAddressScreen.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:fresh_fruit/model/ShippingDetailModel.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/route/AppRoute.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/theme/AppImageAsset.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/utils/PermissionUtil.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/view_model/CartViewModel.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/OnPrimaryTextButton.dart';
import 'package:fresh_fruit/widgets/button/PrimaryButton.dart';
import 'package:fresh_fruit/widgets/button/SecondaryButton.dart';
import 'package:fresh_fruit/widgets/common/CommonCircularLoading.dart';
import 'package:fresh_fruit/widgets/common/CommonIconButton.dart';
import 'package:provider/provider.dart';

import '../../theme/AppColor.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() {
    return _CheckOutScreenState();
  }
}

class _CheckOutScreenState
    extends BaseProviderScreenState<CheckOutScreen, CheckOutController>
    with TickerProviderStateMixin {
  late UserViewModel userViewModel;
  late CartViewModel cartViewModel;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    cartViewModel.resetDistance();
    userViewModel.refreshCurrentUser();
    super.initState();
  }

  @override
  CheckOutController initLocalController() {
    return CheckOutController(this);
  }

  @override
  String appBarTitle() {
    return locale.language.CHECK_OUT_SCREEN_HEADER;
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
  Color? setBackgroundColor() {
    return AppColor.greyScaffoldBackground;
  }




  @override
  Widget buildContent(BuildContext context, CheckOutController localState) {
    return Consumer2<UserViewModel, CartViewModel>(
      builder: (context, userVM, cartVM, child) {
        return Stack(children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimen.space16, vertical: AppDimen.space16),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddress(
                    cartVM: cartVM,
                    localState: localState,
                    userVM: userVM,
                  ),
                  _buildTimeSelect(
                      onTap: () {
                        showTimeBottomPicker(localState, userVM);
                      },
                      title: locale.language.CHECK_OUT_SCREEN_SHIPPING_TIME,
                      value: localState.deliveryTime != null
                          ? StringUtils()
                              .displayDateTime(localState.deliveryTime)
                          : locale.language.DELIVERY_TIME),
                  _buildPaymentAndShipping(
                    localState,
                    cartVM,
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15)),
                          ),
                          builder: (context) =>
                              _buildSelectPaymentMethod(localState));
                    },
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildSubmitButton(
                cartViewModel: cartVM,
                localState: localState,
                userViewModel: userVM),
          ),
          if (localState.isCalculatingAddress)
            const Align(
              alignment: Alignment.center,
              child: CommonCircularLoading(),
            )
        ]);
      },
    );
  }

  Widget _buildSelectPaymentMethod(CheckOutController localState) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 42,
          child: TabBar(
            controller: localState.tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: false,
            indicator: UnderlineTabIndicator(
              // borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                width: 2.0,
                color: hexToColor('#A6CE3B'),
              ),
            ),
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 45),
            labelColor: Colors.black,
            // dividerColor: Colors.transparent,
            tabs: [
              Tab(text: PaymentMethod.COD.toJson()),
              Tab(text: PaymentMethod.MOMO.toContent()),
              Tab(text: PaymentMethod.BANKING.toContent()),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: localState.tabController,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.directions_bike_rounded,
                      size: 50,
                      color: AppColor.greenMain,
                    ),
                    Text(
                      PaymentMethod.COD.toContent(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
              ),
              _buildImageQr(
                  globalKey: localState.momoImageKey,
                  image: AppImageAsset.imgMomo,
                  localState: localState),
              _buildImageQr(
                  globalKey: localState.bankingImageKey,
                  image: AppImageAsset.imgTechcombank,
                  localState: localState),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageQr(
      {required String image,
      required GlobalKey globalKey,
      required CheckOutController localState}) {
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image,
                height: MediaQuery.of(context).size.height * 0.35),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimen.space20),
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
                    CurrencyFormatter().toDisplayValue(
                        cartViewModel.currentCart?.getTotalPrice,
                        currency: "đ"),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColor.secondary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SecondaryButton(
                onTap: () {
                  localState.saveLocalImage(globalKey);
                },
                text: locale.language.BUTTON_SAVE_IMAGE,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInformation() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.info_outline,
              size: 15,
              color: AppColor.secondary,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                locale.language.CHECK_OUT_SCREEN_SHIPPING_INFORMATION,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: AppColor.textGrey,
                    fontStyle: FontStyle.italic),
              ),
            )
          ],
        ),
      ],
    );
  }

  void showTimeBottomPicker(
    CheckOutController localState,
    UserViewModel userVM,
  ) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: TimePickerSpinner(
              time: localState.deliveryTime,
              is24HourMode: true,
              onTimeChange: (time) async {
                var now = DateTime.now();

                if (time.isAfter(now)) {
                  localState.deliveryTime = time;

                  if (userVM.currentUser?.currentAddress != null &&
                      localState.deliveryTime != null &&
                      !localState.isCalculatingAddress &&
                      localState.shippingDetail?.distance == null) {
                    await localState.calculateShippingDistance(
                        userVM.currentUser!.currentAddress!);
                  }
                  if (localState.shippingDetail != null) {
                    var _shipping = localState.shippingDetail!.copyWith(
                        shippingDiscount: localState.getShippingDiscount(
                            userViewModel.currentUser?.currentAddress,
                            localState.deliveryTime));
                    cartViewModel.updateCartShippingDetail(_shipping);
                  }
                }
              },
            ),
          );
        });
  }

  Widget _buildTimeSelect(
      {required String title,
      required String value,
      required Function() onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding:
            const EdgeInsets.only(top: 18, left: 27, bottom: 25, right: 27),
        margin: const EdgeInsets.only(bottom: AppDimen.space12),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: AppDimen.space8,
            ),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColor.textGrey),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddress(
      {required UserViewModel userVM,
      required CartViewModel cartVM,
      required CheckOutController localState}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoute.deliveryAddressScreen,
          arguments: DeliveryAddressScreenParams(
            onChangedAddressCallback: (AddressModel address) async {
              if (userVM.currentUser?.currentAddress != null &&
                  !localState.isCalculatingAddress) {
                await localState.calculateShippingDistance(address);
              }
              if (localState.shippingDetail != null) {
                cartVM.updateCartShippingDetail(localState.shippingDetail!
                    .copyWith(
                        shippingDiscount: localState.getShippingDiscount(
                            userViewModel.currentUser?.currentAddress,
                            localState.deliveryTime)));
              }
            },
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(top: 18, left: 27, bottom: 25, right: 27),
        margin: const EdgeInsets.only(bottom: AppDimen.space12),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.language.CHECK_OUT_SCREEN_DELIVERY_ADDRESS,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: AppDimen.space8,
            ),
            Text(
              userVM.currentUser?.currentAddress != null
                  ? userVM.currentUser!.currentAddress!.getDisplayAddress
                  : locale.language.DELIVERY_ADDRESSES_EMPTY,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColor.textGrey),
            ),
            const SizedBox(
              height: AppDimen.space8,
            ),
            EasyRichText(
              '${locale.language.CHECKOUT_SUGGEST_DESTINATION}${localState.originDestination ?? ""}',
              patternList: [
                EasyRichTextPattern(
                  targetString:
                  '${localState.originDestination ?? ""}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColor.secondary),
                ),  EasyRichTextPattern(
                  targetString:
                  '${locale.language.CHECKOUT_SUGGEST_DESTINATION}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentAndShipping(
      CheckOutController localState, CartViewModel cartViewModel,
      {required Function() onTap}) {
    bool hasDiscount = localState.getShippingDiscount(
            userViewModel.currentUser?.currentAddress,
            localState.deliveryTime) !=
        null;
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding:
            const EdgeInsets.only(top: 18, left: 27, bottom: 25, right: 27),
        margin: const EdgeInsets.only(bottom: AppDimen.space12),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.language.CHECK_OUT_SCREEN_DELIVERY_AND_PAYMENT,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: AppDimen.space8,
            ),
            Row(
              children: [
                EasyRichText(
                  '${localState.shippingDetail?.distance?.text ?? ""} - ',
                  patternList: [
                    EasyRichTextPattern(
                      targetString:
                          '${localState.shippingDetail?.distance?.text ?? ""}'
                          ' - ',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColor.secondary),
                    ),
                  ],
                ),
                EasyRichText(
                  CurrencyFormatter().toDisplayValue(
                      localState.shippingDetail?.totalShippingPrice),
                  patternList: [
                    EasyRichTextPattern(
                      targetString: CurrencyFormatter().toDisplayValue(
                          localState.shippingDetail?.totalShippingPrice),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColor.secondary),
                    ),
                    if (hasDiscount)
                      EasyRichTextPattern(
                        targetString: CurrencyFormatter().toDisplayValue(
                            localState.shippingDetail?.totalShippingPrice),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColor.secondary,
                            decoration: TextDecoration.lineThrough),
                      ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                if (hasDiscount)
                  EasyRichText(
                    CurrencyFormatter().toDisplayValue(cartViewModel
                        .currentCart?.shippingDetail?.totalShippingPrice),
                    patternList: [
                      EasyRichTextPattern(
                        targetString: CurrencyFormatter().toDisplayValue(
                            cartViewModel.currentCart?.shippingDetail
                                ?.totalShippingPrice),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColor.secondary),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(
              height: AppDimen.space8,
            ),
            Text(localState.paymentMethod.toContent(),
                style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton({
    required CartViewModel cartViewModel,
    required UserViewModel userViewModel,
    required CheckOutController localState,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimen.space16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          localState.getShippingDiscount(
                      userViewModel.currentUser?.currentAddress,
                      localState.deliveryTime) ==
                  null
              ? _buildInformation()
              : _buildPromoText(localState.getShippingDiscount(
                  userViewModel.currentUser?.currentAddress,
                  localState.deliveryTime)!),
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimen.space8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.language.CHECK_OUT_SCREEN_CART_TOTAL,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  CurrencyFormatter().toDisplayValue(
                      cartViewModel.currentCart?.allProductsPrice,
                      currency: "đ"),
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
                  CurrencyFormatter().toDisplayValue(
                      cartViewModel.currentCart?.getTotalPrice,
                      currency: "đ"),
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
            child: PrimaryButton(
              text: locale.language.BUTTON_CONFIRM,
              isLoading: cartViewModel.isCheckingOut,
              onTap: () async {
                bool isSuccess = await cartViewModel.checkOutCart(
                    uid: userViewModel.currentUser?.uid ?? "",
                    note: "",
                    customerName: userViewModel.currentUser?.name ?? "",
                    customerPhone: userViewModel.currentUser?.phone ?? "",
                    orderCheckoutTime: DateTime.now(),
                    shippingDetail: localState.shippingDetail!,
                    addressModel: userViewModel.currentUser!.currentAddress!,
                    deliveryTime: localState.deliveryTime!,
                    paymentMethod: localState.paymentMethod);
                if (isSuccess) {
                  showSuccessDialog();
                } else {
                  showFailedDialog();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPromoText(ShippingDiscount discount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimen.space8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              discount.toStringContent(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontStyle: FontStyle.italic, fontSize: 15),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.check,
            color: AppColor.greenMain,
          )
        ],
      ),
    );
  }

  void showSuccessDialog() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NavigatorState? navigator = navigatorKey.currentState;
      overlayEntry = _createOverlayEntry(context);
      navigator?.overlay?.insert(overlayEntry!);
    });
  }

  void hideDialog() {
    overlayEntry?.remove();
  }

  OverlayEntry _createOverlayEntry(BuildContext context,
      {bool isUseDialogBuilder = false}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 0,
          top: 0,
          width: screenWidth,
          height: screenHeight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage(AppImageAsset.imgBlurring))),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Image.asset(
                          AppImageAsset.imgOrderSuccess,
                          width: 240,
                          height: 240,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 58),
                        child: Column(
                          children: [
                            Text(
                              locale.language.ORDER_SUCCESS,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              locale.language.ORDER_SUCCESS_DESCRIPTION,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontSize: 15, color: AppColor.textGrey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: PrimaryButton(
                            text: locale.language.BUTTON_BACK_TO_HOME,
                            onTap: () {
                              hideDialog();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRoute.homeNavigationScreen,
                                  (route) => false);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showFailedDialog() {}
}
