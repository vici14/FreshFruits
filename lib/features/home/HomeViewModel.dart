import 'package:flutter/cupertino.dart';
import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:fresh_fruit/model/BannerModel.dart';
import 'package:fresh_fruit/model/PaymentMethodModel.dart';
import 'package:fresh_fruit/repository/ResourceRepository.dart';
import 'package:fresh_fruit/repository/ResourceRepositoryImp.dart';

class HomeViewModel extends ChangeNotifier {
  final ResourceRepository _repository = ResourceRepositoryImp();
  List<PaymentMethodModel> paymentMethods = [];
  List<BannerModel> banners = [];
  bool _isGettingBanner = false;
  bool _isGettingPaymentMethod=false;

  bool get isGettingPaymentMethod => _isGettingPaymentMethod;

  bool get isGettingBanner => _isGettingBanner;

  set isGettingPaymentMethod(bool value) {
    _isGettingPaymentMethod = value;
    notifyListeners();
  }

  set isGettingBanner(bool value) {
    _isGettingBanner = value;
    notifyListeners();
  }

  void getBanners() async {
    try {
      isGettingBanner = true;
      banners = await _repository.getBanners();
      isGettingBanner = false;
    } catch (e) {
      AppLogger.e(e.toString(), extraMessage: 'get Banners error');
      isGettingBanner = false;
    }
  }

  void getPaymentMethods() async {
    try {
      isGettingPaymentMethod = true;
      paymentMethods = await _repository.getPaymentMethods();
      isGettingPaymentMethod = false;
    } catch (e) {
      AppLogger.e(e.toString(), extraMessage: 'get Banners error');
      isGettingPaymentMethod = false;
    }
  }
}
