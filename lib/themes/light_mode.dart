import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100,
    primary: Colors.green.shade700,      // ANA VURGU RENGİ (Koyu Yeşil)
    secondary: Colors.white,
    tertiary: Colors.teal.shade500,       // Ek vurgu rengi
    onPrimary: Colors.white,
    onSecondary: Colors.black87,
    onSurface: Colors.black87,
    error: Colors.red.shade700,
    onError: Colors.white,
    surfaceContainerHighest: Colors.grey.shade300,
    outline: Colors.grey.shade400,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade100,
    foregroundColor: Colors.black87,
    elevation: 0.5,
    titleTextStyle: const TextStyle(
        color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: const IconThemeData(color: Colors.black87),
    actionsIconTheme: const IconThemeData(color: Colors.black87),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.green.shade700, // Koyu Yeşil
    unselectedItemColor: Colors.grey.shade600,
    type: BottomNavigationBarType.fixed,
    elevation: 2.0,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.grey.shade100,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade200,
    hintStyle: TextStyle(color: Colors.grey.shade500),
    prefixIconColor: Colors.grey.shade600,
    suffixIconColor: Colors.grey.shade600,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.green.shade700, width: 1.5), // Odaklandığında Koyu Yeşil kenarlık
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey.shade200,
    labelStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(color: Colors.green.shade700.withOpacity(0.5), width: 1.0), // Chip kenarlığı Koyu Yeşil
    ),
    selectedColor: Colors.green.shade700.withOpacity(0.2),
  ),
  cardTheme: CardTheme(
    elevation: 1.0,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green.shade700,
    foregroundColor: Colors.white,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.green.shade700; // Yeşil
      }
      return Colors.grey.shade300;
    }),
    trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.green.shade700.withOpacity(0.5); // Yeşil
      }
      return Colors.grey.shade400;
    }),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.green.shade700, // Yeşil
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.black87,
  ),
  primaryIconTheme: IconThemeData(
    color: Colors.green.shade700, // Yeşil
  ),
  listTileTheme: ListTileThemeData(
    iconColor: Colors.green.shade700, // Yeşil
  ),
);