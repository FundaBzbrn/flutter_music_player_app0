import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/pages/home_page.dart';
import 'package:flutter_application_0/pages/search_page.dart';
import 'package:flutter_application_0/pages/library_page.dart';
import 'package:flutter_application_0/pages/settings_page.dart';
import 'package:flutter_application_0/pages/now_playing_page.dart'; // NowPlayingPage'i açmak için
import 'package:flutter_application_0/providers/music_player_provider.dart'; // MusicPlayerProvider
import 'package:provider/provider.dart';
import 'package:flutter_application_0/models/app_song_model.dart'; // AppSong modeli için

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    LibraryPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildMiniPlayer(BuildContext context, MusicPlayerProvider playerProvider) {
    final AppSong? currentSong = playerProvider.currentSong;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (currentSong == null || (playerProvider.playerState == PlayerState.stopped && (playerProvider.position == Duration.zero))) {
      // Eğer hiç şarkı seçilmemişse veya çalma tamamen durmuş ve başa sarmışsa mini player'ı gösterme
      return const SizedBox.shrink(); // Boş bir widget döndürerek gizle
    }

    return GestureDetector(
      onTap: () {
        // Mini player'a tıklanınca NowPlayingPage'i aç
        // NowPlayingPage artık Provider'dan mevcut şarkıyı alacağı için parametreye gerek yok.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NowPlayingPage(
              song: currentSong,
              songQueue: playerProvider.songQueue ?? const [],
              initialIndex: playerProvider.currentSongIndex ?? 0,
            ),
          ),
        );
      },
      child: Container(
        height: 65, // Yükseklik biraz artırıldı
        color: colorScheme.surfaceContainerHighest.withOpacity(0.95), // Hafif transparan veya solid
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            // Albüm Kapağı
            Hero( // Mini player'daki kapak için de Hero
              tag: 'albumArt_${currentSong.id ?? currentSong.filePath}', // NowPlayingPage ile aynı tag
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: currentSong.imagePath != null && currentSong.imagePath!.isNotEmpty
                    ? Image.asset(currentSong.imagePath!, width: 45, height: 45, fit: BoxFit.cover,
                        errorBuilder: (c,e,s) => Container(width: 45, height: 45, color: colorScheme.secondary, child: Icon(Icons.music_note, size: 24, color: colorScheme.onSecondary)))
                    : Container(width: 45, height: 45, color: colorScheme.secondary, child: Icon(Icons.music_note, size: 24, color: colorScheme.onSecondary)),
              ),
            ),
            const SizedBox(width: 12),
            // Şarkı Adı ve Sanatçı
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentSong.title,
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    currentSong.artist ?? "Bilinmeyen Sanatçı",
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Oynat/Duraklat Butonu
            IconButton(
              icon: Icon(
                playerProvider.isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 32, // Biraz daha büyük
              ),
              onPressed: () {
                if (playerProvider.isPlaying) {
                  playerProvider.pause();
                } else {
                  playerProvider.resume(); // Eğer duraklatılmışsa devam et
                }
              },
            ),
            // İsteğe bağlı: Sonraki şarkı butonu
            // IconButton(
            //   icon: Icon(Icons.skip_next_rounded, color: colorScheme.onSurfaceVariant, size: 30),
            //   onPressed: playerProvider.playNext,
            // ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<MusicPlayerProvider>(context); // Dinlemek için build içinde
    final bottomNavBarTheme = Theme.of(context).bottomNavigationBarTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMiniPlayer(context, playerProvider), // Mini player'ı burada çağır
          BottomNavigationBar(
            backgroundColor: bottomNavBarTheme.backgroundColor ?? colorScheme.surface,
            selectedItemColor: bottomNavBarTheme.selectedItemColor ?? colorScheme.primary,
            unselectedItemColor: bottomNavBarTheme.unselectedItemColor ?? colorScheme.onSurface.withOpacity(0.6),
            type: bottomNavBarTheme.type ?? BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Ana Sayfa'),
              BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Arama'),
              BottomNavigationBarItem(icon: Icon(Icons.library_music_rounded), label: 'Kütüphanem'),
              BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Ayarlar'),
            ],
          ),
        ],
      ),
    );
  }
}