import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/DistanceMatrixResponse.dart';

enum ShippingDiscount { FREESHIP, HALF_FEE }

extension ShippingDiscountExt on ShippingDiscount {
  double getNumber() {
    switch (this) {
      case ShippingDiscount.FREESHIP:
        return 0;
      case ShippingDiscount.HALF_FEE:
        return 0.5;
      default:
        return 1;
    }
  }

  String toStringContent() {
    switch (this) {
      case ShippingDiscount.FREESHIP:
        return locale.language.CHECK_OUT_SHIPPING_DISCOUNT_FREE_SHIP;
      case ShippingDiscount.HALF_FEE:
        return locale.language.CHECK_OUT_SHIPPING_DISCOUNT_HALF_SHIP;
    }
  }
}

class ShippingDetailModel {
    ShippingDiscount? shippingDiscount;
  double price = 5000;
  Distance? distance;
  Distance? duration;

  ShippingDetailModel({this.distance, this.shippingDiscount, this.duration});

  double convertMetersToKilometers(double meters) {
    double kilometers = meters / 1000.0;
    return double.parse(kilometers.toStringAsFixed(1));
  }

  ShippingDetailModel copyWith({
    ShippingDiscount? shippingDiscount,
    double? price,
    Distance? distance,
    Distance? duration,
  }) {
    return ShippingDetailModel(
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      shippingDiscount: shippingDiscount ?? this.shippingDiscount,
    );
  }

  double getDistanceInKm() => distance != null
      ? convertMetersToKilometers(distance!.value!.toDouble())
      : 0;

  double get totalShippingPrice {
    if (distance != null) {
      double rawPrice = (price * getDistanceInKm());
      print(' shippingDiscount${shippingDiscount.toString()} --- '
          'price:$rawPrice');
      return (shippingDiscount != null)
          ? shippingDiscount!.getNumber() * rawPrice
          : rawPrice;
    }
    return 0;
  }

  factory ShippingDetailModel.initial() {
    return ShippingDetailModel(
        distance: null, duration: null, shippingDiscount: null);
  }

  factory ShippingDetailModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return ShippingDetailModel();
  }

  Map<String, Object?> toJson() {
    return {
      "distance": distance?.toJson(),
      "duration": duration?.toJson(),
      "totalShippingPrice": totalShippingPrice,
    };
  }
}
