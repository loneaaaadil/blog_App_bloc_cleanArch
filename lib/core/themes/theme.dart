import 'package:blog_app/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
    ),
    chipTheme: ChipThemeData(
        color: WidgetStatePropertyAll(AppPallete.backgroundColor),
        side: BorderSide.none),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      border: border(),
      enabledBorder: border(),
      focusedBorder: border(AppPallete.gradient2),
      errorBorder: border(AppPallete.errorColor),
    ),
  );
}
