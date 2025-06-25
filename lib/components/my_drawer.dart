import 'package:flutter/material.dart';
import 'package:flutter_application_0/pages/favorites_page.dart';
import 'package:flutter_application_0/pages/settings_page.dart';
// Proje adına göre yolu güncelle
// Proje adına göre yolu güncelle

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme; // Daha iyi metin stilleri için

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.secondary, // Veya colorScheme.primary.withOpacity(0.1) gibi bir ton
            ),
            child: Center(
              child: Text(
                'F F T İ F Y  M Ü Z İ K',
                style: TextStyle(
                  color: colorScheme.primary, // Başlık rengini primary yapalım
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5, // Harf aralığı
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 15.0), // Sol padding biraz azaltıldı
            child: ListTile(
              title: Text(
                "A N A  S A Y F A",
                style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.87), // Daha görünür bir gri tonu
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                ),
              ),
              leading: Icon(Icons.home_rounded, color: colorScheme.primary), // İkon rengi primary
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 5.0),
            child: ListTile(
              title: Text(
                "F A V O R İ L E R",
                style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.87),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                ),
              ),
              leading: Icon(Icons.favorite_rounded, color: colorScheme.primary), // İkon rengi primary
              onTap: () {
                Navigator.pop(context);
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
            padding: const EdgeInsets.only(left: 20.0, top: 5.0),
            child: ListTile(
              title: Text(
                "A Y A R L A R",
                style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.87),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                ),
              ),
              leading: Icon(Icons.settings_rounded, color: colorScheme.primary), // İkon rengi primary
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => const SettingsPage(),
                     ),
                   );
              },
            ),
          ),
          // İsteğe bağlı: En alta bir ayırıcı veya boşluk eklenebilir
          const Spacer(), // Kalan alanı doldurur, aşağıdaki öğeleri en alta iter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Version 1.0.0', // Örnek versiyon bilgisi
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}