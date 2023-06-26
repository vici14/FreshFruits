import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fresh_fruit/base/BaseProviderScreenState.dart';
import 'package:fresh_fruit/features/check_out/CheckOutController.dart';
import 'package:fresh_fruit/features/check_out/address/DeliveryAddressScreen.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/route/AppRoute.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/utils/CurrencyFormatter.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/view_model/CartViewModel.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/PrimaryButton.dart';
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
    extends BaseProviderScreenState<CheckOutScreen, CheckOutController> {
  late UserViewModel userViewModel;

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.refreshCurrentUser();
    super.initState();
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
  CheckOutController initLocalController() {
    return CheckOutController();
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
                  _buildMethodItem(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoute.deliveryAddressScreen,
                                arguments: DeliveryAddressScreenParams(
                                    onChangedAddressCallback:
                                        (AddressModel address) async {
                          if (userVM.currentUser?.currentAddress != null &&
                              !localState.isCalculatingAddress) {
                            await localState.calculateShippingDistance(address);
                            if (localState.shippingDetail != null) {
                              cartVM.updateCartShippingDetail(
                                  localState.shippingDetail!);
                            }
                          }
                        }));
                      },
                      title: locale.language.CHECK_OUT_SCREEN_DELIVERY_ADDRESS,
                      value: userVM.currentUser?.currentAddress != null
                          ? userVM
                              .currentUser!.currentAddress!.getDisplayAddress
                          : locale.language.DELIVERY_ADDRESSES_EMPTY),
                  _buildMethodItem(
                      onTap: () {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15)),
                            ),
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: TimePickerSpinner(
                                  time: localState.deliveryTime,
                                  is24HourMode: false,
                                  onTimeChange: (time) async {
                                    var now = DateTime.now();

                                    AppLogger.i('onTimeChanged:${time} '
                                        '---now:${now} --- isAfter${time.isAfter(now)}');
                                    // AppLogger.i('isAfter:${time.isAfter(now)}');
                                    if (time.isAfter(now)) {
                                      AppLogger.i('isAfter:${time}');

                                      localState.deliveryTime = time;

                                      ///todo: recheck this function call gg
                                      ///api too much
                                      if (userVM.currentUser?.currentAddress !=
                                              null &&
                                          localState.deliveryTime != null &&
                                          !localState.isCalculatingAddress &&
                                          localState.shippingDetail?.distance ==
                                              null) {
                                        await localState
                                            .calculateShippingDistance(userVM
                                                .currentUser!.currentAddress!);
                                        if (localState.shippingDetail != null) {
                                          cartVM.updateCartShippingDetail(
                                              localState.shippingDetail!);
                                        }
                                      }
                                    }
                                  },
                                ),
                              );
                            });
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
                          builder: (context) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                              ));
                    },
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildSubmitButton(
                totalCost: 0,
                cartViewModel: cartVM,
                localState: localState,
                userViewModel: userVM),
          )
        ]);
      },
    );
  }

  Widget _buildInformation() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Icon(
          Icons.info_outline,
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
    );
  }

  Widget _buildPaymentAndShipping(
      CheckOutController localState, CartViewModel cartViewModel,
      {required Function() onTap}) {
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
            Text(
              '${localState.shippingDetail?.distance?.text ?? ""} - '
              '${CurrencyFormatter().toDisplayValue(localState.shippingDetail?.totalShippingPrice)}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColor.secondary),
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

  Widget _buildMethodItem(
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

  Widget _buildSubmitButton(
      {required CartViewModel cartViewModel,
      required UserViewModel userViewModel,
      required CheckOutController localState,
      required double totalCost}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimen.space16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInformation(),
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
            child: PrimaryButton(
              text: locale.language.BUTTON_CONFIRM,
              onTap: () {
                cartViewModel.checkOutCart(
                    uid: userViewModel.currentUser?.uid ?? "",
                    note: "",
                    customerName: userViewModel.currentUser?.name ?? "",
                    customerPhone: userViewModel.currentUser?.phone ?? "",
                    orderCheckoutTime: DateTime.now(),
                    totalCost: totalCost,
                    shippingDetail: localState.shippingDetail!,
                    addressModel: userViewModel.currentUser!.currentAddress!,
                    deliveryTime: localState.deliveryTime!,
                    paymentMethod: localState.paymentMethod);

                // else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content:
                //           Text('Đã đăng ký thành công, bạn hãy đăng nhập!'),
                //     ),
                //   );
                // }
              },
            ),
          )
        ],
      ),
    );
  }
}
