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
  bool isSigningUp = false;
  bool isLoggingIn = false;

  bool isLoggedIn = false;
  bool isUpdatingProfile = false;

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
      notifyListeners();
      var _resp = await _repository.signUpWithEmailAndPassword(
          email: email, password: password, name: name);
      isSigningUp = false;
      notifyListeners();
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
      isLoggedIn = false;
      notifyListeners();
      var _resp = await _repository.signInWithEmailAndPassword(
          email: email, password: password);
      if (_resp) {
        currentUser = await _repository.getCurrentUser().then((value) {
          StorageService.shared.setString('name', value?.name ?? '');
          StorageService.shared.setString('email', value?.email ?? '');
          StorageService.shared.setSecureData('uid', value?.uid ?? '');
        });
        isLoggedIn = true;
      }
      isLoggingIn = false;
      notifyListeners();
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
}
