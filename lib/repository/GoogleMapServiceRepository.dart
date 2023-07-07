import 'package:google_geocoding_api/google_geocoding_api.dart';

abstract class GoogleMapServiceRepository {
  Future<dynamic> calculateDistance({
    required List<String> origins,
    required List<String> destinations,
  });
  Future<GoogleGeocodingResponse> searchAddress(String address);

  Future<dynamic> getCurrentLocation(
      {required double latitude, required double longitude});
}
