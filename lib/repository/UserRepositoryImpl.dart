import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/product_model.dart';
import 'package:fresh_fruit/model/user_model.dart';
import 'package:fresh_fruit/repository/UserRepository.dart';
import 'package:fresh_fruit/service/service_manager.dart';

class UserRepositoryImpl extends UserRepository {
  ServiceManager serviceManager = ServiceManager.instance();

  @override
  Future<bool> changePassword() {
    throw UnimplementedError();
  }

  @override
  Future<bool> signInWithEmailAndPassword(
      {required String email, required String password}) {
    return serviceManager.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<bool> updateProfile(
      {required String name,
      required String phone,
      required String address,
      required String uid}) async {
    return await serviceManager.updateProfile(
      name: name,
      phone: phone,
      address: address,
      uid: uid,
    );
  }

  @override
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    return await serviceManager.signUpWithEmailAndPassword(
        email: email, password: password, name: name);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return await serviceManager.getCurrentUser();
  }

  @override
  Future<void> likeProduct(
      {required String uid, required ProductModel productModel}) async {
    return serviceManager.likeProduct(uid: uid, productModel: productModel);
  }

  @override
  Future<void> unlikeProduct(
      {required String uid, required ProductModel productModel}) async {
    return serviceManager.unlikeProduct(uid: uid, productModel: productModel);
  }

  @override
  Future<UserModel?> logOut() async {
    return await serviceManager.logOut();
  }

  @override
  Future<bool> addShippingDetail(
      {required AddressModel address, required String uid}) async {
    return await serviceManager.addShippingAddress(address: address, uid: uid);
  }

  @override
  Future<bool> updateCurrentShippingDetail(
      {required AddressModel address, required String uid}) async {
    return await serviceManager.updateCurrentShippingAddress(
        address: address, uid: uid);
  }

  @override
  Future<UserModel?> signInWithPhoneCredential(
      {required String verificationId,
      required String smsCode,
      String? name}) async {
    return await serviceManager.signInWithPhoneCredential(
        verificationId: verificationId, smsCode: smsCode);
  }

  @override
  Future<UserModel?> createUser(
      {required String uid,
      required String phone,
      required String name}) async {
    return await serviceManager.createUser(uid: uid, phone: phone, name: name);
  }
}
