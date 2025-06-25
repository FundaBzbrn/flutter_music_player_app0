import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/playlist_model.dart';
import 'package:flutter_application_0/models/app_song_model.dart'; // AppSong kullanılıyor
import 'package:flutter_application_0/database_helper.dart';
import 'package:flutter_application_0/pages/now_playing_page.dart';

class PlaylistDetailPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailPage({super.key, required this.playlist});

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  final dbHelper = DatabaseHelper.instance;
  late Future<List<AppSong>> _playlistSongsFuture;

  @override
  void initState() {
    super.initState();
    _loadPlaylistSongs();
  }

  void _loadPlaylistSongs() {
    if (widget.playlist.id != null) {
      setState(() {
        _playlistSongsFuture = dbHelper.getSongsByPlaylistId(widget.playlist.id!);
      });
    } else {
      _playlistSongsFuture = Future.value([]);
      print("Çalma Listesi ID'si PlaylistDetailPage'de bulunamadı.");
    }
  }

  String _formatDuration(int? totalSeconds) {
    if (totalSeconds == null || totalSeconds <= 0) return "0:00";
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes.toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> _removeSongFromPlaylistDialog(AppSong song) async {
    if (widget.playlist.id == null || song.id == null) return;

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Şarkıyı Sil'),
          content: Text('"${song.title}" şarkısını "${widget.playlist.title}" listesinden kaldırmak istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Kaldır', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await dbHelper.removeSongFromPlaylist(widget.playlist.id!, song.id!);
      _loadPlaylistSongs(); // Listeyi yenile
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${song.title}" listeden kaldırıldı.'), duration: const Duration(seconds: 1)),
        );
      }
    }
  }

  Future<void> _showDeletePlaylistDialog() async {
    if (widget.playlist.id == null) return;

    bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Çalma Listesini Sil'),
            content: Text('"${widget.playlist.title}" çalma listesini silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'),
            actions: <Widget>[
              TextButton(child: const Text('İptal'), onPressed: () => Navigator.of(context).pop(false)),
              TextButton(
                child: Text('Sil', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        });

    if (confirmed == true) {
      await dbHelper.deletePlaylist(widget.playlist.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${widget.playlist.title}" çalma listesi silindi.'), duration: const Duration(seconds: 2)),
        );
        Navigator.of(context).pop(); // Bir önceki sayfaya (LibraryPage) dön
      }
    }
  }

  Widget _buildDefaultPlaylistArt(ColorScheme colorScheme, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(Icons.playlist_play, size: size * 0.6, color: colorScheme.onSecondary.withOpacity(0.6)),
    );
  }

  Widget _buildDefaultSongArt(ColorScheme colorScheme, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Icon(Icons.music_note, size: size * 0.5, color: colorScheme.onSecondary.withOpacity(0.6)),
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
          widget.playlist.title,
          style: appBarTheme.titleTextStyle?.copyWith(color: colorScheme.onSurface) ??
                 TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)
        ),
        backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: appBarTheme.elevation ?? 0,
        iconTheme: appBarTheme.iconTheme ?? IconThemeData(color: colorScheme.onSurface),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
            onSelected: (value) {
              if (value == 'delete_playlist') {
                _showDeletePlaylistDialog();
              }
              // TODO: 'rename_playlist' seçeneği eklenebilir
              // else if (value == 'rename_playlist') { print("Yeniden adlandır tıklandı"); }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete_playlist',
                child: Text('Çalma Listesini Sil'),
              ),
              // const PopupMenuItem<String>(
              //   value: 'rename_playlist',
              //   child: Text('Yeniden Adlandır'),
              // ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'playlistArt_${widget.playlist.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: widget.playlist.imagePath != null && widget.playlist.imagePath!.isNotEmpty
                        ? Image.asset(
                            widget.playlist.imagePath!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => _buildDefaultPlaylistArt(colorScheme, 100))
                        : _buildDefaultPlaylistArt(colorScheme, 100),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.playlist.title,
                        style: textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.playlist.description != null && widget.playlist.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            widget.playlist.description!,
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Expanded(
            child: FutureBuilder<List<AppSong>>(
              future: _playlistSongsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Şarkılar yüklenirken bir hata oluştu: ${snapshot.error}', style: TextStyle(color: colorScheme.error)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_off_outlined, size: 60, color: colorScheme.onSurface.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text('Bu çalma listesinde henüz şarkı yok.', style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
                          const SizedBox(height: 16),
                          // TODO: "Şarkı Ekle" butonu (örn: tüm şarkıları listeleyen bir sayfaya yönlendirme)
                          // ElevatedButton.icon(
                          //   icon: Icon(Icons.add_rounded),
                          //   label: Text("Şarkı Ekle"),
                          //   onPressed: (){ /* Şarkı ekleme sayfasına git */ }
                          // )
                        ],
                      ),
                    ),
                  );
                }

                final List<AppSong> songsInPlaylist = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: songsInPlaylist.length,
                  itemBuilder: (BuildContext context, int index) {
                    final AppSong song = songsInPlaylist[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      leading: Hero(
                        tag: 'playlistSongArt_${widget.playlist.id}_${song.id ?? song.filePath}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: song.imagePath != null && song.imagePath!.isNotEmpty
                              ? Image.asset(song.imagePath!, width: 50, height: 50, fit: BoxFit.cover,
                                  errorBuilder: (c,e,s) => _buildDefaultSongArt(colorScheme, 50))
                              : _buildDefaultSongArt(colorScheme, 50),
                        ),
                      ),
                      title: Text(song.title, style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
                      subtitle: Text(song.artist ?? "Bilinmeyen Sanatçı", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: colorScheme.onSurface.withOpacity(0.7)),
                        onSelected: (String value) {
                          if (value == 'remove_from_playlist') {
                            _removeSongFromPlaylistDialog(song);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'remove_from_playlist',
                            child: Text('Listeden Kaldır'),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NowPlayingPage(
                            song: song,
                            songQueue: songsInPlaylist, // Bu çalma listesindeki tüm şarkıları gönder
                            initialIndex: index,         // Tıklanan şarkının index'ini gönder
                          )),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
       ),
    );
  }
}