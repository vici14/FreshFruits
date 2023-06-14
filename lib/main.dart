import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  // FirebaseAuth auth = FirebaseAuth.instance;

  // FirebaseApp defaultApp = Firebase.app();

  runApp(FreshCar());
}

class FreshCar extends StatefulWidget {
  @override
  _FreshCarState createState() => _FreshCarState();
}

class _FreshCarState extends State<FreshCar> {
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
