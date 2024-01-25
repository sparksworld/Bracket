import 'package:bracket/plugins.dart';
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

class Global with ChangeNotifier, DiagnosticableTreeMixin {
  final BuildContext context;

  String? get theme =>
      PreferenceUtil.getString('theme', defaultValue: ITheme.auto.value);
  List<String> get searchRecord =>
      PreferenceUtil.getStringList('searchRecord', defaultValue: []);

  Global(this.context) : super();

  // GlobalKey<NavigatorState> navigatorKey = MYRouter.navigatorKey;
  // BuildContext context = navigatorKey.currentState!.context;
  // ThemeData _theme = ThemeProvider(settings).theme(context);
  // ThemeData get theme => _theme;

  void setTheme(String theme) async {
    // _theme = theme;
    await PreferenceUtil.setString('theme', theme);
    notifyListeners();
  }

  void setSearchRecord(String str) async {
    // List<String> list = PreferenceUtil.getStringList('searchRecord');

    List<String> newList = [
      ...{
        ...{str, ...searchRecord}
      }
    ];
    List<String> cutList =
        newList.sublist(0, newList.length >= 30 ? 30 : newList.length);

    await PreferenceUtil.setStringList('searchRecord', cutList);
    notifyListeners();
  }

  clearSearchRecord() async {
    await PreferenceUtil.setStringList('searchRecord', []);
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('theme', theme));
  }
}
