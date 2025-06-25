import 'package:flutter/material.dart';
import 'package:flutter_application_0/components/my_drawer.dart';
import 'package:flutter_application_0/database_helper.dart';
import 'package:flutter_application_0/models/app_song_model.dart';
import 'package:flutter_application_0/pages/now_playing_page.dart';
import 'package:flutter_application_0/pages/search_page.dart';
import 'package:provider/provider.dart'; // Provider importu
import 'package:flutter_application_0/providers/music_player_provider.dart'; // MusicPlayerProvider importu

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  late Future<List<AppSong>> _newReleasesFuture;
  late Future<List<AppSong>> _recommendedSongsFuture;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  void _loadSongs() {
    _newReleasesFuture = dbHelper.getRandomSongs(5);
    _recommendedSongsFuture = dbHelper.getRandomSongs(5);
  }

  Widget _buildHorizontalListSection({
    required String title,
    required Future<List<AppSong>> futureSongs,
    required String sectionKey,
    VoidCallback? onSeeAll,
    required BuildContext context,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold) ?? TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            if (onSeeAll != null) TextButton(onPressed: onSeeAll, child: Text("Tümünü Gör", style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600))),
          ]),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<AppSong>>(
            future: futureSongs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Center(child: Text('Şarkılar yüklenemedi: ${snapshot.error}', style: TextStyle(color: colorScheme.error)));
              if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text('Bu bölümde şarkı bulunamadı.', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))));
              final List<AppSong> items = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                padding: const EdgeInsets.only(left: 20.0, right: 5.0, bottom: 10.0),
                itemBuilder: (context, index) {
                  final AppSong item = items[index];
                  final String heroTag = 'albumArt_song_${item.id ?? item.filePath}'; // Daha genel bir tag
                  return InkWell(
                    onTap: () {
                      // ÖNCE PROVIDER ÜZERİNDEN ŞARKIYI VE KUYRUĞU AYARLA
                      Provider.of<MusicPlayerProvider>(context, listen: false).playSong(item, items, index);
                      // SONRA NOWPLAYINGPAGE'İ AÇ (PARAMETRESİZ)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NowPlayingPage(
                          song: item,
                          songQueue: items,
                          initialIndex: index,
                        )),
                      );
                    },
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: 140, margin: const EdgeInsets.only(right: 15.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Hero(tag: heroTag, child: ClipRRect(borderRadius: BorderRadius.circular(12.0), child: item.imagePath != null && item.imagePath!.isNotEmpty ? Image.asset(item.imagePath!, width: 140, height: 140, fit: BoxFit.cover, errorBuilder: (c,e,s) => _buildErrorImage(colorScheme)) : _buildErrorImage(colorScheme))),
                        const SizedBox(height: 10),
                        Text(item.title, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface) ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: colorScheme.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(item.artist ?? 'Bilinmeyen Sanatçı', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)) ?? TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.7)), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorImage(ColorScheme colorScheme) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Icon(Icons.music_note_rounded, color: colorScheme.onSecondary.withOpacity(0.5), size: 40,),
    );
  }

  final List<String> moods = ["Romantik", "Antrenman", "Parti", "Odaklanma", "Hip Hop", "Retro", "Sakin", "Yolculuk"];
  Widget _buildMoodsSection({required BuildContext context}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final chipTheme = Theme.of(context).chipTheme; // Chip temasını alalım

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Modlar",
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ) ?? TextStyle( // textTheme null ise varsayılan stil
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: moods.map((mood) {
              return InkWell(
                onTap: () {
                  print("$mood tıklandı!");
                  // TODO: Mod'a tıklandığında ilgili şarkıları/listeleri gösteren bir sayfaya yönlendirme
                },
                borderRadius: BorderRadius.circular(20.0), // InkWell için de border radius
                child: Chip(
                  label: Text(mood),
                  backgroundColor: chipTheme.backgroundColor ?? colorScheme.secondary,
                  labelStyle: chipTheme.labelStyle ?? TextStyle(color: colorScheme.onSecondary, fontWeight: FontWeight.w500),
                  padding: chipTheme.padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  shape: chipTheme.shape ?? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme; // Input temasını alalım

    String greeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) return 'Günaydın';
      if (hour < 17) return 'Tünaydın';
      return 'İyi Akşamlar';
    }

     return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer: const MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0, floating: true, pinned: true, snap: false,
            elevation: appBarTheme.elevation ?? 0,
            backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
            foregroundColor: appBarTheme.foregroundColor ?? colorScheme.onSurface,
            iconTheme: appBarTheme.iconTheme ?? IconThemeData(color: colorScheme.onSurface),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 60.0, bottom: 16.0),
              title: Text(greeting(), style: appBarTheme.titleTextStyle?.copyWith(color: colorScheme.onSurface, fontSize: 22, fontWeight: FontWeight.bold) ?? TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            ),
            actions: [
              IconButton(icon: Icon(Icons.notifications_none_rounded, color: appBarTheme.actionsIconTheme?.color ?? colorScheme.onSurface), onPressed: () => print("Bildirimler tıklandı")),
              const SizedBox(width: 10),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: TextField(
                    readOnly: true,
                    onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())); },
                    decoration: InputDecoration(
                      hintText: "Şarkı, sanatçı veya albüm ara...",
                      hintStyle: inputDecorationTheme.hintStyle ?? TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                      prefixIcon: Icon(Icons.search_rounded, color: inputDecorationTheme.prefixIconColor ?? colorScheme.onSurface.withOpacity(0.7)),
                      filled: inputDecorationTheme.filled ?? true,
                      fillColor: inputDecorationTheme.fillColor ?? colorScheme.secondary,
                      border: inputDecorationTheme.border ?? const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                      enabledBorder: inputDecorationTheme.enabledBorder ?? const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                      focusedBorder: inputDecorationTheme.focusedBorder ?? OutlineInputBorder(borderSide: BorderSide(color: colorScheme.primary, width: 1.5), borderRadius: BorderRadius.all(Radius.circular(30.0))),
                      contentPadding: inputDecorationTheme.contentPadding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    ),
                  ),
                ),
                _buildHorizontalListSection(title: "Yeni Çıkanlar", futureSongs: _newReleasesFuture, sectionKey: "newReleases", onSeeAll: () => print("Yeni Çıkanlar Tümünü Gör tıklandı"), context: context),
                _buildHorizontalListSection(title: "Sana Özel Öneriler", futureSongs: _recommendedSongsFuture, sectionKey: "recommendations", onSeeAll: () => print("Önerilenler Tümünü Gör tıklandı"), context: context),
                _buildMoodsSection(context: context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}