import 'package:flutter/material.dart';
import 'package:saleshoppingapp/constant/color.dart';

ThemeData themeData = ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    border: outlineInputBorder,
    errorBorder: outlineInputBorder,
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    disabledBorder: outlineInputBorder,
    prefixIconColor: ColorInstance.backgroundColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorInstance.backgroundColor,
      disabledBackgroundColor: Colors.grey,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white
      )
    )
  )
);
OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: ColorInstance.backgroundColor
  )
);