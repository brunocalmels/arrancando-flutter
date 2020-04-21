import 'package:arrancando/config/state/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Utils {
  static restoreThemeMode(BuildContext context) async {
    MainState mainState = Provider.of<MainState>(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool themeDark = prefs.getBool("theme-dark");
    if (themeDark != null)
      mainState.setActiveTheme(themeDark ? ThemeMode.dark : ThemeMode.light);
    else
      mainState.setActiveTheme(ThemeMode.dark);
  }

  static toggleThemeMode(BuildContext context) async {
    MainState mainState = Provider.of<MainState>(context);
    ThemeMode newTheme = ThemeMode.dark;
    if (mainState.activeTheme == ThemeMode.dark) newTheme = ThemeMode.light;
    mainState.setActiveTheme(newTheme);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("theme-dark", newTheme == ThemeMode.dark);
  }
}
