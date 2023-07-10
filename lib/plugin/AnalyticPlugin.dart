import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsPlugin {
  static final AnalyticsPlugin _instance = AnalyticsPlugin._internal();
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static AnalyticsPlugin get instance => _instance;

  AnalyticsPlugin._internal();

  factory AnalyticsPlugin() {
    return _instance;
  }

  void trackEventName(String event, {Map<String, dynamic>? data}) {
    data?["time"] = DateTime.now().millisecondsSinceEpoch;
    _analytics.logEvent(name: event, parameters: data);
  }

  void trackOpenCart() {
    var data = {"time": DateTime.now().millisecondsSinceEpoch};
    _analytics.logEvent(name: "open_cart", parameters: data);
  }

  void trackAddtoCart({Map<String, dynamic>? data}) {
    data?["time"] = DateTime.now().millisecondsSinceEpoch;

    _analytics.logEvent(name: "add_to_cart", parameters: data);
  }

  void trackAddtoCart1({Map<String, dynamic>? data}) {
    data?["time"] = DateTime.now().millisecondsSinceEpoch;

    _analytics.logEvent(name: "add_to_cart1", parameters: data);
  }
}
