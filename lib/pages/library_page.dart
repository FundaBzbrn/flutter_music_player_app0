import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/album_model.dart';
import 'package:flutter_application_0/models/artist_model.dart';
import 'package:flutter_application_0/models/playlist_model.dart';
import 'package:flutter_application_0/database_helper.dart'; 
import 'package:flutter_application_0/models/app_song_model.dart'; 
import 'package:flutter_application_0/pages/album_detail_page.dart';
import 'package:flutter_application_0/pages/artist_detail_page.dart';
import 'package:flutter_application_0/pages/favorites_page.dart';
import 'package:flutter_application_0/pages/playlist_detail_page.dart';
import 'package:permission_handler/permission_handler.dart'; // İzin paketi
import 'package:on_audio_query/on_audio_query.dart'; 

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final dbHelper = DatabaseHelper.instance;
  final OnAudioQuery _audioQuery = OnAudioQuery();

  late Future<List<Playlist>> _playlistsFuture;
  late Future<List<Album>> _albumsFuture;
  late Future<List<Artist>> _artistsFuture;
  late Future<List<AppSong>> _favoriteSongsFuture; 

  final TextEditingController _playlistNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLibraryData();
    // Sayfa ilk açıldığında izinleri kontrol et/iste (isteğe bağlı, butona da bağlanabilir)
    // _checkAndRequestPermissions();
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    super.dispose();
  }

  void _loadLibraryData() {
    setState(() {
      _playlistsFuture = dbHelper.getAllPlaylists();
      _albumsFuture = dbHelper.getAllAlbums();
      _artistsFuture = dbHelper.getAllArtists();
      _favoriteSongsFuture = dbHelper.getFavoriteSongs();
    });
  }

  Future<void> _showCreatePlaylistDialog() async {
    _playlistNameController.clear();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainerHighest, // Temaya uygun dialog arkaplanı
          title: Text('Yeni Çalma Listesi Oluştur', style: TextStyle(color: colorScheme.onSurfaceVariant)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _playlistNameController,
                  autofocus: true,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                  decoration: InputDecoration(
                    hintText: 'Çalma Listesi Adı',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: colorScheme.primary)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorScheme.primary, width: 2)),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal', style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.8))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: colorScheme.primary),
              child: Text('Oluştur', style: TextStyle(color: colorScheme.onPrimary)),
              onPressed: () async {
                if (_playlistNameController.text.trim().isNotEmpty) {
                  final newPlaylist = Playlist(title: _playlistNameController.text.trim());
                  await dbHelper.createPlaylist(newPlaylist);
                  Navigator.of(context).pop();
                  _loadLibraryData();
                  if(mounted){
                     ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('"${newPlaylist.title}" oluşturuldu!'), duration: const Duration(seconds: 2))
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGenericCategoryListPage<T>({
    required BuildContext context,
    required String pageTitle,
    required Future<List<T>> futureItems,
    required Widget Function(T item) itemBuilder,
    String emptyListMessage = "Henüz öğe yok.",
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle, style: appBarTheme.titleTextStyle?.copyWith(color: colorScheme.onSurface) ?? TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
        backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: appBarTheme.elevation ?? 0,
        iconTheme: appBarTheme.iconTheme ?? IconThemeData(color: colorScheme.onSurface),
      ),
      backgroundColor: colorScheme.surface,
      body: FutureBuilder<List<T>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Veriler yüklenirken hata oluştu: ${snapshot.error}", style: TextStyle(color: colorScheme.error)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(emptyListMessage, style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 16), textAlign: TextAlign.center,));
          }
          final items = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(items[index]),
          );
        },
      ),
    );
  }

  Widget _buildLibraryCategory<T>({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Future<List<T>> futureItems,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final listTileTheme = Theme.of(context).listTileTheme;
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<List<T>>(
      future: futureItems,
      builder: (context, snapshot) {
        int itemCount = 0;
        Widget trailingContent;
        if (snapshot.connectionState == ConnectionState.waiting) {
          trailingContent = SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: colorScheme.primary.withOpacity(0.8)));
        } else if (snapshot.hasError) {
          print("Error loading $title for Library Category: ${snapshot.error}");
          trailingContent = Icon(Icons.error_outline, color: colorScheme.error, size: 20);
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          itemCount = snapshot.data!.length;
          trailingContent = Text(itemCount.toString(), style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)));
        } else {
          trailingContent = Text("0", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)));
        }
        return ListTile(
          leading: Icon(icon, color: listTileTheme.iconColor ?? colorScheme.primary, size: 28),
          title: Text(title, style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w500) ?? TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500, fontSize: 17)),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [trailingContent, const SizedBox(width: 8), Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colorScheme.onSurface.withOpacity(0.7))]),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        );
      },
    );
  }

  Future<bool> _checkAndRequestPermissions() async {
    var audioPermission = await Permission.audio.status;
    print("Mevcut Ses İzin Durumu: $audioPermission");
    if (audioPermission.isDenied) {
      PermissionStatus status = await Permission.audio.request();
      print("İzin İsteği Sonucu (Ses): $status");
      return status.isGranted;
    } else if (audioPermission.isPermanentlyDenied) {
      print("Ses izni kalıcı olarak reddedildi. Lütfen uygulama ayarlarından izin verin.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Müziklere erişmek için lütfen uygulama ayarlarından medya iznini verin."), duration: Duration(seconds: 3)),
        );
      }
      await openAppSettings();
      return false;
    }
    return audioPermission.isGranted;
  }

   Future<void> _scanDeviceForSongs() async {
    bool permissionsGranted = await _checkAndRequestPermissions();
    if (!permissionsGranted) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Müziklere erişim izni verilmedi.")));
      return;
    }
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cihazdaki şarkılar taranıyor..."), duration: Duration(seconds: 2)));

    try {
      List<SongModel> songsFromDevice = await _audioQuery.querySongs( // on_audio_query'den gelen SongModel
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      if (songsFromDevice.isNotEmpty) {
        List<AppSong> songsToInsert = []; 
        for (var deviceSongInfo in songsFromDevice) {
          if (deviceSongInfo.duration == null || deviceSongInfo.duration! < 1000 || deviceSongInfo.data.isEmpty) continue;

          songsToInsert.add(AppSong( 
            title: deviceSongInfo.title.isNotEmpty ? deviceSongInfo.title : (deviceSongInfo.displayNameWOExt.isNotEmpty ? deviceSongInfo.displayNameWOExt : "Bilinmeyen Şarkı"),
            artist: deviceSongInfo.artist?.isNotEmpty ?? false ? deviceSongInfo.artist : "Bilinmeyen Sanatçı",
            album: deviceSongInfo.album?.isNotEmpty ?? false ? deviceSongInfo.album : "Bilinmeyen Albüm",
            filePath: deviceSongInfo.data,
            duration: (deviceSongInfo.duration! / 1000).round(),
            imagePath: null, 
          ));
        }

        if (songsToInsert.isNotEmpty) {
          await dbHelper.batchInsertSongs(songsToInsert);
          _loadLibraryData(); 
          if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${songsToInsert.length} şarkı bulundu ve kütüphaneye eklendi!"), duration: Duration(seconds: 3)));
        } else {
           if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kütüphaneye eklenecek yeni uygun şarkı bulunamadı.")));
        }
      } else {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cihazınızda hiç müzik dosyası bulunamadı.")));
      }
    } catch (e) {
      print("Şarkılar taranırken veya DB'ye eklenirken hata oluştu: $e");
       if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Şarkılar işlenirken bir hata oluştu.")));
    }
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('K Ü T Ü P H A N E M', style: appBarTheme.titleTextStyle?.copyWith(color: colorScheme.onSurface) ?? TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: appBarTheme.elevation ?? 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded, color: colorScheme.primary, size: 28),
            tooltip: "Yeni Çalma Listesi",
            onPressed: _showCreatePlaylistDialog,
          ),
          IconButton( // Şarkıları Tara Butonu
            icon: Icon(Icons.refresh_rounded, color: colorScheme.primary, size: 28),
            tooltip: "Cihazdaki Şarkıları Tara",
            onPressed: _scanDeviceForSongs,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async { _loadLibraryData(); },
        color: colorScheme.primary,
        backgroundColor: colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.only(top:10.0, bottom: 20.0),
          children: [
            _buildLibraryCategory<Playlist>(
              context: context,
              icon: Icons.playlist_play_rounded,
              title: "Çalma Listeleri",
              futureItems: _playlistsFuture,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  _buildGenericCategoryListPage<Playlist>(
                    context: context,
                    pageTitle: "Çalma Listeleri",
                    futureItems: _playlistsFuture,
                    itemBuilder: (playlist) {
                      return ListTile(
                        leading: playlist.imagePath != null && playlist.imagePath!.isNotEmpty
                            ? ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.asset(playlist.imagePath!, width: 40, height: 40, fit: BoxFit.cover))
                            : CircleAvatar(backgroundColor: colorScheme.secondary, child: Icon(Icons.playlist_play, color: colorScheme.primary)),
                        title: Text(playlist.title, style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistDetailPage(playlist: playlist)));
                        },
                      );
                    },
                    emptyListMessage: "Henüz çalma listen yok.\nYeni bir tane oluşturmak için yukarıdaki '+' butonuna tıkla."
                  )
                ));
              },
            ),
            Divider(color: colorScheme.surfaceContainerHighest, indent: 20, endIndent: 20, height: 1),
            _buildLibraryCategory<Album>(
              context: context,
              icon: Icons.album_rounded,
              title: "Albümler",
              futureItems: _albumsFuture,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  _buildGenericCategoryListPage<Album>(
                    context: context,
                    pageTitle: "Albümler",
                    futureItems: _albumsFuture,
                    itemBuilder: (album) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        leading: Hero(
                           tag: 'albumArt_${album.id}_libraryList',
                           child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: album.imagePath != null && album.imagePath!.isNotEmpty
                                ? Image.asset(album.imagePath!, width: 50, height: 50, fit: BoxFit.cover,
                                    errorBuilder: (c,e,s) => Container(width:50, height:50, color: colorScheme.secondary, child: Icon(Icons.album, size: 30, color: colorScheme.onSecondary.withOpacity(0.5))))
                                : Container(width: 50, height: 50, color: colorScheme.secondary, child: Icon(Icons.album, size: 30, color: colorScheme.onSecondary.withOpacity(0.5))),
                          ),
                        ),
                        title: Text(album.title, style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
                        subtitle: Text(album.artist ?? "Bilinmeyen Sanatçı", style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumDetailPage(album: album)));
                        },
                      );
                    }
                  )
                ));
              },
            ),
            Divider(color: colorScheme.surfaceContainerHighest, indent: 20, endIndent: 20, height: 1),
            _buildLibraryCategory<Artist>(
              context: context,
              icon: Icons.person_rounded,
              title: "Sanatçılar",
              futureItems: _artistsFuture,
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  _buildGenericCategoryListPage<Artist>(
                    context: context,
                    pageTitle: "Sanatçılar",
                    futureItems: _artistsFuture,
                    itemBuilder: (artist) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        leading: CircleAvatar(backgroundColor: colorScheme.secondary, child: Icon(Icons.person, color: colorScheme.primary)),
                        title: Text(artist.name, style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistDetailPage(artist: artist)));
                        },
                      );
                    }
                  )
                ));
              },
            ),
            Divider(color: colorScheme.surfaceContainerHighest, indent: 20, endIndent: 20, height: 1),
            _buildLibraryCategory<AppSong>(
              context: context,
              icon: Icons.favorite_rounded,
              title: "Beğenilen Şarkılar",
              futureItems: _favoriteSongsFuture,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
              },
            ),
            Divider(color: colorScheme.surfaceContainerHighest, indent: 20, endIndent: 20, height: 1),
            ListTile(
               leading: Icon(Icons.download_for_offline_rounded, color: Theme.of(context).listTileTheme.iconColor ?? colorScheme.primary, size: 28),
               title: Text("İndirilenler", style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500, fontSize: 17)),
               trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("0", style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 14)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colorScheme.onSurface.withOpacity(0.7)),
                  ],
                ),
               onTap: () {
                  print("İndirilenler tıklandı");
               },
               contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}