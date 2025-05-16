import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF121212),       // Spotify koyu arka plan
    primary: Colors.green.shade400,         // Spotify vurgu rengi (biraz daha açık yeşil)
    secondary: const Color(0xFF1E1E1E),     // Kartlar, input alanları için (biraz daha açık)
    tertiary: Colors.blueAccent.shade200,   // Ek vurgu rengi
    onPrimary: Colors.black,
    onSecondary: Colors.white.withOpacity(0.87), // secondary üzerindeki metin/ikon rengi
    onSurface: Colors.white.withOpacity(0.87),   // surface üzerindeki metin/ikon rengi
    inversePrimary: Colors.grey.shade300,
    error: Colors.redAccent.shade200,
    onError: Colors.black,
    surfaceVariant: const Color(0xFF2C2C2C), // Divider, switch track
    outline: Colors.grey.shade700,         // Kenarlıklar
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF121212), // surface ile aynı
    foregroundColor: Colors.white.withOpacity(0.87), // onSurface ile aynı
    elevation: 0,
    titleTextStyle: TextStyle(
        color: Colors.white.withOpacity(0.87), fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.white.withOpacity(0.87)),
    actionsIconTheme: IconThemeData(color: Colors.white.withOpacity(0.87)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF181818), // Biraz farklı bir ton
    selectedItemColor: Colors.green.shade400, // primary ile aynı
    unselectedItemColor: Colors.grey.shade500,
    type: BottomNavigationBarType.fixed,
    elevation: 0, // Genellikle koyu modda gölge olmaz
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: const Color(0xFF121212), // surface ile aynı
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2A2A2A), // Koyu modda input alanı arka planı
    hintStyle: TextStyle(color: Colors.grey.shade600),
    prefixIconColor: Colors.grey.shade500,
    suffixIconColor: Colors.grey.shade500,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.green.shade400, width: 1.5),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFF2A2A2A),
    labelStyle: TextStyle(color: Colors.white.withOpacity(0.87), fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(color: Colors.green.shade400.withOpacity(0.5), width: 1.0),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0.5,
    color: const Color(0xFF1E1E1E), // secondary ile aynı
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
  ),
);