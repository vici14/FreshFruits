import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fresh_fruit/base/BaseProviderScreenState.dart';
import 'package:fresh_fruit/features/check_out/address/widgets/DropDownAddress.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/address/AddressCity.dart';
import 'package:fresh_fruit/model/address/AddressDistricts.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';
import 'package:fresh_fruit/view_model/UserViewModel.dart';
import 'package:fresh_fruit/widgets/button/SecondaryButton.dart';
import 'package:fresh_fruit/widgets/common/CommonCircularLoading.dart';

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
  late UserViewModel userViewModel;

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    super.initState();
  }

  @override
  String appBarTitle() {
    return locale.language.ADD_DELIVERY_ADDRESS_HEADER;
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
  initLocalController() {
    return AddDeliveryAddressController();
  }

  @override
  Widget buildContent(BuildContext context, localState) {
    return Consumer<UserViewModel>(
      builder: (context, userVM, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimen.space16),
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
                            decoration: BoxDecoration(color: Colors.white),
                            margin: const EdgeInsets.only(top: 5),
                            child: GestureDetector(
                              child: Container(
                                color: Color(0xFFF5F5F5),
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
                                callback: (List<Ward> val) {},
                              )),
                        ],
                      ),
                    ),
                    Text(
                      'Địa chỉ cụ thể',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
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
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
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
              if(userVM.isAddingAddress) const CommonCircularLoading()
            ],
          ),
        );
      },
    );
  }
}
