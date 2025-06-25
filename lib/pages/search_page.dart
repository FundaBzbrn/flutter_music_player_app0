import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/album_model.dart';
import 'package:flutter_application_0/models/artist_model.dart';
import 'package:flutter_application_0/models/app_song_model.dart'; 
import 'package:flutter_application_0/pages/now_playing_page.dart';
import 'package:flutter_application_0/pages/album_detail_page.dart';
import 'package:flutter_application_0/pages/artist_detail_page.dart';
import 'package:flutter_application_0/database_helper.dart'; 

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  List<AppSong> _songResults = [];
  List<Artist> _artistResults = [];
  List<Album> _albumResults = [];

  bool _isLoading = false;
  bool _hasSearched = false;
  String _currentQuery = "";

  Future<void> _performSearch(String query) async {
    _currentQuery = query.trim();
    if (_currentQuery.isEmpty) {
      if (mounted) {
        setState(() {
          _songResults = []; _artistResults = []; _albumResults = [];
          _hasSearched = false; _isLoading = false;
        });
      }
      return;
    }
    if (mounted) setState(() { _isLoading = true; _hasSearched = true; });

    try {
      final songs = await dbHelper.searchSongs(_currentQuery);
      final artists = await dbHelper.searchArtists(_currentQuery);
      final albums = await dbHelper.searchAlbums(_currentQuery);
      if (mounted) {
        setState(() {
          _songResults = songs; _artistResults = artists; _albumResults = albums;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Arama sırasında hata: $e");
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 8.0),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
    );
  }

  Widget _buildSongResultTile(AppSong  song, ColorScheme colorScheme) {
    final List<AppSong> currentSongQueue = [song];
    return ListTile(
      leading: Hero(
        tag: 'albumArt_${song.id ?? song.filePath}_search',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: song.imagePath != null && song.imagePath!.isNotEmpty
              ? Image.asset(song.imagePath!, width: 40, height: 40, fit: BoxFit.cover,
                  errorBuilder: (c,e,s) => Icon(Icons.music_note, color: colorScheme.primary, size: 30))
              : Icon(Icons.music_note, color: colorScheme.primary, size: 30),
        ),
      ),
      title: Text(song.title, style: TextStyle(color: colorScheme.onSurface)),
      subtitle: Text(song.artist ?? "Bilinmeyen Sanatçı", style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NowPlayingPage(
            song: song,                     // Tıklanan şarkı
            songQueue: currentSongQueue,    // ŞİMDİLİK SADECE TIKLANAN ŞARKIYI İÇEREN LİSTE
            initialIndex: 0,                // Tek elemanlı listenin ilk (ve tek) elemanı
          )),
        );
      },
    );
  }

  Widget _buildArtistResultTile(Artist artist, ColorScheme colorScheme) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.secondary,
        child: Icon(Icons.person, color: colorScheme.primary),
      ),
      title: Text(artist.name, style: TextStyle(color: colorScheme.onSurface)),
      onTap: () {
        if (artist.id != null) {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArtistDetailPage(artist: artist)),
            );
        } else {
            print("Sanatçı ID'si bulunamadı (Arama Sonucu): ${artist.name}");
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${artist.name} için detaylar görüntülenemiyor."))
            );
        }
      },
    );
  }

 Widget _buildAlbumResultTile(Album album, ColorScheme colorScheme) {
    return ListTile(
      leading: Hero(
        tag: 'albumArt_${album.id}_searchList',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: album.imagePath != null && album.imagePath!.isNotEmpty
              ? Image.asset(album.imagePath!, width: 40, height: 40, fit: BoxFit.cover,
                  errorBuilder: (c,e,s) => Icon(Icons.album, color: colorScheme.primary, size: 30))
              : Icon(Icons.album, color: colorScheme.primary, size: 30),
        ),
      ),
      title: Text(album.title, style: TextStyle(color: colorScheme.onSurface)),
      subtitle: Text(album.artist ?? "Bilinmeyen Sanatçı", style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
      onTap: () {
        if (album.id != null) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlbumDetailPage(album: album)),
            );
        } else {
            print("Albüm ID'si bulunamadı (Arama Sonucu): ${album.title}");
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${album.title} için detaylar görüntülenemiyor."))
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // appBarTheme burada tanımlanabilir ama AppBar içinde direkt Theme.of(context).appBarTheme kullanacağız.

    Widget bodyContent;
    if (_isLoading) {
      bodyContent = Center(child: CircularProgressIndicator(color: colorScheme.primary));
    } else if (_hasSearched && _songResults.isEmpty && _artistResults.isEmpty && _albumResults.isEmpty) {
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "\"$_currentQuery\" için sonuç bulunamadı.",
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 16),
          ),
        ),
      );
    } else if (_hasSearched) {
      bodyContent = ListView(
        padding: const EdgeInsets.only(bottom: 16.0),
        children: [
          if (_songResults.isNotEmpty) ...[
            _buildSectionHeader("Şarkılar", colorScheme),
            ..._songResults.map((song) => _buildSongResultTile(song, colorScheme)),
             Divider(color: colorScheme.surfaceContainerHighest, indent: 16, endIndent: 16, height:1),
          ],
          if (_artistResults.isNotEmpty) ...[
            _buildSectionHeader("Sanatçılar", colorScheme),
            ..._artistResults.map((artist) => _buildArtistResultTile(artist, colorScheme)),
             Divider(color: colorScheme.surfaceContainerHighest, indent: 16, endIndent: 16, height:1),
          ],
          if (_albumResults.isNotEmpty) ...[
            _buildSectionHeader("Albümler", colorScheme),
            ..._albumResults.map((album) => _buildAlbumResultTile(album, colorScheme)),
          ],
        ],
      );
    } else {
      bodyContent = Center( // Keşfet içeriği yerine basit bir mesaj
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Ne dinlemek istediğini yukarıdaki alana yazarak arayabilirsin.",
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false, // MainNavigationPage'den geldiği için geri tuşu olmasın
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: Theme.of(context).appBarTheme.elevation ?? 0,
        leadingWidth: 50, // Profil ikonu için genişlik
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            radius: 18, // Boyut
            backgroundColor: colorScheme.secondary, // Temadan
            child: Icon(
                Icons.person_outline_rounded,
                color: colorScheme.onSecondary, // Temadan
                size: 22 // Boyut
            ),
          ),
        ),
        title: Text(
          "Ara",
          style: Theme.of(context).appBarTheme.titleTextStyle ?? TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 24, 
          ),
        ),
        centerTitle: false, // Sola yaslı başlık
        actions: [
          IconButton(
            icon: Icon(
                Icons.camera_alt_outlined,
                color: Theme.of(context).appBarTheme.actionsIconTheme?.color ?? colorScheme.onSurface
            ),
            onPressed: () {
              print("Kamera ikonu tıklandı");
              
            },
          ),
          const SizedBox(width: 6), // İkonlar arası boşluk
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0), // Padding ayarları
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Theme.of(context).inputDecorationTheme.labelStyle?.color ?? colorScheme.onSecondary),
              decoration: InputDecoration( // Stil özellikleri temanızdaki inputDecorationTheme'dan alınır
                hintText: "Ne dinlemek istiyorsun?",
                // hintStyle, prefixIcon, fillColor, border vs. tema tarafından sağlanır
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                            Icons.clear_rounded,
                            color: Theme.of(context).inputDecorationTheme.suffixIconColor ?? colorScheme.onSecondary.withOpacity(0.7)
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {}); // Suffix icon'un görünürlüğünü anında güncellemek için
                // İsteğe bağlı: Her harf girişinde arama yapmak için debounce ile _performSearch(value);
              },
              onSubmitted: _performSearch, // Enter'a basıldığında arama yap
            ),
          ),
          Expanded(child: bodyContent),
        ],
      ),
    );
  }
}