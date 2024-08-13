import 'dart:collection';

class Fijk3Data {
  static String fijkViewPanelVolume = "__fijkview_panel_init_volume";
  static String fijkViewPanelBrightness = "__fijkview_panel_init_brightness";
  static String fijkViewPanelSeekto = "__fijkview_panel_sekto_position";

  final Map<String, dynamic> _data = HashMap();

  void setValue(String key, dynamic value) {
    _data[key] = value;
  }

  void clearValue(String key) {
    _data.remove(key);
  }

  bool contains(String key) {
    return _data.containsKey(key);
  }

  dynamic getValue(String key) {
    return _data[key];
  }
}
