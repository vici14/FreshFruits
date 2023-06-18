import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fresh_fruit/AppViewModel.dart';
import 'package:fresh_fruit/route/AppRoute.dart';
import 'package:fresh_fruit/service/service_manager.dart';
import 'package:fresh_fruit/theme/AppTheme.dart';
import 'package:fresh_fruit/view_model/authen_viewmodel.dart';
import 'package:fresh_fruit/view_model/cart_viewmodel.dart';
import 'package:fresh_fruit/view_model/product_view_model.dart';
import 'package:fresh_fruit/view_model/user_viewmodel.dart';
import 'package:fresh_fruit/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

import 'HomeNavigationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: 'fresh-fruits',
  );

  AppViewModel admin = AppViewModel();
  admin.init();
  // FirebaseAuth auth = FirebaseAuth.instance;

  // FirebaseApp defaultApp = Firebase.app();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: admin)],
      child: FreshFruitApp(),
    ),
  );
}

class FreshFruitApp extends StatefulWidget {

  @override
  _FreshFruitAppState createState() => _FreshFruitAppState();
}

class _FreshFruitAppState extends State<FreshFruitApp> {
  Future<bool>? _initDependencies;

  @override
  void initState() {
    _initDependencies = initDependencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initDependencies,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductViewModel>(
                create: (BuildContext context) => ProductViewModel()),
            ChangeNotifierProvider<UserViewModel>(
                create: (BuildContext context) => UserViewModel()),
            ChangeNotifierProvider<CartViewModel>(
                create: (BuildContext context) => CartViewModel()),
            ChangeNotifierProvider<AuthViewModel>(
                create: (BuildContext context) => AuthViewModel()),
          ],
          child: MaterialApp(
            onGenerateRoute: (settings) => AppRoute.onGenerateRoute(settings),
            theme: AppTheme().lightTheme(),
            darkTheme: AppTheme().darkTheme(),
            home: Scaffold(
              drawer: MyDrawer(),
              body: HomeNavigationScreen(),
            ),
          ),
        );
      },
    );
  }

  Future<bool> initDependencies() async {
    ServiceManager().init();
    print('done init');
    //delay 1s for splash Screen
    return true;
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
