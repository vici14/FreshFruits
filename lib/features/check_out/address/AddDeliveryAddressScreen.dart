import 'package:flutter/material.dart';
import 'package:fresh_fruit/base/BaseProviderScreenState.dart';
import 'package:fresh_fruit/extension/IterableExtension.dart';
import 'package:fresh_fruit/features/check_out/address/widgets/DropDownAddress.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/service/GoogleMapService.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/utils/PermissionUtil.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/SecondaryButton.dart';
import 'package:fresh_fruit/widgets/common/CommonCircularLoading.dart';
import 'package:fresh_fruit/widgets/common/CommonIconButton.dart';
import 'package:fresh_fruit/widgets/my_app_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';

import '../../../model/address/AddressModel.dart';
import '../../../model/address/AdressWards.dart';
import 'AddDeliveryAddressController.dart';
import 'package:provider/provider.dart';

class AddDeliveryAddressScreen extends StatefulWidget {
  @override
  State<AddDeliveryAddressScreen> createState() {
    return _AddDeliveryAddressScreenState();
  }
}

class _AddDeliveryAddressScreenState extends BaseProviderScreenState<
    AddDeliveryAddressScreen, AddDeliveryAddressController> {
  final GlobalKey<DropDownDistrictsState> districtKey =
      GlobalKey<DropDownDistrictsState>();
  final GlobalKey<DropDownWardsState> wardKey = GlobalKey<DropDownWardsState>();
  final GoogleMapService _googleMapService = GoogleMapService.internal();

  late UserViewModel userViewModel;
  AddressModel? currentAddress;
  Position? _currentPosition;

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    super.initState();
  }

  @override
  bool enableHeader() => false;

  @override
  Color? setBackgroundColor() {
    return AppColor.greyScaffoldBackground;
  }

  @override
  bool enableSafeAreaBottom() {
    return true;
  }

  @override
  initLocalController() {
    return AddDeliveryAddressController();
  }

  @override
  Widget buildContent(BuildContext context, localState) {
    return Consumer<UserViewModel>(
      builder: (context, userVM, child) {
        if (userVM.isAddAddressSuccess) {
          userVM.isAddAddressSuccess = false;
          Navigator.of(context).pop();
        }
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: AppDimen.space16,
                      right: AppDimen.space16,
                      bottom: AppDimen.space16,
                      top: 70),
                  child: Column(
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
                              locale.language.DELIVERY_ADDRESS_DISTRICT,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Container(
                              height: 42,
                              width: MediaQuery.of(context).size.width,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              margin: const EdgeInsets.only(top: 5),
                              child: GestureDetector(
                                child: Container(
                                  color: const Color(0xFFF5F5F5),
                                  child: DropDownDistricts(
                                    key: districtKey,
                                    district: localState.currDistrict,
                                    districts: localState.districts,
                                    callback: (val) {
                                      localState.getWards(val.id.toString());
                                      localState.currDistrict = val;
                                      localState.currWard = null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 23),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              locale.language.DELIVERY_ADDRESS_WARD,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 5),
                                height: 42,
                                child: DropDownWards(
                                  key: wardKey,
                                  ward: localState.currWard,
                                  onChange: (val) {
                                    localState.currWard = val;
                                  },
                                  wards: localState.wards,
                                  callback: (List<Ward> val) {
                                    print(val);
                                  },
                                )),
                          ],
                        ),
                      ),
                      Text(
                        'Địa chỉ cụ thể',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        margin: const EdgeInsets.only(top: 5),
                        child: Form(
                          key: localState.formKey,
                          child: TextFormField(
                            controller: localState.addressController,
                            onChanged: (value) {
                              // address.addressLine1 = value;
                            },
                            textInputAction: TextInputAction.done,
                            // validator: descriptionValidate,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              contentPadding: const EdgeInsets.all(15),
                              enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimen.space16),
                    child: SecondaryButton(
                      text: locale.language.BUTTON_CONFIRM,
                      onTap: () {
                        userViewModel.addShippingDetail(AddressModel(
                            currentAddress: localState.addressController.text,
                            city: localState.currCity,
                            district: localState.currDistrict,
                            ward: localState.currWard));
                      },
                    ),
                  ),
                ),
                if (userVM.isAddingAddress) const CommonCircularLoading(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonIconButton.buildBackButton(context),
                      Text(
                        locale.language.ADD_DELIVERY_ADDRESS_HEADER,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                                fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        // margin: const EdgeInsets.all(8),
                        // padding: const EdgeInsets.only(right: 7),
                        child: CommonIconButton.buildLocationButton(
                          context,
                          () async {
                            GoogleGeocodingResponse? response;
                            setState(() async {
                              _currentPosition =
                                  await PermissionUtil().determinePosition();
                              if (_currentPosition != null) {
                                response =
                                    await _googleMapService.getCurrentLocation(
                                        latitude: _currentPosition!.latitude,
                                        longitude: _currentPosition!.longitude);
                                if (response != null) {
                                  currentAddress = await userViewModel
                                      .getCurrentLocation(response!);

                                  localState.currDistrict =
                                      currentAddress?.district;
                                  await localState.getWards(
                                      currentAddress?.district?.id.toString() ??
                                          '');
                                  if (localState.wards.isNotEmpty) {
                                    localState.currWard = localState.wards
                                        .firstWhereOrNull((element) =>
                                            element.id ==
                                            currentAddress!.ward!.id);
                                  }
                                  // localState.currWard = currentAddress?.ward;
                                  localState.addressController.text =
                                      currentAddress?.currentAddress ?? '';
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
