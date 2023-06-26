import 'dart:convert';

import 'package:fresh_fruit/AppViewModel.dart';
import 'package:fresh_fruit/const.dart';
import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:http/http.dart' as http;

class GoogleMapService {
  static const LOG = 'GoogleMapService';

  GoogleMapService.internal();

  static late AppFlavor _appFlavor;
  static late GoogleMapService _instance;
  static late GoogleGeocodingApi api;
  static late String googleApiKey;

  static GoogleMapService instance() => GoogleMapService.internal();
  static const distanceMatrixUrl = 'https://maps.googleapis'
      '.com/maps/api/distancematrix/json';

  static void init(AppFlavor flavor) {
    _instance = GoogleMapService.internal();
    _appFlavor = flavor;
    _createService();
  }

  static void _createService() {
    googleApiKey =
        _appFlavor == AppFlavor.dev ? GOOGLE_SERVICE_DEV : GOOGLE_SERVICE_PROD;
    api =
        GoogleGeocodingApi(googleApiKey, isLogged: _appFlavor == AppFlavor.dev);
  }

  Future<GoogleGeocodingResponse> searchAddress(String address) async {
    try {
      return await api.search(
        address,
        language: 'vi',
      );
    } catch (e) {
      AppLogger.e(e.toString(), extraMessage: LOG);
      rethrow;
    }
  }

  Future<dynamic> calculateDistance(
      {required List<String> origins,
      required List<String> destinations}) async {
    try {
      var params = {
        "origins": origins.join('|'),
        "destinations": destinations.join('|'),
        "key": googleApiKey
      };
      final url = Uri.parse(distanceMatrixUrl).replace(queryParameters: params);
      var response = await http.get(url);
      print('Response status: ${response}');
      var a = json.decode(response.body);
      return a;
    } catch (e) {
      AppLogger.e("calculateDistance:${e.toString()}", extraMessage: LOG);
    }
  }
}
