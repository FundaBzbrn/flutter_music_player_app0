import 'package:flutter/material.dart';
import 'package:flutter_application_0/pages/settings_page.dart'; // Proje adına göre yolu güncelle
import 'package:flutter_application_0/pages/favorites_page.dart'; // Proje adına göre yolu güncelle (Favoriler eklenecekse)

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.secondary,
            ),
            child: Center(
              child: Text(
                'M Ü Z İ K  U Y G U L A M A S I',
                style: TextStyle(
                  color: colorScheme.inversePrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 10.0),
            child: ListTile(
              title: Text(
                "A N A  S A Y F A",
                style: TextStyle(color: colorScheme.inversePrimary),
              ),
              leading: Icon(Icons.home_rounded, color: colorScheme.inversePrimary),
              onTap: () {
                Navigator.pop(context); // Drawer'ı kapat
                // Eğer MainNavigationPage'de _selectedIndex ile yönetiliyorsa
                // ve HomePage ilk sayfa (index 0) ise, direkt drawer'ı kapatmak yeterli.
                // Veya Navigasyon state'ini güncelleyebilirsiniz. Şimdilik sadece kapatıyoruz.
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 0),
            child: ListTile(
              title: Text(
                "F A V O R İ L E R", // Favoriler için drawer öğesi
                style: TextStyle(color: colorScheme.inversePrimary),
              ),
              leading: Icon(Icons.favorite_rounded, color: colorScheme.inversePrimary),
              onTap: () {
                Navigator.pop(context); // Drawer'ı kapat
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 0),
            child: ListTile(
              title: Text(
                "A Y A R L A R",
                style: TextStyle(color: colorScheme.inversePrimary),
              ),
              leading: Icon(Icons.settings_rounded, color: colorScheme.inversePrimary),
              onTap: () {
                Navigator.pop(context); // Drawer'ı kapat
                // SettingsPage zaten BottomNavBar'da olduğu için oradan erişilebilir.
                // İsterseniz buradan da yönlendirme yapabilirsiniz:
                /*
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
                */
                // Ya da BottomNavBar'daki ilgili sekmeye geçişi sağlayabilirsiniz.
                // Bu, MainNavigationPage'deki state'i değiştirmeyi gerektirir.
                // Şimdilik, SettingsPage'e BottomNavBar'dan erişileceğini varsayalım.
                // Eğer drawer'dan direkt SettingsPage'e gitmek isterseniz:
                // Not: Eğer SettingsPage BottomNav'da ise bu gereksiz olabilir.
                // (context.findAncestorStateOfType<_MainNavigationPageState>() as _MainNavigationPageState)._onItemTapped(3);
                // Yukarıdaki yöntem _MainNavigationPageState'e erişim gerektirir ve çok önerilmez.
                // Daha iyi bir yöntem, Provider veya callback kullanmaktır.
                // Şimdilik, Ayarlar zaten BottomNav'da olduğundan sadece drawer'ı kapatıyoruz.
                // Veya direk SettingsPage'e push edebilirsiniz:
                Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => const SettingsPage(), // SettingsPage'e direkt yönlendirme
                     ),
                   );
              },
            ),
          ),
        ],
      ),
    );
  }
}