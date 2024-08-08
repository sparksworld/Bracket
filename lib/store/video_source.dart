import 'package:flutter/foundation.dart';
import '/plugins.dart';

class VideoSourceStore with ChangeNotifier, DiagnosticableTreeMixin {
  final preferenceKey = 'videoSourceStore';

  VideoSource? get data {
    return PreferenceUtil.getMap(preferenceKey) != null
        ? VideoSource.fromJson(PreferenceUtil.getMap(preferenceKey))
        : null;
  }

  void clearStore() {
    PreferenceUtil.remove(preferenceKey);
    notifyListeners();
  }

  void setStore(VideoSource data) async {
    await PreferenceUtil.setMap(preferenceKey, data.toJson());
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty(preferenceKey, data));
  }
}
