import 'package:flutter/material.dart';

ThemeData appTheme(bool isDarkTheme) {
  return isDarkTheme
      ? ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          hintColor: Color(0xFFD97757),
          colorScheme: ColorScheme.dark(
            background: Color(0xFF2C2B28),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Color(0xFFD97757),
            unselectedItemColor: Colors.grey,
          ),
        )
      : ThemeData.light().copyWith(
          primaryColor: Colors.white,
          hintColor: Color(0xFFD97757),
          colorScheme: ColorScheme.light(
            background: Color(0xFFF2F0E8),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFFD97757),
            unselectedItemColor: Colors.grey,
          ),
        );
}
