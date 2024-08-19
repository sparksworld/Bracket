import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

void watchConnectivity(ConnectivityResult? result, Function(bool) cb) {
  StreamSubscription<ConnectivityResult>? subscription;
  Connectivity connectivity = Connectivity();

  subscription =
      connectivity.onConnectivityChanged.listen((ConnectivityResult event) {
    if (result == null) {
      subscription?.cancel();
      cb(true);
    } else {
      cb(event == result);
      subscription?.cancel();
    }
  });
}
