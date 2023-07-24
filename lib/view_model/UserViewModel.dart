import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fresh_fruit/db/DatabaseManager.dart';
import 'package:fresh_fruit/extension/IterableExtension.dart';
import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:fresh_fruit/model/OrderModel.dart';
import 'package:fresh_fruit/model/address/AddressDistricts.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/model/address/AdressWards.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/model/user_model.dart';
import 'package:fresh_fruit/repository/UserRepositoryImpl.dart';
import 'package:fresh_fruit/repository/UserRepository.dart';
import 'package:fresh_fruit/service/storage_service.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';
import 'package:fresh_fruit/view_model/BaseViewModel.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';

import '../language/LanguagesManager.dart';

class UserViewModel extends BaseViewModel {
  final UserRepository _repository = UserRepositoryImpl();
  static final UserViewModel _instance = UserViewModel._internal();
  final DatabaseManager _databaseManager = DatabaseManager.instance;
  final _auth = FirebaseAuth.instance;

  UserViewModel._internal();

  factory UserViewModel() {
    return _instance;
  }

  static UserViewModel instance() => _instance;

  //=======================FIELD VALUE=========================
  bool _isVerifyingPhoneNumber = false;

  String? _verificationId;

  UserModel? currentUser;

  bool _isSigningUp = false;

  bool _isVerifyingPhone = false;

  bool get isVerifyingPhone => _isVerifyingPhone;

  bool get isSigningUp => _isSigningUp;

  bool get isVerifyingPhoneNumber => _isVerifyingPhoneNumber;

  String? get verificationId => _verificationId;

  bool _isLoggingIn = false;

  bool get isLoggingIn => _isLoggingIn;

  set isLoggingIn(bool value) {
    _isLoggingIn = value;
    notifyListeners();
  }

  set isVerifyingPhoneNumber(bool value) {
    _isVerifyingPhoneNumber = value;
    notifyListeners();
  }

  set isVerifyingPhone(bool value) {
    _isVerifyingPhone = value;
    notifyListeners();
  }

  set verificationId(String? value) {
    _verificationId = value;
    notifyListeners();
  }

  set isSigningUp(bool value) {
    _isSigningUp = value;
    notifyListeners();
  }

  set isGettingOrder(bool value) {
    _isGettingOrder = value;
    notifyListeners();
  }

  bool isLoggedIn = false;
  bool isUpdatingProfile = false;

  bool isAddingAddress = false;
  bool isAddAddressSuccess = false;

  bool _isGettingOrder = false;

  bool get isGettingOrder => _isGettingOrder;

  List<OrderModel> listOrders = [];

  //=======================FIELD VALUE=========================

  void getOrders() async {
    try {
      isGettingOrder = true;
      listOrders = await _repository.getOrders(currentUser?.uid ?? "");
      isGettingOrder = false;
    } catch (e) {
      isGettingOrder = false;
      AppLogger.e(e.toString(), extraMessage: 'get Orders failed');
    }
  }

  void checkIsLoggedIn() async {
    try {
      isLoggingIn = true;
      currentUser = await _repository.getCurrentUser();
      isLoggedIn = currentUser != null;
      isLoggingIn = false;
      notifyListeners();
    } catch (e) {
      isLoggingIn = false;
      AppLogger.e(e.toString(), extraMessage: 'checkIsLoggedIn Failed');
    }
  }

  Future<void> likeProduct(ProductModel productModel) async {
    await _repository.likeProduct(
        uid: currentUser?.uid ?? '', productModel: productModel);
    refreshCurrentUser();
  }

  Future<void> unlikeProduct(ProductModel productModel) async {
    await _repository.unlikeProduct(
        uid: currentUser?.uid ?? '', productModel: productModel);
    refreshCurrentUser();
  }

  void refreshCurrentUser() async {
    currentUser = await _repository.getCurrentUser();
    notifyListeners();
  }

  void updateProfile(
      {required String name,
      required String phone,
      required String address}) async {
    isUpdatingProfile = true;
    notifyListeners();
    var _resp = await _repository.updateProfile(
        name: name,
        phone: phone,
        address: address,
        uid: currentUser?.uid ?? '');
    if (_resp) {
      refreshCurrentUser();
    }
    isUpdatingProfile = false;
    notifyListeners();
  }

  Future<bool> logOut() async {
    try {
      currentUser = await _repository.logOut();
      isLoggedIn = false;
      notifyListeners();
      StorageService.shared.deleteString('name');
      StorageService.shared.deleteString('email');
      StorageService.shared.removeSecureData('uid');
      return true;
    } catch (e) {
      print("logOut :${e.toString()}");
    }
    return false;
  }

  Future<void> addShippingDetail(AddressModel address) async {
    try {
      isAddingAddress = true;
      notifyListeners();
      isAddAddressSuccess = await _repository.addShippingDetail(
          address: address, uid: currentUser?.uid ?? "");
      refreshCurrentUser();
      isAddingAddress = false;
      notifyListeners();
      print('add location success');
    } catch (e) {
      isAddingAddress = false;
      AppLogger.e('addShippingDetail' + e.toString());
    }
  }

