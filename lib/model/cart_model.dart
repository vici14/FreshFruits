import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_fruit/features/check_out/CheckOutController.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/ShippingDetailModel.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';

enum PaymentMethod { COD, MOMO, BANKING }

extension StringMapping on String {
  PaymentMethod toPaymentMethod(String json) {
    switch (json) {
      case 'COD':
        return PaymentMethod.COD;
      case 'MOMO':
        return PaymentMethod.MOMO;
      case 'BANKING':
        return PaymentMethod.BANKING;
      default:
        return PaymentMethod.COD;
    }
  }
}

extension PaymentMethodExt on PaymentMethod {
  String toJson() {
    switch (this) {
      case PaymentMethod.COD:
        return 'COD';
      case PaymentMethod.MOMO:
        return 'MOMO';
      case PaymentMethod.BANKING:
        return 'BANKING';
      default:
        return "COD";
    }
  }

  String toContent() {
    switch (this) {
      case PaymentMethod.COD:
        return 'COD ${locale.language.DEFAULT}';
      case PaymentMethod.MOMO:
        return 'MOMO';
      case PaymentMethod.BANKING:
        return 'BANKING';
      default:
        return 'COD ${locale.language.DEFAULT}';
    }
  }
}

class CartModel {
  List<OrderedProductModel>? orderedItems;
  String? note;
  String? customerName;
  String? customerPhone;
  DateTime? orderCheckoutTime;
  double totalCost;
  ShippingDetailModel? shippingDetail;
  AddressModel? addressModel;
  DateTime? deliveryTime;
  PaymentMethod? paymentMethod;

  CartModel({
    this.orderCheckoutTime,
    this.orderedItems,
    this.customerName,
    this.customerPhone,
    this.note,
    this.totalCost = 0,
    this.shippingDetail,
    this.addressModel,
    this.deliveryTime,
    this.paymentMethod,
  });

  bool get canCheckOut =>
      customerPhone!= null &&
      addressModel != null &&
      deliveryTime != null &&
      paymentMethod != null &&
      shippingDetail != null &&
      orderedItems?.isNotEmpty == true;

  // double get totalPrice {
  //   double _totalCost = 0;
  //   orderedItems?.forEach((element) {
  //     _totalCost += element.quantity * double.parse(element.cost.toString());
  //   });
  //   return _totalCost;
  // }

  factory CartModel.initial() {
    return CartModel(
        totalCost: 0,
        orderedItems: [],
        customerName: '',
        customerPhone: '',
        note: '',
        orderCheckoutTime: null,
        addressModel: null,
        deliveryTime: null,
        paymentMethod: null,
        shippingDetail: null);
  }

  factory CartModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return CartModel(
        customerName: snapshot['customerName'],
        customerPhone: snapshot['customerPhone'],
        note: snapshot['note'],
        orderedItems: (snapshot['orderedItems'].length > 0 && snapshot['orderedItems'] != null)
            ? List<OrderedProductModel>.generate(snapshot['orderedItems'].length, (index) => OrderedProductModel.fromQuerySnapshot(snapshot['orderedItems'][index]))
                .toList()
            : [],
        totalCost: snapshot['totalCost'] ?? 0,
        orderCheckoutTime: (snapshot['orderCheckoutTime'] != null &&
                snapshot['orderCheckoutTime'] is Timestamp)
            ? Timestamp.fromMillisecondsSinceEpoch(snapshot['orderCheckoutTime'])
                .toDate()
            : DateTime.now(),
        addressModel: snapshot['address'] != null
            ? AddressModel.fromQuerySnapshot(snapshot['address'])
            : null,
        shippingDetail: snapshot['shippingDetail'] != null
            ? ShippingDetailModel.fromQuerySnapshot(snapshot['shippingDetail'])
            : null,
        deliveryTime:
            (snapshot['deliveryTime'] != null && snapshot['deliveryTime'] is Timestamp)
                ? Timestamp.fromMillisecondsSinceEpoch(snapshot['deliveryTime'])
                    .toDate()
                : null,
        paymentMethod:
            snapshot['paymentMethod'] != null && snapshot['paymentMethod'] is String
                ? snapshot['paymentMethod'].toPaymentMethod()
                : null);
  }

  CartModel copyWith({
    List<OrderedProductModel>? orderedItems,
    String? note,
    String? customerName,
    String? customerPhone,
    DateTime? orderCheckoutTime,
    double? totalCost,
    ShippingDetailModel? shippingDetail,
    AddressModel? addressModel,
    DateTime? deliveryTime,
    PaymentMethod? paymentMethod,
  }) {
    return CartModel(
        customerPhone: customerPhone ?? this.customerPhone,
        customerName: customerName ?? this.customerName,
        orderedItems: orderedItems ?? this.orderedItems,
        totalCost: totalCost ?? this.totalCost,
        note: note ?? this.note,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        deliveryTime: deliveryTime ?? this.deliveryTime,
        addressModel: addressModel ?? this.addressModel,
        orderCheckoutTime: orderCheckoutTime ?? this.orderCheckoutTime,
        shippingDetail: shippingDetail ?? this.shippingDetail);
  }

  CartModel withShippingInformation({
    required AddressModel addressModel,
    required DateTime deliveryTime,
    required PaymentMethod paymentMethod,
  }) {
    return copyWith(
        addressModel: addressModel,
        deliveryTime: deliveryTime,
        paymentMethod: paymentMethod);
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCost': totalCost,
      'orderedItems': List.generate(
          orderedItems!.length, (index) => orderedItems![index].toJson()),
      'note': note,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'orderCheckoutTime': orderCheckoutTime != null
          ? Timestamp.fromDate(orderCheckoutTime!)
          : null,
      'deliveryTime':
          deliveryTime != null ? Timestamp.fromDate(deliveryTime!) : null,
      'shippingDetail': shippingDetail?.toJson(),
      'addressModel': addressModel?.toJson(),
      'paymentMethod': paymentMethod?.toJson(),
    };
  }
}
