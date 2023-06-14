
import 'package:fresh_fruit/model/cart_model.dart';

import 'product_model.dart';

class UserModel {
  String? name;
  String? phone;
  String? address;
  List<ProductModel>? favoriteProducts;
  List<CartModel>? orderHistory;
  String? uid;
  String? email;

  UserModel(
      {this.uid,
      this.name,
      this.phone,
      this.address,
      this.favoriteProducts,
      this.orderHistory,
      this.email});

  factory UserModel.initial({required String uid, required String email}) {
    return UserModel(
        name: '',
        phone: '',
        address: '',
        favoriteProducts: [],
        orderHistory: [],
        email: email,
        uid: uid);
  }

  factory UserModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return UserModel(
      uid: snapshot['uid'] != null ? snapshot['uid'] : '',
      email: snapshot['email'] != null ? snapshot['email'] : '',
      name: snapshot['name'] != null ? snapshot['name'] : '',
      address: snapshot['address'] != null ? snapshot['address'] : '',
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
          ? List<CartModel>.generate(
              snapshot['orderHistory'].length,
              (index) => CartModel.fromQuerySnapshot(
                  snapshot['orderHistory'][index])).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "phone": phone,
      "address": address,
      "favoriteProducts": List.generate(favoriteProducts!.length,
          (index) => favoriteProducts![index].toJson()),
      "orderHistory": List.generate(
          orderHistory!.length, (index) => orderHistory![index].toJson()),
    };
  }
}
