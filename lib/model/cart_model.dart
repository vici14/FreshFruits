import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_fruit/features/check_out/CheckOutController.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/ShippingDetailModel.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';

enum PaymentMethod { COD, MOMO, BANKING }

enum OrderStatus { PROCESSING, CANCEL, DONE }

extension StringMapping on String {
  PaymentMethod toPaymentMethod() {
    switch (this) {
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

  OrderStatus toOrderStatus() {
    switch (this) {
      case 'PROCESSING':
        return OrderStatus.PROCESSING;
      case 'CANCEL':
        return OrderStatus.CANCEL;
      case 'DONE':
        return OrderStatus.DONE;
      default:
        return OrderStatus.PROCESSING;
    }
  }
}

extension OrderStatusExt on OrderStatus {
  String toJson() {
    switch (this) {
      case OrderStatus.PROCESSING:
        return 'PROCESSING';
      case OrderStatus.DONE:
        return 'DONE';
      case OrderStatus.CANCEL:
        return 'CANCEL';
      default:
        return "PROCESSING";
    }
  }

  String toContent() {
    switch (this) {
      case OrderStatus.PROCESSING:
        return locale.language.ORDER_STATUS_PROCESSING;
      case OrderStatus.DONE:
        return locale.language.ORDER_STATUS_DONE;
      case OrderStatus.CANCEL:
        return locale.language.ORDER_STATUS_CANCEL;
      default:
        return locale.language.ORDER_STATUS_PROCESSING;
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
  double productsPrice;
  ShippingDetailModel? shippingDetail;
  AddressModel? addressModel;
  DateTime? deliveryTime;
  PaymentMethod? paymentMethod;
  OrderStatus? orderStatus;
  String? uid;
  double? totalPrice;

  CartModel({
    this.totalPrice,
    this.orderCheckoutTime,
    this.orderedItems,
    this.customerName,
    this.customerPhone,
    this.note,
    this.productsPrice = 0,
    this.shippingDetail,
    this.addressModel,
    this.deliveryTime,
    this.paymentMethod,
    this.orderStatus,
    this.uid,
  });

  double get allProductsPrice {
    double _cost = 0;
    if (orderedItems?.isEmpty == true) return 0;
    for (var i in orderedItems!) {
      _cost += i.quantity * i.cost!.toDouble();
    }
    return _cost;
  }

  double get getTotalPrice {
    if (shippingDetail == null) return allProductsPrice;
    return shippingDetail!.totalShippingPrice + allProductsPrice;
  }

  bool get canCheckOut =>
      customerPhone != null &&
      addressModel != null &&
      deliveryTime != null &&
      paymentMethod != null &&
      shippingDetail != null &&
      orderedItems?.isNotEmpty == true;

  factory CartModel.initial() {
    return CartModel(
        productsPrice: 0,
        orderedItems: [],
        customerName: '',
        customerPhone: '',
        note: '',
        orderCheckoutTime: null,
        addressModel: null,
        deliveryTime: null,
        paymentMethod: null,
        shippingDetail: null,
        orderStatus: OrderStatus.PROCESSING);
  }

  factory CartModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    Timestamp _deliveryTimeStamp = Timestamp.now();
    Timestamp _orderCheckoutTime = Timestamp.now();
    String _orderStatus = '';
    String _paymentMethod = '';

    if (snapshot['deliveryTime'] != null &&
        snapshot['deliveryTime'] is Timestamp) {
      _deliveryTimeStamp = snapshot['deliveryTime'] as Timestamp;
    }

    if (snapshot['orderCheckoutTime'] != null &&
        snapshot['orderCheckoutTime'] is Timestamp) {
      _orderCheckoutTime = snapshot['orderCheckoutTime'] as Timestamp;
    }

    if (snapshot['orderStatus'] != null && snapshot['orderStatus'] is String) {
      _orderStatus = snapshot['orderStatus'] as String;
    }

    if (snapshot['paymentMethod'] != null &&
        snapshot['paymentMethod'] is String) {
      _paymentMethod = snapshot['paymentMethod'] as String;
    }

    return CartModel(
      uid: snapshot['uid'],
      customerName: snapshot['customerName'],
      customerPhone: snapshot['customerPhone'],
      note: snapshot['note'],
      orderedItems: (snapshot['orderedItems'].length > 0 &&
              snapshot['orderedItems'] != null)
          ? List<OrderedProductModel>.generate(
              snapshot['orderedItems'].length,
              (index) => OrderedProductModel.fromQuerySnapshot(
                  snapshot['orderedItems'][index])).toList()
          : [],
      productsPrice: snapshot['totalCost'] ?? 0,
      orderCheckoutTime: (snapshot['orderCheckoutTime'] != null &&
              snapshot['orderCheckoutTime'] is Timestamp)
          ? Timestamp.fromMillisecondsSinceEpoch(
                  _orderCheckoutTime.millisecondsSinceEpoch)
              .toDate()
          : DateTime.now(),
      addressModel: snapshot['destination'] != null
          ? AddressModel.fromQuerySnapshot(snapshot['destination'])
          : null,
      shippingDetail: snapshot['shippingDetail'] != null
          ? ShippingDetailModel.fromQuerySnapshot(snapshot['shippingDetail'])
          : null,
      deliveryTime: (snapshot['deliveryTime'] != null &&
              snapshot['deliveryTime'] is Timestamp)
          ? Timestamp.fromMillisecondsSinceEpoch(
                  _deliveryTimeStamp.millisecondsSinceEpoch)
              .toDate()
          : null,
      paymentMethod: snapshot['paymentMethod'] != null &&
              snapshot['paymentMethod'] is String
          ? _paymentMethod.toPaymentMethod()
          : null,
      orderStatus:
          snapshot['orderStatus'] != null && snapshot['orderStatus'] is String
              ? _orderStatus.toOrderStatus()
              : null,
    );
  }

  CartModel copyWith({
    List<OrderedProductModel>? orderedItems,
    String? note,
    String? customerName,
    String? customerPhone,
    DateTime? orderCheckoutTime,
    double? productsPrice,
    ShippingDetailModel? shippingDetail,
    AddressModel? addressModel,
    DateTime? deliveryTime,
    PaymentMethod? paymentMethod,
    OrderStatus? orderStatus,
    String? uid,
    bool isResetShippingDetail = false,
  }) {
    print('CartModel: copyWith');
    return CartModel(
      customerPhone: customerPhone ?? this.customerPhone,
      customerName: customerName ?? this.customerName,
      orderedItems: orderedItems ?? this.orderedItems,
      productsPrice: productsPrice ?? this.productsPrice,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      addressModel: addressModel ?? this.addressModel,
      orderCheckoutTime: orderCheckoutTime ?? this.orderCheckoutTime,
      shippingDetail:
          isResetShippingDetail ? null : shippingDetail ?? this.shippingDetail,
      orderStatus: orderStatus ?? this.orderStatus,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productsPrice': allProductsPrice,
      'totalPrice': getTotalPrice,
      'orderedItems': List.generate(
          orderedItems?.length ?? 0, (index) => orderedItems![index].toJson()),
      'note': note,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'orderCheckoutTime': orderCheckoutTime != null
          ? Timestamp.fromDate(orderCheckoutTime!)
          : null,
      'deliveryTime':
          deliveryTime != null ? Timestamp.fromDate(deliveryTime!) : null,
      'shippingDetail': shippingDetail?.toJson(),
      'destination': addressModel?.toJson(),
      'paymentMethod': paymentMethod?.toJson(),
      'orderStatus': orderStatus?.toJson(),
      'uid': uid,
    };
  }
}
