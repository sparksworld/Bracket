import 'dart:ui';
import 'dart:async';

class Throttle {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Throttle({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer(Duration(milliseconds: milliseconds), () {
        action();
        _timer = null;
      });
    }
  }
}
