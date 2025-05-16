import 'package:flutter/material.dart';
// import 'package:my_music_app/pages/favorites_page.dart'; // Eğer favorilere buradan yönlendirme yapılacaksa

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  Widget _buildLibraryCategory({
    required BuildContext context,
    required IconData icon,
    required String title,
    int? itemCount,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary, size: 28),
      title: Text(title, style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500, fontSize: 17)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (itemCount != null)
            Text(
              itemCount.toString(),
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 14),
            ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colorScheme.onSurface.withOpacity(0.7)),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'K Ü T Ü P H A N E M',
          style: appBarTheme.titleTextStyle ?? TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: appBarTheme.elevation ?? 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top:10.0), // AppBar ile ilk eleman arasına boşluk
        children: [
          _buildLibraryCategory(
            context: context,
            icon: Icons.playlist_play_rounded,
            title: "Çalma Listeleri",
            itemCount: 5,
            onTap: () {
              print("Çalma Listeleri tıklandı");
              // Çalma listeleri detay sayfasına git
            },
          ),
          Divider(color: colorScheme.secondary.withOpacity(0.7), indent: 20, endIndent: 20, height: 1),
          _buildLibraryCategory(
            context: context,
            icon: Icons.album_rounded,
            title: "Albümler",
            itemCount: 12,
            onTap: () {
              print("Albümler tıklandı");
            },
          ),
          Divider(color: colorScheme.secondary.withOpacity(0.7), indent: 20, endIndent: 20, height: 1),
          _buildLibraryCategory(
            context: context,
            icon: Icons.mic_external_on_rounded, // Podcast ikonu
            title: "Podcast'ler",
            itemCount: 3,
            onTap: () {
              print("Podcast'ler tıklandı");
            },
          ),
          Divider(color: colorScheme.secondary.withOpacity(0.7), indent: 20, endIndent: 20, height: 1),
          _buildLibraryCategory(
            context: context,
            icon: Icons.person_rounded,
            title: "Sanatçılar",
            itemCount: 8,
            onTap: () {
              print("Sanatçılar tıklandı");
            },
          ),
          Divider(color: colorScheme.secondary.withOpacity(0.7), indent: 20, endIndent: 20, height: 1),
          _buildLibraryCategory(
            context: context,
            icon: Icons.favorite_rounded, // Dolu favori ikonu
            title: "Beğenilen Şarkılar", // Spotify'daki gibi
            itemCount: 23,
            onTap: () {
              print("Beğenilen Şarkılar tıklandı");
              // FavoritesPage'e yönlendirme (eğer ayrı bir sayfa ise ve drawer'da yoksa)
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
            },
          ),
          Divider(color: colorScheme.secondary.withOpacity(0.7), indent: 20, endIndent: 20, height: 1),
          _buildLibraryCategory(
            context: context,
            icon: Icons.download_for_offline_rounded, // Daha uygun indirme ikonu
            title: "İndirilenler",
            itemCount: 7,
            onTap: () {
              print("İndirilenler tıklandı");
            },
          ),
        ],
      ),
    );
  }
}