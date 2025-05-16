import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  final List<Map<String, String>> favoriteSongs = const [
    {"image": "assets/images/album_art_1.webp", "title": "Yaz Rüyası", "artist": "Pop Sanatçısı"},
    {"image": "assets/images/album_art_3.webp", "title": "Akustik Akşamlar", "artist": "Folk Müzisyen"},
    {"image": "assets/images/album_art_2.webp", "title": "Gece Yolculuğu", "artist": "Elektronik DJ"},
    {"image": "assets/images/album_art_5.jpg", "title": "Enerji Patlaması", "artist": "Rock Grubu"},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        // Geri tuşu Drawer'dan gelindiği için otomatik eklenir.
        // Eğer BottomNavBar'dan geliniyorsa ve geri tuşu istenmiyorsa `automaticallyImplyLeading: false,`
        title: Text(
          'F A V O R İ L E R',
          style: appBarTheme.titleTextStyle ?? TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: appBarTheme.elevation ?? 0,
        iconTheme: appBarTheme.iconTheme ?? IconThemeData(color: colorScheme.onSurface), // Geri tuşu rengi için
        centerTitle: true,
      ),
      body: favoriteSongs.isEmpty
          ? Center(
              child: Text(
                "Henüz favori şarkın yok.",
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = favoriteSongs[index];
                return Card( // ListTile'ı Card ile sarmak daha şık durabilir
                  elevation: 1.5,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  color: colorScheme.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: Image.asset(
                        song["image"]!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                           return Container(width: 50, height: 50, color: colorScheme.onSecondary.withOpacity(0.1), child: Icon(Icons.music_note_rounded, color: colorScheme.onSecondary.withOpacity(0.5)));
                        }
                      ),
                    ),
                    title: Text(song["title"]!, style: TextStyle(color: colorScheme.onSecondary, fontWeight: FontWeight.w500, fontSize: 16)),
                    subtitle: Text(song["artist"]!, style: TextStyle(color: colorScheme.onSecondary.withOpacity(0.7), fontSize: 14)),
                    trailing: IconButton(
                      icon: Icon(Icons.play_circle_fill_rounded, color: colorScheme.primary, size: 30),
                      onPressed: () {
                        print("${song["title"]} çalınıyor...");
                      },
                    ),
                    onTap: () {
                       print("${song["title"]} detayları için tıklandı.");
                    },
                  ),
                );
              },
            ),
    );
  }
}