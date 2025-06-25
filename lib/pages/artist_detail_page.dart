import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/artist_model.dart';
import 'package:flutter_application_0/models/album_model.dart';
import 'package:flutter_application_0/models/app_song_model.dart';
import 'package:flutter_application_0/database_helper.dart';
import 'package:flutter_application_0/pages/album_detail_page.dart';
import 'package:flutter_application_0/pages/now_playing_page.dart';

class ArtistDetailPage extends StatefulWidget {
  final Artist artist;

  const ArtistDetailPage({super.key, required this.artist});

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  final dbHelper = DatabaseHelper.instance;
  late Future<List<Album>> _artistAlbumsFuture;
  late Future<List<AppSong>> _artistTopSongsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.artist.id != null) {
      _artistAlbumsFuture = dbHelper.getAlbumsByArtist(widget.artist.id!);
      _artistTopSongsFuture = dbHelper.getSongsByArtist(widget.artist.id!);
    } else {
      _artistAlbumsFuture = Future.value([]);
      _artistTopSongsFuture = Future.value([]);
      print("Sanatçı ID'si ArtistDetailPage'de bulunamadı.");
    }
  }

  String _formatDuration(int? totalSeconds) {
    if (totalSeconds == null || totalSeconds <= 0) return "";
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes.toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget _buildDefaultArt(ColorScheme colorScheme, IconData icon, double size, {double borderRadius = 8.0}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(icon, size: size * 0.6, color: colorScheme.onSecondary.withOpacity(0.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
            widget.artist.name,
            style: appBarTheme.titleTextStyle?.copyWith(color: colorScheme.onSurface) ??
                   TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)
        ),
        backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: appBarTheme.elevation ?? 0,
        iconTheme: appBarTheme.iconTheme ?? IconThemeData(color: colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sanatçı Banner (İsteğe Bağlı)
            // Container(
            //   height: 150,
            //   width: double.infinity,
            //   color: colorScheme.primary.withOpacity(0.1),
            //   child: Icon(Icons.mic_external_on_outlined, size: 60, color: colorScheme.primary),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                "Albümler",
                style: textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<Album>>(
              future: _artistAlbumsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 190, child: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                  return Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), child: Text("Albümler yüklenirken hata: ${snapshot.error}", style: TextStyle(color: colorScheme.error)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text("Bu sanatçıya ait albüm bulunamadı.", style: TextStyle(color: Colors.grey)),
                  );
                }
                final albums = snapshot.data!;
                return SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: albums.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      final album = albums[index];
                      return InkWell(
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumDetailPage(album: album)));
                        },
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1/1,
                                child: Hero(
                                  tag: 'albumArt_${album.id}_artistDetailList',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: album.imagePath != null && album.imagePath!.isNotEmpty
                                      ? Image.asset(album.imagePath!, fit: BoxFit.cover,
                                          errorBuilder: (c,e,s) => _buildDefaultArt(colorScheme, Icons.album, 140))
                                      : _buildDefaultArt(colorScheme, Icons.album, 140),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(album.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
                              Text(album.releaseYear?.toString() ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 10.0),
              child: Text(
                "Popüler Şarkılar",
                style: textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<AppSong>>(
              future: _artistTopSongsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                  return Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), child: Text("Şarkılar yüklenirken hata: ${snapshot.error}", style: TextStyle(color: colorScheme.error)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text("Bu sanatçıya ait şarkı bulunamadı.", style: TextStyle(color: Colors.grey)),
                  );
                }
                final List<AppSong> songs = snapshot.data!;
                return Column(
                  children: songs.take(5).map((AppSong song) {
                    int songIndexInFullList = songs.indexOf(song);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      leading: Hero(
                        tag: 'artistSongArt_${widget.artist.id}_${song.id ?? song.filePath}',
                        child: ClipRRect(
                           borderRadius: BorderRadius.circular(4.0),
                           child: song.imagePath != null && song.imagePath!.isNotEmpty
                              ? Image.asset(song.imagePath!, width: 50, height: 50, fit: BoxFit.cover,
                                  errorBuilder: (c,e,s) => _buildDefaultArt(colorScheme, Icons.music_note, 50, borderRadius: 4.0))
                              : _buildDefaultArt(colorScheme, Icons.music_note, 50, borderRadius: 4.0),
                        ),
                      ),
                      title: Text(song.title, style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface)),
                      subtitle: Text(song.album ?? "Bilinmeyen Albüm", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
                      trailing: Text(_formatDuration(song.duration), style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NowPlayingPage(
                          song: song,
                          songQueue: songs, // TÜM ŞARKI LİSTESİ
                          initialIndex: songIndexInFullList, // İNDEX
                        )));
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}