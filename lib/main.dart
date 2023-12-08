import 'package:bracket/shared/theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '/plugins.dart';

void main() async {
  // 初始化插件前需调用初始化代码 runApp()函数之前
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// 初始持久化数据
  await PreferenceUtils.getInstance();

  Future.delayed(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Global>(
            create: (_) => Global(),
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

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<Global>().theme;
    SparkPxFit.initialize(context);

    final settings = ThemeSettings(
      sourceColor: Colors.white,
      themeMode: ThemeMode.dark,
    );

    return MaterialApp(
      title: 'Bracket',
      theme: theme == ITheme.light.value
          ? ThemeProvider(settings).light()
          : ThemeProvider(settings).dark(),
      navigatorKey: MYRouter.navigatorKey,
      initialRoute: MYRouter.homePath,
      onGenerateRoute: MYRouter.generateRoute,
      onUnknownRoute: MYRouter.unknownRoute,
    );
  }
}
