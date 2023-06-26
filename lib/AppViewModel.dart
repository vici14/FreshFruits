import 'dart:io';
import 'package:fresh_fruit/base/BaseProvider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppFlavor { dev, prod }

const String flavorChannelId = "co.fresh_fruits.flavor";

class AppViewModel extends ChangeNotifier implements BaseProvider {
  static const flavorChannel = MethodChannel(flavorChannelId);
  late AppFlavor _appFlavor;
  late String _systemVersion;
  PackageInfo? _packageInfo;

  PackageInfo? get packageInfo => _packageInfo;

  AppFlavor get appFlavor => _appFlavor;

  String get systemVersion => _systemVersion;

  set appFlavor(AppFlavor value) {
    _appFlavor = value;
    notifyListeners();
  }

  set systemVersion(String value) {
    _systemVersion = value;
    notifyListeners();
  }

  set packageInfo(PackageInfo? value) {
    _packageInfo = value;
    notifyListeners();
  }

  @override
  Future<void> init() async {
    // _packageInfo = await PackageInfo.fromPlatform();
    var flavor = await flavorChannel.invokeMethod("getFlavor");
    _appFlavor = flavor == 'dev' ? AppFlavor.dev : AppFlavor.prod;
    _systemVersion = Platform.isIOS ? '1' : '2';

  }
}
