import '/plugins.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class ThemeProvider {
  BuildContext context;
  Color sourceColor;

  ThemeProvider(this.context, this.sourceColor);

  final pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  Color blend(Color targetColor) {
    return Color(
      Blend.harmonize(
        targetColor.value,
        sourceColor.value,
      ),
    );
  }

  Color source(Color? target) {
    Color source = sourceColor;
    if (target != null) {
      source = blend(target);
    }
    return source;
  }

  ColorScheme colors(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: sourceColor,
      brightness: brightness,
    );
  }

  // ShapeBorder get shapeMedium =>

  TextTheme textTheme(ColorScheme colors) {
    return const TextTheme().copyWith();
  }

  CardTheme cardTheme(ColorScheme colors) {
    return CardTheme(
      elevation: 0,
      color: colors.onInverseSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        // side: BorderSide(
        //   color: Theme.of(context).primaryColor.withOpacity(0.2),
        //   width: 1,
        //   strokeAlign: BorderSide.strokeAlignOutside,
        // ),
      ),
      clipBehavior: Clip.none,
      // shadowColor: Colors.transparent,
    );
  }

  ListTileThemeData listTileTheme(ColorScheme colors) {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        // side: BorderSide(
        //   color: Theme.of(context).primaryColor.withOpacity(0.5),
        //   width: 2,
        //   strokeAlign: BorderSide.strokeAlignOutside,
        // ),
      ),
      selectedColor: colors.secondary,
    );
  }

  AppBarTheme appBarTheme(ColorScheme colors) {
    return AppBarTheme(
      elevation: 0,
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
    );
  }

  TabBarTheme tabBarTheme(ColorScheme colors) {
    return TabBarTheme(
      labelColor: colors.secondary,
      unselectedLabelColor: colors.onSurfaceVariant,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.secondary,
            width: 2,
          ),
        ),
      ),
    );
  }

  BottomAppBarTheme bottomAppBarTheme(ColorScheme colors) {
    return BottomAppBarTheme(
      color: colors.surface,
      elevation: 0,
    );
  }

  BottomNavigationBarThemeData bottomNavigationBarTheme(ColorScheme colors) {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: colors.onSecondary,
      selectedItemColor: colors.onSurface,
      unselectedItemColor: colors.onSurfaceVariant,
      elevation: 0,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    );
  }

  NavigationRailThemeData navigationRailTheme(ColorScheme colors) {
    return const NavigationRailThemeData();
  }

  DrawerThemeData drawerTheme(ColorScheme colors) {
    return DrawerThemeData(
      backgroundColor: colors.surface,
    );
  }

  ThemeData light() {
    final selfColor = colors(Brightness.light);
    return ThemeData.light().copyWith(
        colorScheme: selfColor,
        primaryColor: sourceColor,
        pageTransitionsTheme: pageTransitionsTheme,
        appBarTheme: appBarTheme(selfColor),
        cardTheme: cardTheme(selfColor),
        listTileTheme: listTileTheme(selfColor),
        bottomAppBarTheme: bottomAppBarTheme(selfColor),
        bottomNavigationBarTheme: bottomNavigationBarTheme(selfColor),
        navigationRailTheme: navigationRailTheme(selfColor),
        tabBarTheme: tabBarTheme(selfColor),
        drawerTheme: drawerTheme(selfColor),
        // scaffoldBackgroundColor: selfColor.background,
        snackBarTheme: const SnackBarThemeData().copyWith(
          behavior: SnackBarBehavior.floating,
        ),
        // ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: sourceColor,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold)),
        ));
  }

  ThemeData dark() {
    final selfColor = colors(Brightness.dark);
    return ThemeData.dark().copyWith(
      colorScheme: selfColor,
      primaryColor: sourceColor,
      pageTransitionsTheme: pageTransitionsTheme,
      appBarTheme: appBarTheme(selfColor),
      cardTheme: cardTheme(selfColor),
      listTileTheme: listTileTheme(selfColor),
      bottomAppBarTheme: bottomAppBarTheme(selfColor),
      bottomNavigationBarTheme: bottomNavigationBarTheme(selfColor),
      navigationRailTheme: navigationRailTheme(selfColor),
      tabBarTheme: tabBarTheme(selfColor),
      drawerTheme: drawerTheme(selfColor),
      // scaffoldBackgroundColor: selfColor.background,
      snackBarTheme: const SnackBarThemeData().copyWith(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  ThemeData theme() {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.light ? light() : dark();
  }
}
