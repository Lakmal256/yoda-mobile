import 'package:flutter/material.dart';

class AppTheme extends ValueNotifier<ThemeData>{
  AppTheme(ThemeData defaultTheme): super(defaultTheme);

  setTheme(ThemeData themeData){
    value = themeData;
    notifyListeners();
  }
}