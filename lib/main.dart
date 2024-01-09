import 'package:bracket/shared/theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '/plugins.dart';

void main() async {
  // 初始化插件前需调用初始化代码 runApp()函数之前
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// 初始持久化数据
  await PreferenceUtil.getInstance();
  // PreferenceUtils.clear();

  Future.delayed(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Global>(
            create: (_) => Global(_),
          ),
          ChangeNotifierProvider<Profile>(
            create: (_) => Profile(),
          ),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData? themeData(BuildContext context, theme) {
    switch (theme) {
      case ITheme.dark:
        return ThemeProvider(context).dark();
      case ITheme.light:
        return ThemeProvider(context).light();
      default:
        return ThemeProvider(context).theme();
    }
  }

  @override
  Widget build(BuildContext context) {
    final global = context.watch<Global>();

    SparkPxFit.initialize(context);

    return MaterialApp(
      title: 'Bracket',
      theme: themeData(context, global.theme),
      navigatorKey: MYRouter.navigatorKey,
      initialRoute: MYRouter.homePagePath,
      onGenerateRoute: MYRouter.generateRoute,
      onUnknownRoute: MYRouter.unknownRoute,
    );
  }
}
