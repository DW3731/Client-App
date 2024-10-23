import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFFce0303),
  secondaryHeaderColor: const Color(0xFFFA0909),
  disabledColor: const Color(0xffa2a7ad),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor: const Color(0xFF141313),
  shadowColor: Colors.white.withOpacity(0.03),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(0xFFce0303))),
  colorScheme: const ColorScheme.dark(primary: Color(0xFFce0303),
    tertiary: Color(0xff6165D7),
    tertiaryContainer: Color(0xff171DB6),
    secondary: Color(0xFFFA0909)).copyWith(surface: const Color(0xFF272727)).copyWith(error: const Color(0xFFce0303),
  ),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white10),
  floatingActionButtonTheme: FloatingActionButtonThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))),
  bottomAppBarTheme: const BottomAppBarTheme(
    surfaceTintColor: Colors.black, height: 60,
    padding: EdgeInsets.symmetric(vertical: 5),
  ),
  dividerTheme: DividerThemeData(color: const Color(0xffa2a7ad).withOpacity(0.25), thickness: 0.5),
  tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
);
