import 'package:fresh_fruit/repository/GoogleMapServiceRepository.dart';
import 'package:fresh_fruit/service/service_manager.dart';
import 'package:google_geocoding_api/src/entities/gecoding_response.dart';

class GoogleMapServiceRepositoryImp extends GoogleMapServiceRepository {
  final ServiceManager _serviceManager = ServiceManager.instance();

  @override
  Future<dynamic> calculateDistance(
      {required List<String> origins,
      required List<String> destinations}) async {
    return await _serviceManager.calculateDistance(
        origins: origins, destinations: destinations);
  }

  @override
  Future<GoogleGeocodingResponse> searchAddress(String address) async {
    return await _serviceManager.searchAddress(address);
  }

  @override
  Future<dynamic> getCurrentLocation(
      {required double latitude, required double longitude}) async {
    return await _serviceManager.getCurrentLocation(
        latitude: latitude, longitude: longitude);
  }
}
