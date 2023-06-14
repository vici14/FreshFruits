import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fresh_fruit/AppViewModel.dart';
 import 'package:fresh_fruit/service/service_manager.dart';
import 'package:fresh_fruit/view_model/cart_viewmodel.dart';
import 'package:fresh_fruit/view_model/product_view_model.dart';
import 'package:fresh_fruit/view_model/user_viewmodel.dart';
import 'package:fresh_fruit/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

import 'fresh_car_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );

  AppViewModel admin = AppViewModel();
  admin.init();
  // FirebaseAuth auth = FirebaseAuth.instance;

  // FirebaseApp defaultApp = Firebase.app();

  runApp(
      MultiProvider(
        providers: [ChangeNotifierProvider.value(value: admin)],
        child: FreshFruitApp(),
      ),);
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
          ],
          child: MaterialApp(
            home: Scaffold(
              drawer: MyDrawer(),
              body: FreshCarHomeScreen(),
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