  Future<void> updateCurrentShippingDetail(
      AddressModel? address, Function()? callBack) async {
    try {
      isAddingAddress = true;
      notifyListeners();
      isAddAddressSuccess = await _repository.updateCurrentShippingDetail(
          address: address!, uid: currentUser?.uid ?? "");
      refreshCurrentUser();
      isAddingAddress = false;
      notifyListeners();
      if (callBack != null) {
        callBack();
      }
    } catch (e) {
      isAddingAddress = false;
      AppLogger.e('addShippingDetail' + e.toString());
    }
  }

  Future<void> verifyPhoneNumber(
      {required String phoneNumber,
      String? name,
      required Function codeSentCallback}) async {
    isVerifyingPhone = true;
    await _auth.verifyPhoneNumber(
      phoneNumber: StringUtils().getVietnamesePhoneNumber(phoneNumber),
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        AppLogger.i('phoneAuthCredential:${phoneAuthCredential.toString()}');
        /* try {
          var _user = await FirebaseAuth.instance
              .signInWithCredential(phoneAuthCredential);
          await _repository.createUser(
              uid: _user.user!.uid,
              phone: _user.user?.phoneNumber ?? "",
              name: name ?? phoneNumber);
        } catch (e) {
          AppLogger.e(e.toString(),
              extraMessage: 'verificationComplete '
                  'create user failed');
        }*/
      },
      timeout: const Duration(seconds: 120),
      verificationFailed: (FirebaseAuthException e) {
        AppLogger.e('verificationFailed:${e.toString()}');
      },
      codeSent: (String verificationId, int? resendToken) async {
        _verificationId = verificationId;
        isVerifyingPhone = false;
        AppLogger.i('codeSent:${verificationId} -- resendToken:${resendToken}');
        EasyLoading.showToast(
          locale.language.OTP_CODE_SENT,
          toastPosition: EasyLoadingToastPosition.bottom,
        );
        codeSentCallback();
      },
      codeAutoRetrievalTimeout: (e) {
        AppLogger.e(e.toString(), extraMessage: 'codeAutoRetrievalTimeout');
        // if (isOTPVerified) return;
        // EasyLoading.showToast(
        //   locale.language.OTP_CODE_SENT_FAIL,
        //   toastPosition: EasyLoadingToastPosition.bottom,
        // );
      },
    );
    // isVerifyingPhone=false;
  }

  Future<UserModel?> verifyOTP(String code) async {
    try {
      EasyLoading.showProgress(
        .3,
        status: 'Verifying...',
        maskType: EasyLoadingMaskType.clear,
      );

      var _resp = await _repository.signInWithPhoneCredential(
          verificationId: verificationId ?? "", smsCode: code);
      if (_resp != null) {
        isLoggedIn = true;
        EasyLoading.dismiss();
        EasyLoading.showSuccess(
          'Verify success',
          maskType: EasyLoadingMaskType.clear,
        );
        return _resp;
      }
      EasyLoading.dismiss();
      EasyLoading.showError(
        'Verify fail',
        maskType: EasyLoadingMaskType.clear,
      );
      return null;
    } catch (e) {
      EasyLoading.showError(
        'Verify fail',
        maskType: EasyLoadingMaskType.clear,
      );
      AppLogger.e(e.toString(), extraMessage: 'verify otp error');
      EasyLoading.dismiss();
      return null;
    }
  }

  Future<AddressModel> getCurrentLocation(
      GoogleGeocodingResponse response) async {
    List<String> addressParts =
        response.results.first.formattedAddress.split(',');

    String ward = '';
    String district = '';
    String city = '';
    String street = '';
    String country = '';

    List<District> districts = [];
    List<Ward> wards = [];

    districts = await _databaseManager.queryDistrict();
    for (int i = addressParts.length - 1; i >= 0; i--) {
      String part = addressParts[i].trim();
      switch (i) {
        case 0:
          street = addressParts[0];
          break;
        case 1:
          ward = addressParts[1].trim().toLowerCase().replaceAll('phường', '');
          break;
        case 2:
          district =
              addressParts[2].trim().toLowerCase().replaceAll('quận', '');
          break;
        case 3:
          city = addressParts[3];
          break;
        default:
          country = addressParts[4];
      }
    }

    District? districtFromList = districts.firstWhereOrNull((item) {
      return item.name?.trim().toLowerCase() == district.trim().toLowerCase();
    });
    wards =
        await _databaseManager.queryWard(districtFromList?.id.toString() ?? '');
    Ward? wardFromList = wards.firstWhereOrNull((item) {
      if (item.name?.trim().contains('0') == true) {
        return item.name?.trim().replaceAll('0', '').toLowerCase() ==
            ward.trim().toLowerCase();
      }
      return item.name?.trim().toLowerCase() == ward.trim().toLowerCase();
    });

    return AddressModel(
      district: districtFromList,
      ward: wardFromList,
      currentAddress: street,
    );
  }
}
