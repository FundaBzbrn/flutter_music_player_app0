import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF121212),       //  koyu arka plan
    primary: Colors.green.shade400,         // ANA VURGU RENGİ ( - Açık Ton)
    secondary: const Color(0xFF1E1E1E),     // Kartlar, input alanları için
    tertiary: Colors.teal.shade300,         // Ek vurgu rengi (Yeşile yakın bir ton)
    onPrimary: Colors.black,                // Primary (Yeşil) üzerindeki metin/ikon
    onSecondary: Colors.white.withOpacity(0.87),
    onSurface: Colors.white.withOpacity(0.87),
    error: Colors.redAccent.shade200,
    onError: Colors.black,
    surfaceContainerHighest: const Color(0xFF2C2C2C),
    outline: Colors.grey.shade700,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF121212),
    foregroundColor: Colors.white.withOpacity(0.87),
    elevation: 0,
    titleTextStyle: TextStyle(
        color: Colors.white.withOpacity(0.87), fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.white.withOpacity(0.87)),
    actionsIconTheme: IconThemeData(color: Colors.white.withOpacity(0.87)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF181818),
    selectedItemColor: Colors.green.shade400, // Yeşil
    unselectedItemColor: Colors.grey.shade500,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: const Color(0xFF121212),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2A2A2A),
    hintStyle: TextStyle(color: Colors.grey.shade600),
    prefixIconColor: Colors.grey.shade500,
    suffixIconColor: Colors.grey.shade500,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.green.shade400, width: 1.5), // Odaklandığında Yeşil kenarlık
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFF2A2A2A),
    labelStyle: TextStyle(color: Colors.white.withOpacity(0.87), fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(color: Colors.green.shade400.withOpacity(0.5), width: 1.0), // Chip kenarlığı Yeşil
    ),
    selectedColor: Colors.green.shade400.withOpacity(0.3),
  ),
  cardTheme: CardTheme(
    elevation: 0.5,
    color: const Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green.shade400,
    foregroundColor: Colors.black,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.green.shade400; // Aktifken top rengi Yeşil
      }
      return Colors.grey.shade400;
    }),
    trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.green.shade400.withOpacity(0.5); // Aktifken iz rengi Yeşil
      }
      return Colors.grey.shade600;
    }),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.green.shade400, // Metin rengi Yeşil
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.white.withOpacity(0.87),
  ),
  primaryIconTheme: IconThemeData(
    color: Colors.green.shade400, // Primary ikonlar Yeşil
  ),
  listTileTheme: ListTileThemeData(
    iconColor: Colors.green.shade400, // ListTile ikonları Yeşil
  ),
);