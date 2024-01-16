// import 'package:provider/provider.dart';
import '/plugins.dart';
import '/views/home/index.dart';
import '/views/login.dart';
import '/views/splash.dart';
import '/views/unknown.dart';
import 'views/setting/index.dart';
import 'views/setting/theme_page.dart';

class SparkRoute {
  bool? noAuth;
  Widget builder;

  SparkRoute({required this.builder, this.noAuth});
}

class MYRouter {
  static String homePagePath = '/';
  static String splashPagePath = '/splash';
  static String loginPagePath = '/login';
  static String aboutPagePath = '/about';
  static String unknownPagePath = '/unknown';
  static String settingPagePath = '/setting';
  static String themePagePath = '/theme_page';

  static String get initialRoute => homePagePath;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Map<String, SparkRoute> routeTables = {
    //启动页
    splashPagePath: SparkRoute(noAuth: true, builder: const Splash()),
    //登录
    loginPagePath: SparkRoute(noAuth: false, builder: const Login()),
    //首页
    homePagePath: SparkRoute(builder: const Home()),

    //设置
    settingPagePath: SparkRoute(builder: Setting()),

    //主题
    themePagePath: SparkRoute(builder: const ThemePage()),
    // 未知
    unknownPagePath: SparkRoute(builder: const Unknown()),
  };

  ///路由拦截
  static Route generateRoute<T extends Object>(RouteSettings settings) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (_) {
        final profile = _.watch<Profile>();
        String? name = settings.name;
        SparkRoute? routeData = routeTables[name];
        Widget? builder = routeData?.builder;

        // Map<String, dynamic>? profile =
        //     PreferenceUtils.getMap<Map<String, dynamic>>('profile');

        if (routeData?.noAuth != true) {
          if (profile.user?.userToken == null) {
            // MYRouter.navigatorKey.currentState?.pushNamedAndRemoveUntil(
            //     MYRouter.loginPagePath, (route) => false);
            builder = const Login();
          }
        }

        builder ??= const Unknown();

        return builder;
      },
      settings: settings,
    );

    return route;
  }

  static RouteFactory get unknownRoute => (settings) {
        print('dwadawdawdw=> ${settings.name}');
        return MaterialPageRoute(builder: (_) => const Unknown());
      };
}
