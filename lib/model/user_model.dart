import 'package:fresh_fruit/model/OrderModel.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:equatable/equatable.dart';
import 'package:fresh_fruit/model/cart_model.dart';

import 'product_model.dart';

class UserModel extends Equatable {
  String? name;
  String? phone;
  List<ProductModel>? favoriteProducts;
  List<OrderModel>? orderHistory;
  List<AddressModel>? addresses;
  AddressModel? currentAddress;
  String? uid;
  String? email;

  UserModel(
      {this.uid,
      this.name,
      this.phone,
      this.favoriteProducts,
      this.orderHistory,
      this.email,
      this.addresses,
      this.currentAddress});

  factory UserModel.initial({
    required String uid,
     required String name,
    required String phone,
  }) {
    return UserModel(
        name: name,
        phone: phone,
        currentAddress: null,
        favoriteProducts: [],
        orderHistory: [],
        addresses: [],
        uid: uid);
  }

  factory UserModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return UserModel(
      uid: snapshot['uid'] != null ? snapshot['uid'] : '',
      email: snapshot['email'] != null ? snapshot['email'] : '',
      name: snapshot['name'] != null ? snapshot['name'] : '',
      currentAddress: snapshot['currentAddress'] != null
          ? AddressModel.fromQuerySnapshot(snapshot['currentAddress'])
          : null,
      phone: snapshot['phone'] != null ? snapshot['phone'] : '',
      favoriteProducts: (snapshot['favoriteProducts'].length > 0 &&
              snapshot['favoriteProducts'] != null)
          ? List<ProductModel>.generate(
              snapshot['favoriteProducts'].length,
              (index) => ProductModel.fromQuerySnapshot(
                  snapshot['favoriteProducts'][index])).toList()
          : [],
      orderHistory: (snapshot['orderHistory'].length > 0 &&
              snapshot['orderHistory'] != null)
          ? List<OrderModel>.generate(
              snapshot['orderHistory'].length,
              (index) => OrderModel.fromQuerySnapshot(
                  snapshot['orderHistory'][index])).toList()
          : [],
      addresses: (snapshot['addresses'] != null)
          ? List<AddressModel>.generate(
              snapshot['addresses'].length ?? 0,
              (index) => AddressModel.fromQuerySnapshot(
                  snapshot['addresses'][index])).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "phone": phone,
      "currentAddress": currentAddress?.toJson(),
      "favoriteProducts": List.generate(favoriteProducts!.length,
          (index) => favoriteProducts![index].toJson()),
      "orderHistory": List.generate(
          orderHistory!.length, (index) => orderHistory![index].toJson()),
      "addresses": List.generate(
          addresses?.length ?? 0, (index) => addresses![index].toJson()),
    };
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        phone,
        currentAddress,
        favoriteProducts,
        orderHistory,
        email,
      ];
}
