import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100,          // Ana arka plan (daha açık)
    primary: Colors.blue.shade700,          // Ana etkileşim rengi (Spotify'a benzer canlı mavi)
    secondary: Colors.white,                // Kartlar, input alanları için (saf beyaz)
    tertiary: Colors.green.shade500,        // Ek vurgu rengi
    onPrimary: Colors.white,                // primary üzerindeki metin/ikon rengi
    onSecondary: Colors.black87,            // secondary (beyaz) üzerindeki metin/ikon rengi
    onSurface: Colors.black87,              // surface (açık gri) üzerindeki metin/ikon rengi
    inversePrimary: Colors.grey.shade800,   // Koyu moddaki primary'nin tersi gibi (genel metinler için)
    error: Colors.red.shade700,
    onError: Colors.white,
    surfaceVariant: Colors.grey.shade300, // Divider, switch track gibi elemanlar için
    outline: Colors.grey.shade400,       // Kenarlıklar için
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade100, // surface ile aynı
    foregroundColor: Colors.black87,       // onSurface ile aynı (ikonlar ve başlık için)
    elevation: 0.5, // Hafif bir gölge
    titleTextStyle: const TextStyle(
        color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: const IconThemeData(color: Colors.black87),
    actionsIconTheme: const IconThemeData(color: Colors.black87),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,         // secondary ile aynı
    selectedItemColor: Colors.blue.shade700, // primary ile aynı
    unselectedItemColor: Colors.grey.shade600,
    type: BottomNavigationBarType.fixed,
    elevation: 2.0, // Hafif bir gölge
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.grey.shade100, // surface ile aynı
  ),
  inputDecorationTheme: InputDecorationTheme( // TextField tema ayarları
    filled: true,
    fillColor: Colors.grey.shade200, // Açık modda input alanı arka planı
    hintStyle: TextStyle(color: Colors.grey.shade500),
    prefixIconColor: Colors.grey.shade600,
    suffixIconColor: Colors.grey.shade600,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder( // Odaklandığında kenarlık
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.blue.shade700, width: 1.5),
    ),
  ),
  chipTheme: ChipThemeData( // Chip tema ayarları
    backgroundColor: Colors.grey.shade200,
    labelStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(color: Colors.blue.shade700.withOpacity(0.5), width: 1.0),
    ),
  ),
  cardTheme: CardTheme( // Card tema ayarları
    elevation: 1.0,
    color: Colors.white, // secondary ile aynı
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
  ),
);