import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class PermissionUtil{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      announcement: true,  // Optional: Enable announcement notifications on iOS 15+
      criticalAlert: true, // Optional: Enable critical alerts on iOS
      provisional: false,  // Optional: Request provisional authorization on iOS 15+
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // User has granted permission
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      // User has granted provisional permission (iOS 15+ only)
    } else {
      // User has denied or is restricted from permission
    }
  }
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

}