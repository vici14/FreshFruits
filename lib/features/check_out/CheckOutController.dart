import 'package:flutter/cupertino.dart';
import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:fresh_fruit/model/DistanceMatrixResponse.dart';
import 'package:fresh_fruit/model/ShippingDetailModel.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/repository/GoogleMapServiceRepository.dart';
import 'package:fresh_fruit/repository/GoogleMapServiceRepositoryImp.dart';
import 'package:intl/intl.dart';

const QUAN_10_ID = 771;
const QUAN_5_ID = 774;
const List<String> hieuDestination = ['10.76175541122259, 106.67423759775012'];

class CheckOutController extends ChangeNotifier {
  bool isCalculatingAddress = false;

  final GoogleMapServiceRepository _googleMapServiceRepository =
      GoogleMapServiceRepositoryImp();
  DateTime? _deliveryTime;
  PaymentMethod _paymentMethod = PaymentMethod.COD;
  ShippingDetailModel? _shippingDetail;

  ShippingDetailModel? get shippingDetail => _shippingDetail;

  set shippingDetail(ShippingDetailModel? value) {
    _shippingDetail = value;
    notifyListeners();
  }

  PaymentMethod get paymentMethod => _paymentMethod;

  set paymentMethod(PaymentMethod value) {
    _paymentMethod = value;
    notifyListeners();
  }

  DateTime? get deliveryTime => _deliveryTime;

  set deliveryTime(DateTime? value) {
    _deliveryTime = value;

    notifyListeners();
  }


  bool canApply530PMDiscount() {
    DateTime now = DateTime.now();
    DateTime targetDateTime = DateTime(now.year, now.month, now.day, 17, 30);

    return targetDateTime.isAfter(now);
  }

  ShippingDiscount? shippingDiscount(AddressModel addressModel) {
    if (canApply530PMDiscount()) {
      if (addressModel.ward?.id == QUAN_10_ID ||
          addressModel.ward?.id == QUAN_5_ID) {
        return ShippingDiscount.FREESHIP;
      }
      return ShippingDiscount.HALF_FEE;
    }
    return null;
  }

  Future<void> calculateShippingDistance(AddressModel addressModel) async {
    AppLogger.w('calculateShippingDistance:${addressModel.getDisplayAddress}');
    if(isCalculatingAddress== true) return;
    isCalculatingAddress = true;
    notifyListeners();
    var _address = await _googleMapServiceRepository
        .searchAddress(addressModel.getDisplayAddress);

    List<String> origins = [
      "${_address.results.first.geometry?.location.lat.toString()},${_address.results.first.geometry?.location.lng.toString()}" ??
          "",
    ];
    List<String> destinations = hieuDestination;
    var _result = await _googleMapServiceRepository.calculateDistance(
        origins: origins, destinations: destinations);
    DistanceMatrixResponse response=DistanceMatrixResponse.fromJson(_result);
    _updateDistanceShippingDetail(response);
  AppLogger.w(_result);
    isCalculatingAddress = false;
    notifyListeners();
  }

  void _updateDistanceShippingDetail(DistanceMatrixResponse resp){
    if(_shippingDetail == null){
      shippingDetail = ShippingDetailModel.initial();
    }
    _shippingDetail?.distance= resp.rows?.first.elements?.first.distance;
    _shippingDetail?.duration= resp.rows?.first.elements?.first.duration;

    notifyListeners();
  }
}
