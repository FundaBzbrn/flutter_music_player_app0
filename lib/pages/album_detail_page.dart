import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/album_model.dart';
import 'package:flutter_application_0/models/app_song_model.dart';
import 'package:flutter_application_0/database_helper.dart';
import 'package:flutter_application_0/pages/now_playing_page.dart';

class AlbumDetailPage extends StatefulWidget {
  final Album album;

  const AlbumDetailPage({super.key, required this.album});

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  final dbHelper = DatabaseHelper.instance;
  late Future<List<AppSong>> _albumSongsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.album.id != null) {
      _albumSongsFuture = dbHelper.getSongsByAlbum(widget.album.id!);
    } else {
      _albumSongsFuture = Future.value([]);
      print("Albüm ID'si AlbumDetailPage'de bulunamadı.");
    }
  }

  String _formatDuration(int? totalSeconds) {
    if (totalSeconds == null || totalSeconds <= 0) return "0:00";
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes.toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget _buildDefaultAlbumArt(ColorScheme colorScheme, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.zero,
      ),
      child: Icon(Icons.album, size: size * 0.5, color: colorScheme.onSecondary.withOpacity(0.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            floating: false,
            backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
            foregroundColor: appBarTheme.foregroundColor ?? colorScheme.onSurface,
            iconTheme: appBarTheme.iconTheme ?? IconThemeData(color: colorScheme.onSurface),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.album.title,
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(blurRadius: 3.0, color: Colors.black87, offset: Offset(0, 1)),
                    const Shadow(blurRadius: 8.0, color: Colors.black54, offset: Offset(0, 1)),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(left: 50, right: 50, bottom: 16),
              background: Hero(
                tag: 'albumArt_${widget.album.id}_libraryList',
                child: widget.album.imagePath != null && widget.album.imagePath!.isNotEmpty
                    ? Image.asset(
                        widget.album.imagePath!,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.45),
                        colorBlendMode: BlendMode.darken,
                        errorBuilder: (c, e, s) => _buildDefaultAlbumArt(colorScheme, 280),
                      )
                    : _buildDefaultAlbumArt(colorScheme, 280),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.album.title,
                    style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Albüm • ${widget.album.artist ?? "Bilinmeyen Sanatçı"}"
                    "${widget.album.releaseYear != null ? " • ${widget.album.releaseYear}" : ""}",
                    style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          FutureBuilder<List<AppSong>>(
            future: _albumSongsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                    child: Center(
                        child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: CircularProgressIndicator(),
                )));
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                    child: Center(
                        child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Şarkılar yüklenemedi: ${snapshot.error}',
                    style: TextStyle(color: colorScheme.error),
                  ),
                )));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                    child: Center(
                        child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text('Bu albümde şarkı bulunamadı.',
                      style: TextStyle(color: Colors.grey)),
                )));
              }

              final List<AppSong> songsInAlbum = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final AppSong song = songsInAlbum[index];
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      leading: Text(
                        "${index + 1}.",
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                      ),
                      title: Text(song.title,
                          style: textTheme.titleMedium
                              ?.copyWith(color: colorScheme.onSurface)),
                      trailing: Text(
                        _formatDuration(song.duration),
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NowPlayingPage(
                              song: song,
                              songQueue: songsInAlbum,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: songsInAlbum.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
