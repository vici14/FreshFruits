import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_fruit/model/ShippingDetailModel.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/model/ordered_product_model.dart';

class OrderModel {
  String? id;
  String? user;
  List<OrderedProductModel>? orderedItems;
  String? note;
  String? customerName;
  String? customerPhone;
  DateTime? orderCheckoutTime;
  double productsPrice;
  ShippingDetailModel? shippingDetail;
  AddressModel? destination;
  DateTime? deliveryTime;
  PaymentMethod? paymentMethod;
  OrderStatus? orderStatus;

  OrderModel({
    this.id,
    this.user,
    this.orderCheckoutTime,
    this.orderedItems,
    this.customerName,
    this.customerPhone,
    this.note,
    this.productsPrice = 0,
    this.shippingDetail,
    this.destination,
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
      destination != null &&
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
        id: '',
        user: '',
        orderCheckoutTime: null,
        destination: null,
        deliveryTime: null,
        paymentMethod: null,
        shippingDetail: null,
        orderStatus: OrderStatus.INITIAL);
  }

  factory OrderModel.fromCart(CartModel cartModel) {
    return OrderModel(
        user: "",
        id: "",
        productsPrice: cartModel.productsPrice,
        orderedItems: cartModel.orderedItems,
        customerName: cartModel.customerName,
        customerPhone: cartModel.customerPhone,
        note: cartModel.note,
        orderCheckoutTime: cartModel.orderCheckoutTime,
        destination: cartModel.addressModel,
        deliveryTime: cartModel.deliveryTime,
        paymentMethod: cartModel.paymentMethod,
        shippingDetail: cartModel.shippingDetail,
        orderStatus: cartModel.orderStatus);
  }

  factory OrderModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
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

    if (snapshot['paymentMethod'] != null &&
        snapshot['paymentMethod'] is String) {
      _paymentMethod = snapshot['paymentMethod'] as String;
    }

    if (snapshot['orderStatus'] != null && snapshot['orderStatus'] is String) {
      _orderStatus = snapshot['orderStatus'] as String;
    }
    return OrderModel(
      id: snapshot['id'],
      user: snapshot['user'],
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
      destination: snapshot['destination'] != null
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

  OrderModel copyWith({
    String? id,
    String? user,
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
  }) {
    return OrderModel(
      user: user ?? this.user,
      id: id ?? this.id,
      customerPhone: customerPhone ?? this.customerPhone,
      customerName: customerName ?? this.customerName,
      orderedItems: orderedItems ?? this.orderedItems,
      productsPrice: productsPrice ?? this.productsPrice,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      destination: addressModel ?? this.destination,
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
      'id': id,
      'user': user,
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
      'destination': destination?.toJson(),
      'paymentMethod': paymentMethod?.toJson(),
      'orderStatus': orderStatus?.toJson(),
    };
  }
}
