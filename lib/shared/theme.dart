import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class ThemeProvider {
  ThemeProvider(this.settings);

  final ThemeSettings settings;

  final pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  Color blend(Color targetColor) {
    return Color(
        Blend.harmonize(targetColor.value, settings.sourceColor.value));
  }

  Color source(Color? target) {
    Color source = settings.sourceColor;
    if (target != null) {
      source = blend(target);
    }
    return source;
  }

  ColorScheme colors(Brightness brightness, Color? targetColor) {
    return ColorScheme.fromSeed(
      seedColor: source(targetColor),
      brightness: brightness,
    );
  }

  ShapeBorder get shapeMedium => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      );

  CardTheme cardTheme() {
    return CardTheme(
      // elevation: 0,
      shape: shapeMedium,
      clipBehavior: Clip.antiAlias,
    );
  }

  ListTileThemeData listTileTheme(ColorScheme colors) {
    return ListTileThemeData(
      shape: shapeMedium,
      selectedColor: colors.secondary,
    );
  }

  AppBarTheme appBarTheme(ColorScheme colors) {
    return AppBarTheme(
      // elevation: 0,
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
      // elevation: 0,
    );
  }

  BottomNavigationBarThemeData bottomNavigationBarTheme(ColorScheme colors) {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: colors.surfaceVariant,
      selectedItemColor: colors.onSurface,
      unselectedItemColor: colors.onSurfaceVariant,
      // elevation: 0,
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

  ThemeData light([Color? targetColor]) {
    final selfColor = colors(Brightness.light, targetColor);
    return ThemeData.light().copyWith(
      pageTransitionsTheme: pageTransitionsTheme,
      colorScheme: selfColor,
      appBarTheme: appBarTheme(selfColor),
      cardTheme: cardTheme(),
      listTileTheme: listTileTheme(selfColor),
      bottomAppBarTheme: bottomAppBarTheme(selfColor),
      bottomNavigationBarTheme: bottomNavigationBarTheme(selfColor),
      navigationRailTheme: navigationRailTheme(selfColor),
      tabBarTheme: tabBarTheme(selfColor),
      drawerTheme: drawerTheme(selfColor),
      scaffoldBackgroundColor: selfColor.background,
    );
  }

  ThemeData dark([Color? targetColor]) {
    final selfColor = colors(Brightness.dark, targetColor);
    return ThemeData.dark().copyWith(
      pageTransitionsTheme: pageTransitionsTheme,
      colorScheme: selfColor,
      appBarTheme: appBarTheme(selfColor),
      cardTheme: cardTheme(),
      listTileTheme: listTileTheme(selfColor),
      bottomAppBarTheme: bottomAppBarTheme(selfColor),
      bottomNavigationBarTheme: bottomNavigationBarTheme(selfColor),
      navigationRailTheme: navigationRailTheme(selfColor),
      tabBarTheme: tabBarTheme(selfColor),
      drawerTheme: drawerTheme(selfColor),
      scaffoldBackgroundColor: selfColor.background,
    );
  }

  ThemeData theme(BuildContext context, [Color? targetColor]) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.light
        ? light(targetColor)
        : dark(targetColor);
  }
}

class ThemeSettings {
  ThemeSettings({
    required this.sourceColor,
    required this.themeMode,
  });

  final Color sourceColor;
  final ThemeMode themeMode;
}
