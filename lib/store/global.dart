import 'package:bracket/plugins.dart';
import 'package:bracket/shared/theme.dart';
// import 'package:bracket/utils/preference.dart';
import 'package:flutter/foundation.dart';

enum ITheme { auto, dark, light }

extension IThemeExtension on ITheme {
  String get value {
    switch (this) {
      case ITheme.dark:
        return "dark";
      case ITheme.light:
        return "light";
      default:
        return "auto";
    }
  }
}

final settings = ThemeSettings(
  sourceColor: Colors.black,
  themeMode: ThemeMode.light,
);

class Global with ChangeNotifier, DiagnosticableTreeMixin {
  final BuildContext context;
  String _theme = ITheme.auto.value;
  String get theme => _theme;

  Global(this.context) {
    String? data = PreferenceUtil.getString('theme');

    if (data != null && data.isNotEmpty) {
      setTheme(data);
    }
  }

  // GlobalKey<NavigatorState> navigatorKey = MYRouter.navigatorKey;
  // BuildContext context = navigatorKey.currentState!.context;
  // ThemeData _theme = ThemeProvider(settings).theme(context);
  // ThemeData get theme => _theme;

  void setTheme(String theme) async {
    _theme = theme;
    await PreferenceUtil.setString('theme', theme);
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('theme', theme));
  }
}
