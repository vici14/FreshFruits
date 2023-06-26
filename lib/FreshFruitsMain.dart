import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/AppViewModel.dart';
import 'package:fresh_fruit/FreshFruitsApp.dart';
import 'package:fresh_fruit/db/DatabaseManager.dart';
import 'package:fresh_fruit/service/service_manager.dart';
import 'package:fresh_fruit/service/storage_service.dart';
import 'package:provider/provider.dart';

class FreshFruitsMain {
  static void run() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppViewModel appViewModel = AppViewModel();
    await Firebase.initializeApp();
    await StorageService.shared.init();
    await DatabaseManager.init();
    await DatabaseManager().accessDB();

    await appViewModel.init();
    await ServiceManager.init(appViewModel.appFlavor);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    runApp(
      MultiProvider(
        providers: [ChangeNotifierProvider.value(value: appViewModel)],
        child: FreshFruitApp(),
      ),
    );
  }
}
