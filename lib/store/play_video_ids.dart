import 'package:flutter/foundation.dart';

class PlayVideoIdsStore with ChangeNotifier {
  int _originIndex = 0;
  int _teleplayIndex = 0;
  int _startAt = 0;

  int get originIndex => _originIndex;

  int get teleplayIndex => _teleplayIndex;

  int get startAt => _startAt;

  void setVideoInfoOriginIndex(int? num) {
    _originIndex = num ?? 0;
    _teleplayIndex = 0;
    notifyListeners();
  }

  void setVideoInfoTeleplayIndex(int? num) {
    _teleplayIndex = num ?? 0;
    notifyListeners();
  }

  void setVideoInfoStartAt(int? num) {
    _startAt = num ?? 0;
    notifyListeners();
  }
}
