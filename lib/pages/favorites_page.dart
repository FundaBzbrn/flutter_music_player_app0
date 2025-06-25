import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/app_song_model.dart';
import 'package:flutter_application_0/database_helper.dart';
import 'package:flutter_application_0/pages/now_playing_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final dbHelper = DatabaseHelper.instance;
  late Future<List<AppSong>> _favoriteSongsFuture;
  
  get favoriteSongs => null;

  @override
  void initState() {
    super.initState();
    _loadFavoriteSongs();
  }

  void _loadFavoriteSongs() {
    setState(() { _favoriteSongsFuture = dbHelper.getFavoriteSongs(); });
  }

  Future<void> _refreshFavorites() async { _loadFavoriteSongs(); }

  Widget _buildDefaultArt(ColorScheme colorScheme, double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: colorScheme.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(6.0)),
      child: Icon(Icons.music_note_rounded, color: colorScheme.onSecondary.withOpacity(0.5), size: size * 0.6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('F A V O R İ L E R', style: appBarTheme.titleTextStyle?.copyWith(color: colorScheme.onSurface) ?? TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: appBarTheme.elevation ?? 0,
        iconTheme: appBarTheme.iconTheme ?? IconThemeData(color: colorScheme.onSurface),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AppSong>>(
        future: _favoriteSongsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          if (snapshot.hasError) return Center(child: Text("Favoriler yüklenirken hata: ${snapshot.error}", style: TextStyle(color: colorScheme.error)));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("Henüz favori şarkın yok.", style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 16)));

          final List<AppSong> favoriteSongsList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            itemCount: favoriteSongsList.length,
            itemBuilder: (context, index) {
              final AppSong song = favoriteSongsList[index];
              return Card(
                elevation: Theme.of(context).cardTheme.elevation ?? 1.5,
                margin: Theme.of(context).cardTheme.margin ?? const EdgeInsets.symmetric(vertical: 6.0),
                color: Theme.of(context).cardTheme.color ?? colorScheme.secondary,
                shape: Theme.of(context).cardTheme.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  leading: Hero(
                     tag: 'albumArt_${song.id ?? song.filePath}_favorites', // Benzersiz tag
                     child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: song.imagePath != null && song.imagePath!.isNotEmpty
                          ? Image.asset(song.imagePath!, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c,e,s) => _buildDefaultArt(colorScheme, 50))
                          : _buildDefaultArt(colorScheme, 50),
                    ),
                  ),
                  title: Text(song.title, style: textTheme.titleMedium?.copyWith(color: colorScheme.onSecondary, fontWeight: FontWeight.w500) ?? TextStyle(color: colorScheme.onSecondary, fontWeight: FontWeight.w500, fontSize: 16)),
                  subtitle: Text(song.artist ?? "Bilinmeyen Sanatçı", style: textTheme.bodySmall?.copyWith(color: colorScheme.onSecondary.withOpacity(0.7)) ?? TextStyle(color: colorScheme.onSecondary.withOpacity(0.7), fontSize: 14)),
                  trailing: IconButton(
                    icon: Icon(Icons.play_circle_fill_rounded, color: colorScheme.primary, size: 30),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NowPlayingPage(
                            song: song,
                            songQueue: favoriteSongsList,
                            initialIndex: index,
                          ),
                        ),
                      );
                      _refreshFavorites();
                    },
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlayingPage(
                          song: song,
                          songQueue: favoriteSongs,
                          initialIndex: index,
                        ),
                      ),
                    );
                    _refreshFavorites();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}