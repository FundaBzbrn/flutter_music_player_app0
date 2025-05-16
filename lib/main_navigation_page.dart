import 'package:flutter/material.dart';
import 'package:flutter_application_0/pages/home_page.dart';       // Proje adına göre yolu güncelle
import 'package:flutter_application_0/pages/search_page.dart';    // Proje adına göre yolu güncelle
import 'package:flutter_application_0/pages/library_page.dart';   // Proje adına göre yolu güncelle
import 'package:flutter_application_0/pages/settings_page.dart';  // Proje adına göre yolu güncelle
// import 'package:my_music_app/pages/favorites_page.dart'; // Eğer Favoriler'i BottomNavBar'a eklemek isterseniz

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  // BottomNavigationBar'daki sıraya göre olmalı
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    LibraryPage(),
    // FavoritesPage(), // Eğer Favoriler'i BottomNavBar'a eklemek isterseniz aktif edin
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // Sayfalar arasında geçiş yaparken state'i korur
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor ?? Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? Theme.of(context).colorScheme.inversePrimary.withOpacity(0.6),
        type: Theme.of(context).bottomNavigationBarTheme.type ?? BottomNavigationBarType.fixed, // 3'ten fazla öğe için
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Arama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_rounded),
            label: 'Kütüphanem',
          ),
          // BottomNavigationBarItem( // Eğer Favoriler'i BottomNavBar'a eklemek isterseniz aktif edin
          //   icon: Icon(Icons.favorite_rounded),
          //   label: 'Favoriler',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}