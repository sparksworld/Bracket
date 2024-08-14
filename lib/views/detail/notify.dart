import '/plugins.dart';

class EpisodeNotify extends ChangeNotifier {
  num _originIndex = 0;
  num _teleplayIndex = 0;
  double _startAt = 0;

  num get originIndex => _originIndex;
  num get teleplayIndex => _teleplayIndex;
  num get startAt => _startAt;

  changeOriginIndex(num index) {
    _teleplayIndex = index;
    _startAt = 0;
    notifyListeners();
  }

  changeTeleplayIndex(num index, double? time) {
    _originIndex = index;
    _teleplayIndex = 0;
    _startAt = time ?? 0;
    notifyListeners();
  }
}
