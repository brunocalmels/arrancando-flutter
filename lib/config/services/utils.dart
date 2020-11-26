import 'package:arrancando/config/state/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Utils {
  static Future<void> restoreThemeMode(BuildContext context) async {
    final mainState = Provider.of<MainState>(context);
    final prefs = await SharedPreferences.getInstance();
    final themeDark = prefs.getBool('theme-dark');
    if (themeDark != null) {
      mainState.setActiveTheme(themeDark ? ThemeMode.dark : ThemeMode.light);
    } else {
      mainState.setActiveTheme(ThemeMode.dark);
    }
  }

  static Future<void> toggleThemeMode(BuildContext context) async {
    final mainState = Provider.of<MainState>(context);
    var newTheme = ThemeMode.dark;
    if (mainState.activeTheme == ThemeMode.dark) newTheme = ThemeMode.light;
    mainState.setActiveTheme(newTheme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme-dark', newTheme == ThemeMode.dark);
  }

  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusManager.instance.primaryFocus.unfocus();
  }
}
