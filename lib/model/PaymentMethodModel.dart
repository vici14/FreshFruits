import 'cart_model.dart';

class PaymentMethodModel {
  final String? imageUrl;
  final PaymentMethod? paymentMethod;

  PaymentMethodModel({this.imageUrl, this.paymentMethod});

  factory PaymentMethodModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    String _paymentMethod = '';

    if (snapshot['paymentMethod'] != null &&
        snapshot['paymentMethod'] is String) {
      _paymentMethod = snapshot['paymentMethod'] as String;
    }

    return PaymentMethodModel(
      imageUrl: snapshot['imageUrl'],
      paymentMethod: snapshot['paymentMethod'] != null &&
              snapshot['paymentMethod'] is String
          ? _paymentMethod.toPaymentMethod()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "imageUrl": imageUrl,
      'paymentMethod': paymentMethod?.toJson(),
    };
  }
}
