// import 'package:bracket/service/api.dart';
import 'package:bracket/shared/theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '/plugins.dart';

void main() async {
  // 初始化插件前需调用初始化代码 runApp()函数之前
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// 初始持久化数据
  await PreferenceUtil.getInstance();
  // PreferenceUtil.clear();

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

class MyTheme {
  ThemeProvider? _provider;
  final BuildContext _context;
  final String _theme;

  ThemeData? get theme {
    if (_theme == ITheme.auto.value) {
      return _provider!.theme();
    }

    if (_theme == ITheme.dark.value) {
      return _provider!.dark();
    }

    if (_theme == ITheme.light.value) {
      return _provider!.light();
    }

    return null;
  }

  MyTheme(
    this._context,
    this._theme,
  ) {
    _provider = ThemeProvider(
      _context,
      Theme.of(_context).primaryColor,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final global = context.watch<Global>();

    SparkPxFit.initialize(context);

    return MaterialApp(
      title: 'Bracket',
      theme: MyTheme(context, global.theme!).theme,
      navigatorKey: MYRouter.navigatorKey,
      initialRoute: MYRouter.homePagePath,
      onGenerateRoute: MYRouter.generateRoute,
      onUnknownRoute: MYRouter.unknownRoute,
      builder: (context, widget) {
        return MediaQuery(
          //设置全局的文字的textScaleFactor为1.0，文字不再随系统设置改变
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: widget!,
        );
      },
    );
  }
}
