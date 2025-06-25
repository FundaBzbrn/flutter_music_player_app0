import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/app_song_model.dart';

class NowPlayingPage extends StatefulWidget {
  final AppSong song;
  final List<AppSong> songQueue;
  final int initialIndex;

  const NowPlayingPage({
    super.key,
    required this.song,
    required this.songQueue,
    required this.initialIndex,
  });

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  late int currentIndex;
  late AppSong currentSong;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    currentSong = widget.songQueue[currentIndex];
  }

  void _playPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _nextSong() {
    if (currentIndex < widget.songQueue.length - 1) {
      setState(() {
        currentIndex++;
        currentSong = widget.songQueue[currentIndex];
        isPlaying = true;
      });
    }
  }

  void _previousSong() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        currentSong = widget.songQueue[currentIndex];
        isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Şimdi Çalıyor"),
        backgroundColor: colorScheme.primary,
      ),
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Albüm kapak resmi
            Hero(
              tag: 'albumArt_${currentSong.albumId}_libraryList',
              child: currentSong.imagePath != null && currentSong.imagePath!.isNotEmpty
                  ? Image.asset(
                      currentSong.imagePath!,
                      height: 280,
                      width: 280,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 280,
                      width: 280,
                      color: colorScheme.primaryContainer,
                      child: Icon(Icons.music_note, size: 100, color: colorScheme.onPrimary),
                    ),
            ),
            const SizedBox(height: 32),
            // Şarkı bilgisi
            Text(currentSong.title,
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(currentSong.artist ?? "Bilinmeyen Sanatçı",
                style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
            const SizedBox(height: 32),
            // Kontroller
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 40,
                  onPressed: currentIndex > 0 ? _previousSong : null,
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
                  iconSize: 60,
                  onPressed: _playPause,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 40,
                  onPressed: currentIndex < widget.songQueue.length - 1 ? _nextSong : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "${currentIndex + 1} / ${widget.songQueue.length}",
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }
}