import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fresh_fruit/AppViewModel.dart';
import 'package:fresh_fruit/HomeNavigationScreen.dart';
import 'package:fresh_fruit/logger/AppLogger.dart';
import 'package:fresh_fruit/route/AppRoute.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/view_model/CartViewModel.dart';
import 'package:provider/provider.dart';

import 'view_model/UserViewModel.dart';
import 'view_model/product_view_model.dart';
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FreshFruitApp extends StatefulWidget {
  @override
  _FreshFruitAppState createState() => _FreshFruitAppState();
}

class _FreshFruitAppState extends State<FreshFruitApp> {
  Future<bool>? _initDependencies;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late FirebaseAnalyticsObserver observer;
  late AppViewModel appViewModel;

  @override
  void initState() {
    appViewModel = Provider.of<AppViewModel>(context, listen: false);
    AppLogger.i(appViewModel.appFlavor);
     observer = FirebaseAnalyticsObserver(analytics: analytics);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductViewModel>(
            create: (BuildContext context) => ProductViewModel()),
        ChangeNotifierProvider<UserViewModel>(
          create: (BuildContext context) =>
          UserViewModel()..checkIsLoggedIn(),
        ),
        ChangeNotifierProvider<CartViewModel>(
            create: (BuildContext context) => CartViewModel()),
      ],
      child: MaterialApp(
        navigatorObservers: [observer],
        navigatorKey:navigatorKey ,
        onGenerateRoute: (settings) => AppRoute.onGenerateRoute(settings),
        theme: AppTheme().lightTheme(),
        darkTheme: AppTheme().lightTheme(),
        home: Scaffold(
          body: HomeNavigationScreen(),
        ),
      ),
    );
  }
}

// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }
//
//   static FirebaseOptions get android {
//     return FirebaseOptions(
//       apiKey: 'AIzaSyDXv1b_xCLRFhKEh5-q8Xebap7j3Xx3tic',
//       appId: Endpoints.FIREBASE_ANDROID_GOOGLE_APP_ID,
//       projectId: Endpoints.FIREBASE_IOS_PROJECT_ID,
//       databaseURL: Endpoints.FIREBASE_ANDROID_DATABASE_URL,
//       storageBucket: Endpoints.FIREBASE_IOS_STORAGE_BUCKET,
//       messagingSenderId: Endpoints.FIREBASE_IOS_GCM_SENDER_ID,
//     );
//   }
//
//   static FirebaseOptions get ios {
//     return FirebaseOptions(
//       apiKey: Endpoints.FIREBASE_IOS_API_KEY,
//       appId: Endpoints.FIREBASE_IOS_GOOGLE_APP_ID,
//       messagingSenderId: Endpoints.FIREBASE_IOS_GCM_SENDER_ID,
//       projectId: Endpoints.FIREBASE_IOS_PROJECT_ID,
//       databaseURL: Endpoints.FIREBASE_IOS_DATABASE_URL,
//       storageBucket: Endpoints.FIREBASE_IOS_STORAGE_BUCKET,
//       iosBundleId: Endpoints.FIREBASE_IOS_BUNDLE_ID,
//     );
//   }
// }
