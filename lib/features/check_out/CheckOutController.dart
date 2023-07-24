import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:fresh_fruit/model/DistanceMatrixResponse.dart';
import 'package:fresh_fruit/model/ShippingDetailModel.dart';
import 'package:fresh_fruit/model/address/AddressModel.dart';
import 'package:fresh_fruit/model/cart_model.dart';
import 'package:fresh_fruit/repository/GoogleMapServiceRepository.dart';
import 'package:fresh_fruit/repository/GoogleMapServiceRepositoryImp.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

const QUAN_10_ID = 771;
const QUAN_5_ID = 774;
const List<String> hieuDestination = ['10.75834271277676, 106.67647292473883'];

class CheckOutController extends ChangeNotifier {
  bool isCalculatingAddress = false;
  final TickerProviderStateMixin tickerProviderStateMixin;
  final GoogleMapServiceRepository _googleMapServiceRepository =
      GoogleMapServiceRepositoryImp();
  DateTime? _deliveryTime;
  PaymentMethod _paymentMethod = PaymentMethod.COD;
  ShippingDetailModel? _shippingDetail;
  TabController? tabController;
  final GlobalKey _momoImageKey = GlobalKey();
  final GlobalKey _bankingImageKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();


  TextEditingController get noteController => _noteController;



  GlobalKey get bankingImageKey => _bankingImageKey;

  GlobalKey get momoImageKey => _momoImageKey;

  String? _suggestDestination;

  String? get originDestination => _suggestDestination;

  set originDestination(String? value) {
    _suggestDestination = value;
    notifyListeners();
  }

  CheckOutController(this.tickerProviderStateMixin) {
    tabController = TabController(length: 3, vsync: tickerProviderStateMixin);
    tabController?.addListener(() {
      choosePaymentMethod(tabController?.index);
    });
  }

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
  void choosePaymentMethod(int? index){
    switch(index){
      case 0:
        paymentMethod = PaymentMethod.COD;
        break;
      case 1:
        paymentMethod = PaymentMethod.MOMO;
        break;
      case 2:
        paymentMethod = PaymentMethod.BANKING;
        break;
      default:
        paymentMethod = PaymentMethod.COD;
    }
  }

  bool canApply530PMDiscount(DateTime? time) {
    if (time == null) return false;
    DateTime targetDateTime = DateTime(time.year, time.month, time.day, 17, 30);

    return time.isAfter(targetDateTime);
  }

  ShippingDiscount? getShippingDiscount(
      AddressModel? addressModel, DateTime? time) {
    if (addressModel == null) return null;
    if (canApply530PMDiscount(time)) {
      if (addressModel.district?.id == QUAN_10_ID ||
          addressModel.district?.id == QUAN_5_ID) {
        return ShippingDiscount.FREESHIP;
      }
      return ShippingDiscount.HALF_FEE;
    }
    return null;
  }

  Future<void> calculateShippingDistance(AddressModel addressModel) async {
    AppLogger.w('calculateShippingDistance:${addressModel.getDisplayAddress}');
    if (isCalculatingAddress == true) return;
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
    DistanceMatrixResponse response = DistanceMatrixResponse.fromJson(_result);

    _updateDistanceShippingDetail(response);
    originDestination = response.originAddresses?.first;
    AppLogger.w(_result);
    isCalculatingAddress = false;
    notifyListeners();
  }

  void _updateDistanceShippingDetail(DistanceMatrixResponse resp) {
    if (_shippingDetail == null) {
      shippingDetail = ShippingDetailModel.initial();
    }
    _shippingDetail?.distance = resp.rows?.first.elements?.first.distance;
    _shippingDetail?.duration = resp.rows?.first.elements?.first.duration;

    notifyListeners();
  }

  saveLocalImage(GlobalKey imageKey) async {
    RenderRepaintBoundary boundary =
    imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
    await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
      await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
    }
  }
}
