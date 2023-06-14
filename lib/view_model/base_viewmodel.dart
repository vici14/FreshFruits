import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// Contains ViewModel functionality for busy state management
class BaseViewModel extends ChangeNotifier {
  Map<int, bool> _busyStates = Map<int, bool>();

  /// Returns the busy status for an object if it exists. Returns false if not present
  bool busy(Object object) => _busyStates[object.hashCode] ?? false;

  /// Returns the busy status of the viewmodel
  bool get isBusy => busy(this);

  /// Marks the viewmodel as busy and calls notify listeners
  void setBusy(bool value) {
    setBusyForObject(this, value);
  }

  /// Sets the busy state for the object equal to the value passed in and notifies Listeners
  void setBusyForObject(Object object, bool value) {
    _busyStates[object.hashCode] = value;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  /// Sets the ViewModel to busy, runs the future and then sets it to not busy when complete.
  ///
  /// If a busyKey is su
  Future runBusyFuture(Future busyFuture, {required Object busyHascode}) async {
    setBusyForObject(this, true);
    var value = await busyFuture;
    setBusyForObject(this, false);
    return value;
  }
}
