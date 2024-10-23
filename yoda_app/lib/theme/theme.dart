import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primaryColor = Color(0xff66713e);
const Color accentColor = Color(0xffC3CDA6);
const Color cardColor = Color(0xffDAE0C8);

const MaterialColor primaryMaterialColor = MaterialColor(
  4284903742,
  <int, Color>{
    50: Color.fromRGBO(
      102,
      113,
      62,
      .1,
    ),
    100: Color.fromRGBO(
      102,
      113,
      62,
      .2,
    ),
    200: Color.fromRGBO(
      102,
      113,
      62,
      .3,
    ),
    300: Color.fromRGBO(
      102,
      113,
      62,
      .4,
    ),
    400: Color.fromRGBO(
      102,
      113,
      62,
      .5,
    ),
    500: Color.fromRGBO(
      102,
      113,
      62,
      .6,
    ),
    600: Color.fromRGBO(
      102,
      113,
      62,
      .7,
    ),
    700: Color.fromRGBO(
      102,
      113,
      62,
      .8,
    ),
    800: Color.fromRGBO(
      102,
      113,
      62,
      .9,
    ),
    900: Color.fromRGBO(
      102,
      113,
      62,
      1,
    ),
  },
);

AppBarTheme appBarTheme = const AppBarTheme(
  systemOverlayStyle: SystemUiOverlayStyle.dark,
  backgroundColor: Colors.transparent,
  centerTitle: true,
  iconTheme: IconThemeData(color: Colors.black),
  titleTextStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 20,
  ),
);

InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(
      color: accentColor,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(
      color: Colors.red,
    ),
  ),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 15,
    vertical: 15,
  ),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  splashColor: primaryMaterialColor.shade100,
  primarySwatch: primaryMaterialColor,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: primaryMaterialColor,
    accentColor: accentColor,
    cardColor: cardColor,
  ),
  inputDecorationTheme: inputDecorationTheme,
  appBarTheme: appBarTheme,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  primarySwatch: primaryMaterialColor,
);
