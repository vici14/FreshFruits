import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_fruit/model/ShippingDetailModel.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';

class OrderModel {
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

  OrderModel({
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
  });

  double get allProductsPrice {
    double _cost = 0;
    if (orderedItems?.isEmpty == true) return 0;
    for (var i in orderedItems!) {
      _cost += i.quantity * i.cost!.toDouble();
    }
    return _cost;
  }

  double get totalPrice {
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

  // double get totalPrice {
  //   double _totalCost = 0;
  //   orderedItems?.forEach((element) {
  //     _totalCost += element.quantity * double.parse(element.cost.toString());
  //   });
  //   return _totalCost;
  // }

  factory OrderModel.initial() {
    return OrderModel(
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

  factory OrderModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    Timestamp _deliveryTimeStamp = Timestamp.now();
    Timestamp _orderCheckoutTime = Timestamp.now();
    if (snapshot['deliveryTime'] != null &&
        snapshot['deliveryTime'] is Timestamp) {
      _deliveryTimeStamp = snapshot['deliveryTime'] as Timestamp;
    }

    if (snapshot['orderCheckoutTime'] != null &&
        snapshot['orderCheckoutTime'] is Timestamp) {
      _orderCheckoutTime = snapshot['orderCheckoutTime'] as Timestamp;
    }

    return OrderModel(
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
      addressModel: snapshot['address'] != null
          ? AddressModel.fromQuerySnapshot(snapshot['address'])
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
          ? snapshot['paymentMethod'].toPaymentMethod()
          : null,
      orderStatus:
      snapshot['orderStatus'] != null && snapshot['orderStatus'] is String
          ? snapshot['orderStatus'].toOrderStatus()
          : null,
    );
  }

  OrderModel copyWith(
      {List<OrderedProductModel>? orderedItems,
        String? note,
        String? customerName,
        String? customerPhone,
        DateTime? orderCheckoutTime,
        double? productsPrice,
        ShippingDetailModel? shippingDetail,
        AddressModel? addressModel,
        DateTime? deliveryTime,
        PaymentMethod? paymentMethod,
        OrderStatus? orderStatus}) {
    return OrderModel(
      customerPhone: customerPhone ?? this.customerPhone,
      customerName: customerName ?? this.customerName,
      orderedItems: orderedItems ?? this.orderedItems,
      productsPrice: productsPrice ?? this.productsPrice,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      addressModel: addressModel ?? this.addressModel,
      orderCheckoutTime: orderCheckoutTime ?? this.orderCheckoutTime,
      shippingDetail: shippingDetail ?? this.shippingDetail,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }

  OrderModel withShippingInformation({
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
      'productsPrice': allProductsPrice,
      'totalPrice': totalPrice,
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
      'addressModel': addressModel?.toJson(),
      'paymentMethod': paymentMethod?.toJson(),
      'orderStatus': orderStatus?.toJson(),
    };
  }
}
