import 'package:flutter/foundation.dart';
// import '/model/date/date.dart';
import '/plugins.dart';

class Profile with ChangeNotifier, DiagnosticableTreeMixin {
  User? _user;
  User? get user => _user;

  Profile() {
    Map<String, dynamic>? data = PreferenceUtil.getMap('profile');

    if (data != null && data.isNotEmpty) {
      setData(data);
    }
  }

  void clearUser() {
    _user = null;
    PreferenceUtil.remove('profile');
    MYRouter.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(MYRouter.loginPagePath, (route) => false);
    notifyListeners();
  }

  void setData(Map<String, dynamic> data) async {
    _user = User.fromJson(data);

    await PreferenceUtil.setMap('profile', data);
    notifyListeners();
  }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(ObjectFlagProperty('user', user));
  // }
}
