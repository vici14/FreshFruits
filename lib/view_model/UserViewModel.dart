import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/model/user_model.dart';
import 'package:fresh_fruit/repository/UserRepositoryImpl.dart';
import 'package:fresh_fruit/repository/UserRepository.dart';
import 'package:fresh_fruit/service/storage_service.dart';
import 'package:fresh_fruit/view_model/BaseViewModel.dart';

class UserViewModel extends BaseViewModel {
  final UserRepository _repository = UserRepositoryImpl();
  static final UserViewModel _instance = UserViewModel._internal();

  UserViewModel._internal();

  factory UserViewModel() {
    return _instance;
  }

  static UserViewModel instance() => _instance;

  //=======================FIELD VALUE=========================

  UserModel? currentUser;
  bool _isSigningUp = false;

  bool get isSigningUp => _isSigningUp;

  set isSigningUp(bool value) {
    _isSigningUp = value;
    notifyListeners();
  }

  bool _isLoggingIn = false;

  bool get isLoggingIn => _isLoggingIn;

  set isLoggingIn(bool value) {
    _isLoggingIn = value;
    notifyListeners();
  }

  bool isLoggedIn = false;
  bool isUpdatingProfile = false;

  bool isAddingAddress = false;
  bool isAddAddressSuccess = false;

  //=======================FIELD VALUE=========================

  void checkIsLoggedIn() async {
    String? email = StorageService.shared.getString('email');
    String? name = StorageService.shared.getString('name');
    String? uid = await StorageService.shared.readSecureData('uid');

    if ((email?.isNotEmpty ?? false) &&
        (name?.isNotEmpty ?? false) &&
        (uid?.isNotEmpty ?? false)) {
      isLoggedIn = true;
      currentUser = UserModel.initial(
        uid: uid ?? '',
        email: email ?? '',
        name: name ?? '',
      );
    }
  }

  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isSigningUp = true;
       var _resp = await _repository.signUpWithEmailAndPassword(
          email: email, password: password, name: name);
      isSigningUp = false;
       return _resp;
    } catch (e) {
      print('signUpWithEmailAndPassword: ${e.toString()}');
    }
    return false;
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

  Future<bool> signInWithEmailAndPassword(BuildContext context,
      {required String email, required String password}) async {

    try {
      isLoggingIn = true;
       var _resp = await _repository.signInWithEmailAndPassword(
          email: email, password: password);
      if (_resp) {
        currentUser = await _repository.getCurrentUser();
        StorageService.shared.setString('name', currentUser?.name ?? '');
        StorageService.shared.setString('email', currentUser?.email ?? '');
        StorageService.shared.setSecureData('uid', currentUser?.uid ?? '');
        isLoggedIn = true;
      }
      isLoggingIn = false;
       return _resp;
    } catch (e) {
      print('signInWithEmailAndPassword:${e.toString()}');
    }
    return false;
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
}
