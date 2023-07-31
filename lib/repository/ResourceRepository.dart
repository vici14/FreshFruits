import 'package:fresh_fruit/model/BannerModel.dart';
import 'package:fresh_fruit/model/PaymentMethodModel.dart';

abstract class ResourceRepository{
  Future<List<BannerModel>> getBanners();
  Future<List<PaymentMethodModel>> getPaymentMethods();
}