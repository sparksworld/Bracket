import 'package:bracket/utils/preference.dart';
import 'package:flutter/foundation.dart';

enum ITheme { unknow, dark, light }

extension IThemeExtension on ITheme {
  String get value {
    switch (this) {
      case ITheme.dark:
        return 'dark';
      case ITheme.light:
        return 'light';
      default:
        return 'dark';
    }
  }
}

class Global with ChangeNotifier, DiagnosticableTreeMixin {
  String _theme = ITheme.light.value;
  String get theme => _theme;

  Global() {
    String? data = PreferenceUtils.getString('theme');

    if (data != null && data.isNotEmpty) {
      setTheme(data);
    }
  }

  void setTheme(String theme) async {
    _theme = theme;
    await PreferenceUtils.setString('theme', theme);
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('theme', theme));
  }
}
