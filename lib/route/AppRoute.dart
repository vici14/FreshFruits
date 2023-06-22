import 'package:flutter/material.dart';
import 'package:fresh_fruit/HomeNavigationScreen.dart';
import 'package:fresh_fruit/error/ErrorScreen.dart';
import 'package:fresh_fruit/features/account/UserScreen.dart';
import 'package:fresh_fruit/features/authens/authen_screen.dart';
import 'package:fresh_fruit/features/cart/cart_screen.dart';
import 'package:fresh_fruit/features/check_out/CheckOutScreen.dart';
import 'package:fresh_fruit/features/check_out/address/AddDeliveryAddressScreen.dart';
import 'package:fresh_fruit/features/favourite/favorite_products_screen.dart';
import 'package:fresh_fruit/features/home/HomeScreen.dart';
import 'package:fresh_fruit/features/splash/SplashScreen.dart';
import 'package:fresh_fruit/features/store/store_screen.dart';

class AppRoute {
  static const root = '/';
  static const splashScreen = '/splash';
  static const homeNavigationScreen = '/homeNavigation';
  static const homeScreen ='/home';
  static const searchScreen ='/search';
  static const cartScreen='/cart';
  static const favouriteScreen='/favourite';
  static const userScreen = '/user';
  static const authenScreen = '/authen';
  static const checkoutScreen = '/checkout';
  static const deliveryAddressScreen = '/deliveryAddress';
  static const addDeliveryAddressScreen = '/addDeliveryAddress';
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    print('settings.name:${settings.name}');
    switch (settings.name) {
      case root:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case homeNavigationScreen:
        return MaterialPageRoute(
          builder: (context) => HomeNavigationScreen(),
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      case searchScreen:
        return MaterialPageRoute(
          builder: (context) => const StoreScreen(),
        );
      case cartScreen:
        return MaterialPageRoute(
          builder: (context) => CartScreen(),
        );
      case favouriteScreen:
        return MaterialPageRoute(
          builder: (context) => const FavoriteProductsScreen(),
        );
      case userScreen:
        return MaterialPageRoute(
          builder: (context) => UserScreen(),
        );
      case authenScreen:
        return MaterialPageRoute(
          builder: (context) => AuthenScreen(),
        );
      case AppRoute.checkoutScreen:
        return MaterialPageRoute(
          builder: (context) => CheckOutScreen(),
        );
      case AppRoute.addDeliveryAddressScreen:
        return MaterialPageRoute(
          builder: (context) => AddDeliveryAddressScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => ErrorScreen(
            error: Exception(settings.name),
          ),
        );
    }
  }
}
