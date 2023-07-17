import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/model/user_model.dart';

abstract class UserRepository {
  Future<bool> updateProfile(
      {required String name,
      required String phone,
      required String address,
      required String uid});

  Future<bool> changePassword();

  Future<UserModel?> createUser({
    required String uid,
    required String phone,
    required String name,
  });

  Future<UserModel?> signInWithPhoneCredential(
      {required String verificationId, required String smsCode, String? name});

  Future<bool> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<void> likeProduct(
      {required String uid, required ProductModel productModel});

  Future<void> unlikeProduct(
      {required String uid, required ProductModel productModel});

  Future<UserModel?> getCurrentUser();

  Future<bool> addShippingDetail({
    required AddressModel address,
    required String uid,
  });

  Future<bool> updateCurrentShippingDetail({
    required AddressModel address,
    required String uid,
  });

  Future<UserModel?> logOut();
}
