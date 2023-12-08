import 'package:flutter/foundation.dart';
// import '/model/date/date.dart';
import '/plugins.dart';

class Profile with ChangeNotifier, DiagnosticableTreeMixin {
  User? _data;
  User? get data => _data;

  Profile() {
    Map<String, dynamic>? data = PreferenceUtils.getMap('profile');

    if (data != null) {
      setData(data);
    }
  }

  void clearUser() {
    _data = null;
    PreferenceUtils.remove('profile');
    MYRouter.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(MYRouter.loginPath, (route) => false);
    notifyListeners();
  }

  void setData(Map<String, dynamic> data) async {
    _data = User.fromJson(data);

    await PreferenceUtils.setMap('profile', data);
    notifyListeners();
  }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(ObjectFlagProperty('user', user));
  // }
}
