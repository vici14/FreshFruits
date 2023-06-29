import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/base/BaseProviderScreenState.dart';
import 'package:fresh_fruit/extension/ContainerUIExt.dart';
import 'package:fresh_fruit/features/check_out/address/DeliveryAddressController.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/route/AppRoute.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/SecondaryButton.dart';
import 'package:fresh_fruit/widgets/common/CommonCircularLoading.dart';
import 'package:provider/provider.dart';

class DeliveryAddressScreenParams {
  final Function(AddressModel) onChangedAddressCallback;

  DeliveryAddressScreenParams({required this.onChangedAddressCallback});
}

class DeliveryAddressScreen extends StatefulWidget {
  final DeliveryAddressScreenParams params;

  const DeliveryAddressScreen({super.key, required this.params});

  @override
  State<DeliveryAddressScreen> createState() {
    return _DeliveryAddressScreenState();
  }
}

class _DeliveryAddressScreenState extends BaseProviderScreenState<
    DeliveryAddressScreen, DeliveryAddressController> {
  late UserViewModel userViewModel;

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.refreshCurrentUser();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userViewModel.refreshCurrentUser();
    super.didChangeDependencies();
  }

  @override
  String appBarTitle() {
    return locale.language.DELIVERY_ADDRESS_HEADER;
  }

  @override
  bool enableBackButton() {
    return true;
  }

  @override
  Color? setBackgroundColor() {
    return AppColor.greyScaffoldBackground;
  }

  @override
  bool enableSafeAreaBottom() {
    return true;
  }

  @override
  DeliveryAddressController initLocalController() {
    return DeliveryAddressController();
  }

  @override
  Widget buildContent(
      BuildContext context, DeliveryAddressController localState) {
    return Consumer<UserViewModel>(
      builder: (context, userVM, child) {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: (userVM.currentUser?.addresses?.isEmpty == true)
                  ? Center(
                      child: Text(
                        locale.language.DELIVERY_ADDRESSES_EMPTY,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColor.textGrey),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(AppDimen.space16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCurrentAddress(
                              userVM.currentUser?.currentAddress),
                          _listAddress(userVM.currentUser?.addresses ?? [])
                        ],
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(AppDimen.space16),
                child: SecondaryButton(
                  text: locale.language.BUTTON_ADD_ADDRESS,
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoute.addDeliveryAddressScreen);
                  },
                ),
              ),
            ),
            userVM.isAddingAddress
                ? const Center(child: CommonCircularLoading())
                : const SizedBox.shrink()
          ],
        );
      },
    );
  }

  Widget _buildCurrentAddress(AddressModel? addressModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                locale.language.DELIVERY_ADDRESS_CURRENT,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              _buildAddressItem(addressModel, isCurrent: true)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressItem(AddressModel? addressModel,
      {bool isCurrent = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: !isCurrent ? AppDimen.space16 : 0),
      child: GestureDetector(
        onTap: () {
          if (!isCurrent) {
            userViewModel.updateCurrentShippingDetail(addressModel,() {
              widget.params.onChangedAddressCallback(addressModel!);

              Navigator.of(context).pop();
            },);
            // Navigator.of(context).pop();
          }
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimen.space16),
              child: EasyRichText(
                addressModel?.getDisplayAddress ?? "",
                defaultStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColor.textGrey),
                patternList: [],
              ),
            ).addWhiteBoxShadow(),
          ],
        ),
      ),
    );
  }

  Widget _listAddress(List<AddressModel> addresses) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                locale.language.DELIVERY_ADDRESSES,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              ...List.generate(addresses.length,
                  (index) => _buildAddressItem(addresses[index]))
            ],
          ),
        ),
      ],
    );
  }
}
