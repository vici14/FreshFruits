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
}

class ShippingDetailModel {
  final ShippingDiscount? shippingDiscount;
  double price = 5000;
  Distance? distance;
  Distance? duration;

  ShippingDetailModel({this.distance, this.shippingDiscount, this.duration});

  double convertMetersToKilometers(double meters) {
    double kilometers = meters / 1000.0;
    return double.parse(kilometers.toStringAsFixed(1));
  }

  double getDistanceInKm() => distance != null
      ? convertMetersToKilometers(distance!.value!.toDouble())
      : 0;

  double get totalShippingPrice {
    if (distance != null) {
      double rawPrice = (price * getDistanceInKm());
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
