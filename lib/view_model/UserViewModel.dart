import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/model/user_model.dart';
import 'package:fresh_fruit/repository/UserRepositoryImpl.dart';
import 'package:fresh_fruit/repository/UserRepository.dart';
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

  Future<bool> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      isSigningUp = true;
      notifyListeners();
      var _resp = await _repository.signUpWithEmailAndPassword(
          email: email, password: password);
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

  Future<bool> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      isLoggingIn = true;
      isLoggedIn = false;
      notifyListeners();
      var _resp = await _repository.signInWithEmailAndPassword(
          email: email, password: password);
      if (_resp) {
        currentUser = await _repository.getCurrentUser();
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
      return true;
    } catch (e) {
      print("logOut :${e.toString()}");
    }
    return false;
  }
}
