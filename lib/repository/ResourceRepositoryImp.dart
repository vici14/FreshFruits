import 'package:fresh_fruit/model/BannerModel.dart';
import 'package:fresh_fruit/model/PaymentMethodModel.dart';
import 'package:fresh_fruit/repository/ResourceRepository.dart';
import 'package:fresh_fruit/service/service_manager.dart';

class ResourceRepositoryImp extends ResourceRepository {
  ServiceManager serviceManager = ServiceManager.instance();

  @override
  Future<List<BannerModel>> getBanners() async {
    return await serviceManager.getBanners();
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    return await serviceManager.getPaymentMethods();
  }
}
