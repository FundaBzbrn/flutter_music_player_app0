import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_application_0/models/app_song_model.dart'; 
import 'package:flutter_application_0/models/album_model.dart';
import 'package:flutter_application_0/models/artist_model.dart';
import 'package:flutter_application_0/models/playlist_model.dart';

class DatabaseHelper {
  static const _databaseName = "MyMusicApp.db";
  static const _databaseVersion = 1;

  static const tableSongs = 'songs';
  static const tableAlbums = 'albums';
  static const tableArtists = 'artists';
  static const tablePlaylists = 'playlists';
  static const tablePlaylistSongs = 'playlist_songs';
  static const tableFavorites = 'favorites';

  static const columnId = '_id';
  static const columnTitle = 'title';
  static const columnArtist = 'artist';
  static const columnAlbum = 'album';
  static const columnImagePath = 'imagePath';
  static const columnFilePath = 'filePath';
  static const columnDuration = 'duration';
  static const columnName = 'name';
  static const columnReleaseYear = 'releaseYear';
  static const columnDescription = 'description';
  static const columnPlaylistId = 'playlistId';
  static const columnSongId = 'songId';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $tableArtists ( $columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT NOT NULL UNIQUE )''');
    await db.execute('''CREATE TABLE $tableAlbums ( $columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT NOT NULL, $columnArtist TEXT, $columnImagePath TEXT, $columnReleaseYear INTEGER )''');
    await db.execute('''CREATE TABLE $tableSongs ( $columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT NOT NULL, $columnArtist TEXT, $columnAlbum TEXT, $columnImagePath TEXT, $columnFilePath TEXT UNIQUE, $columnDuration INTEGER, album_id INTEGER, artist_id INTEGER, FOREIGN KEY (album_id) REFERENCES $tableAlbums ($columnId) ON DELETE SET NULL, FOREIGN KEY (artist_id) REFERENCES $tableArtists ($columnId) ON DELETE SET NULL )''');
    await db.execute('''CREATE TABLE $tablePlaylists ( $columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT NOT NULL UNIQUE, $columnDescription TEXT, $columnImagePath TEXT )''');
    await db.execute('''CREATE TABLE $tablePlaylistSongs ( $columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnPlaylistId INTEGER NOT NULL, $columnSongId INTEGER NOT NULL, FOREIGN KEY ($columnPlaylistId) REFERENCES $tablePlaylists ($columnId) ON DELETE CASCADE, FOREIGN KEY ($columnSongId) REFERENCES $tableSongs ($columnId) ON DELETE CASCADE, UNIQUE ($columnPlaylistId, $columnSongId) )''');
    await db.execute('''CREATE TABLE $tableFavorites ( $columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnSongId INTEGER NOT NULL UNIQUE, FOREIGN KEY ($columnSongId) REFERENCES $tableSongs ($columnId) ON DELETE CASCADE )''');
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    int artist1Id = await db.insert(tableArtists, {columnName: 'Pop Sanatçısı'});
    int artist2Id = await db.insert(tableArtists, {columnName: 'Elektronik DJ'});
    int artist3Id = await db.insert(tableArtists, {columnName: 'Folk Müzisyen'});
    int artist4Id = await db.insert(tableArtists, {columnName: 'Rock Grubu'});

    int album1Id = await db.insert(tableAlbums, { columnTitle: 'Yaz Rüyası Hits', columnArtist: 'Pop Sanatçısı', columnImagePath: 'assets/images/album_art_1.webp', columnReleaseYear: 2023 });
    int album2Id = await db.insert(tableAlbums, { columnTitle: 'Gece Yolculuğu EP', columnArtist: 'Elektronik DJ', columnImagePath: 'assets/images/album_art_2.webp', columnReleaseYear: 2022 });
    int album3Id = await db.insert(tableAlbums, { columnTitle: 'Akustik Akşamlar Live', columnArtist: 'Folk Müzisyen', columnImagePath: 'assets/images/album_art_3.webp', columnReleaseYear: 2023 });

    await db.insert(tableSongs, { columnTitle: 'Hatıran Yeter', columnArtist: 'Pop Sanatçısı', columnAlbum: 'Yaz Rüyası Hits', columnImagePath: 'assets/images/album_art_1.webp', columnFilePath: 'Ferdi_Tayfur_Hatiran_Yeter.mp3', columnDuration: 185, 'album_id': album1Id, 'artist_id': artist1Id });
    await db.insert(tableSongs, { columnTitle: 'G-Eazy_Halsey_Him_I', columnArtist: 'Elektronik DJ', columnAlbum: 'Gece Yolculuğu EP', columnImagePath: 'assets/images/album_art_2.webp', columnFilePath: 'G-Eazy_Halsey_Him_I.mp3', columnDuration: 220, 'album_id': album2Id, 'artist_id': artist2Id });
    await db.insert(tableSongs, { columnTitle: '366. Gün', columnArtist: 'Folk Müzisyen', columnAlbum: 'Akustik Akşamlar Live', columnImagePath: 'assets/images/album_art_3.webp', columnFilePath: 'Sagopa_Kajmer_366.Gun.mp3', columnDuration: 200, 'album_id': album3Id, 'artist_id': artist3Id });
    await db.insert(tableSongs, { columnTitle: 'Ay Şarkısı', columnArtist: 'Beat Maker', columnAlbum: 'Singlelar', columnImagePath: 'assets/images/album_art_4.jpg', columnFilePath: 'Saian_Ay_Sarkisi.mp3', columnDuration: 150 });
    await db.insert(tableSongs, { columnTitle: 'Öpücem', columnArtist: 'Rock Grubu', columnAlbum: 'Rock Hits', columnImagePath: 'assets/images/album_art_5.jpg', columnFilePath: 'Simge_Opucem.mp3', columnDuration: 240, 'artist_id': artist4Id });
  }

  Future<int> insertSong(Map<String, dynamic> row) async { Database db = await instance.database; return await db.insert(tableSongs, row); }
  Future<List<Map<String, dynamic>>> getAllSongs() async { Database db = await instance.database; return await db.query(tableSongs); }
  Future<Map<String, dynamic>?> getSong(int id) async { Database db = await instance.database; List<Map<String, dynamic>> maps = await db.query(tableSongs, where: '$columnId = ?', whereArgs: [id]); if (maps.isNotEmpty) return maps.first; return null; }
  Future<int> updateSong(Map<String, dynamic> row) async { Database db = await instance.database; int id = row[columnId]; return await db.update(tableSongs, row, where: '$columnId = ?', whereArgs: [id]); }
  Future<int> deleteSong(int id) async { Database db = await instance.database; return await db.delete(tableSongs, where: '$columnId = ?', whereArgs: [id]); }
  Future<List<AppSong>> getRandomSongs(int limit) async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.query(tableSongs, orderBy: 'RANDOM()', limit: limit); return maps.map((map) => AppSong.fromMap(map)).toList(); }
  Future<int> addFavorite(int songId) async { Database db = await instance.database; try { return await db.insert(tableFavorites, {columnSongId: songId}); } catch (e) { print("Favori eklenirken hata: $e"); return 0; } }
  Future<int> removeFavorite(int songId) async { Database db = await instance.database; return await db.delete(tableFavorites, where: '$columnSongId = ?', whereArgs: [songId]); }
  Future<bool> isFavorite(int songId) async { Database db = await instance.database; List<Map<String, dynamic>> maps = await db.query(tableFavorites, columns: [columnSongId], where: '$columnSongId = ?', whereArgs: [songId]); return maps.isNotEmpty; }
  Future<List<AppSong>> getFavoriteSongs() async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT S.* FROM $tableSongs S INNER JOIN $tableFavorites F ON S.$columnId = F.$columnSongId ORDER BY S.$columnTitle ASC'); if (maps.isNotEmpty) return maps.map((map) => AppSong.fromMap(map)..isFavorite = true).toList(); return []; }
  Future<List<AppSong>> searchSongs(String query) async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.query(tableSongs, where: "$columnTitle LIKE ? OR $columnArtist LIKE ? OR $columnAlbum LIKE ?", whereArgs: ['%$query%', '%$query%', '%$query%'], orderBy: '$columnTitle ASC'); return maps.map((map) => AppSong.fromMap(map)).toList(); }
  Future<List<Artist>> searchArtists(String query) async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.query(tableArtists, where: "$columnName LIKE ?", whereArgs: ['%$query%'], orderBy: '$columnName ASC'); return maps.map((map) => Artist.fromMap(map)).toList(); }
  Future<List<Album>> searchAlbums(String query) async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.query(tableAlbums, where: "$columnTitle LIKE ? OR $columnArtist LIKE ?", whereArgs: ['%$query%', '%$query%'], orderBy: '$columnTitle ASC'); return maps.map((map) => Album.fromMap(map)).toList(); }
  Future<List<Album>> getAllAlbums() async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.query(tableAlbums, orderBy: '$columnTitle ASC'); return maps.map((map) => Album.fromMap(map)).toList(); }
  Future<List<Artist>> getAllArtists() async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.query(tableArtists, orderBy: '$columnName ASC'); return maps.map((map) => Artist.fromMap(map)).toList(); }
  Future<Album?> getAlbumById(int albumId) async { Database db = await instance.database; List<Map<String, dynamic>> maps = await db.query(tableAlbums, where: '$columnId = ?', whereArgs: [albumId], limit: 1); if (maps.isNotEmpty) return Album.fromMap(maps.first); return null; }
  Future<Artist?> getArtistById(int artistId) async { Database db = await instance.database; List<Map<String, dynamic>> maps = await db.query(tableArtists, where: '$columnId = ?', whereArgs: [artistId], limit: 1); if (maps.isNotEmpty) return Artist.fromMap(maps.first); return null; }
  Future<List<AppSong>> getSongsByAlbum(int albumId) async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.query(tableSongs, where: "album_id = ?", whereArgs: [albumId], orderBy: '$columnTitle ASC'); return maps.map((map) => AppSong.fromMap(map)).toList(); }
  Future<List<AppSong>> getSongsByArtist(int artistId) async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.query(tableSongs, where: "artist_id = ?", whereArgs: [artistId], orderBy: '$columnAlbum ASC, $columnTitle ASC'); return maps.map((map) => AppSong.fromMap(map)).toList(); }
  Future<List<Album>> getAlbumsByArtist(int artistId) async { Database db = await instance.database; final List<Map<String, dynamic>> artistMaps = await db.query(tableArtists, columns: [columnName], where: '$columnId = ?', whereArgs: [artistId]); if (artistMaps.isEmpty) return []; String artistName = artistMaps.first[columnName] as String; final List<Map<String, dynamic>> albumMaps = await db.query(tableAlbums, where: '$columnArtist = ?', whereArgs: [artistName], orderBy: '$columnReleaseYear DESC, $columnTitle ASC'); return albumMaps.map((map) => Album.fromMap(map)).toList(); }
  Future<int> insertAlbum(Map<String, dynamic> row) async { Database db = await instance.database; return await db.insert(tableAlbums, row); }
  Future<int> insertArtist(Map<String, dynamic> row) async { Database db = await instance.database; return await db.insert(tableArtists, row); }
  Future<int> createPlaylist(Playlist playlist) async { Database db = await instance.database; return await db.insert(tablePlaylists, playlist.toMap()); }
  Future<List<Playlist>> getAllPlaylists() async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.query(tablePlaylists, orderBy: '$columnTitle ASC'); if (maps.isEmpty) return []; return maps.map((map) => Playlist.fromMap(map)).toList(); }
  Future<int> addSongToPlaylist(int playlistId, int songId) async { Database db = await instance.database; try { return await db.insert(tablePlaylistSongs, {columnPlaylistId: playlistId, columnSongId: songId}); } catch (e) { print("Şarkı çalma listesine eklenirken hata: $e"); return 0; } }
  Future<int> removeSongFromPlaylist(int playlistId, int songId) async { Database db = await instance.database; return await db.delete(tablePlaylistSongs, where: '$columnPlaylistId = ? AND $columnSongId = ?', whereArgs: [playlistId, songId]); }
  Future<List<AppSong>> getSongsByPlaylistId(int playlistId) async { Database db = await instance.database; final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT S.* FROM $tableSongs S INNER JOIN $tablePlaylistSongs PS ON S.$columnId = PS.$columnSongId WHERE PS.$columnPlaylistId = ? ORDER BY S.$columnTitle ASC', [playlistId]); return maps.map((map) => AppSong.fromMap(map)).toList(); }
  Future<int> deletePlaylist(int playlistId) async { Database db = await instance.database; return await db.delete(tablePlaylists, where: '$columnId = ?', whereArgs: [playlistId]); }
  Future<int> updatePlaylist(Playlist playlist) async { Database db = await instance.database; return await db.update(tablePlaylists, playlist.toMap(), where: '$columnId = ?', whereArgs: [playlist.id]); }
  Future<void> batchInsertSongs(List<AppSong> songs) async { Database db = await instance.database; Batch batch = db.batch(); for (var song in songs) { int? artistId = song.artistId; if (song.artist != null && song.artist!.isNotEmpty) { List<Map<String, dynamic>> existingArtist = await db.query(tableArtists, columns: [columnId], where: '$columnName = ?', whereArgs: [song.artist], limit: 1); if (existingArtist.isNotEmpty) {
    artistId = existingArtist.first[columnId] as int?;
  } else {
    artistId = await db.insert(tableArtists, {columnName: song.artist});
  } } int? albumId = song.albumId; if (song.album != null && song.album!.isNotEmpty) { List<Map<String, dynamic>> existingAlbum = await db.query(tableAlbums, columns: [columnId], where: '$columnTitle = ? AND $columnArtist = ?', whereArgs: [song.album, song.artist ?? 'Bilinmeyen Sanatçı'], limit: 1); if (existingAlbum.isNotEmpty) {
    albumId = existingAlbum.first[columnId] as int?;
  } else {
    albumId = await db.insert(tableAlbums, {columnTitle: song.album, columnArtist: song.artist, columnImagePath: song.imagePath});
  } } Map<String, dynamic> songMap = song.toMap(); songMap['artist_id'] = artistId; songMap['album_id'] = albumId; List<Map<String, dynamic>> existingSong = await db.query(tableSongs, columns: [columnId], where: '$columnFilePath = ?', whereArgs: [song.filePath], limit: 1); if (existingSong.isEmpty) { batch.insert(tableSongs, songMap); } else { print("Şarkı zaten DB'de: ${song.title}"); } } await batch.commit(noResult: true); print("${songs.length} şarkı için toplu ekleme işlemi denendi."); }

  addSongToFavorites(int i) {}

  removeSongFromFavorites(int i) {}

  isSongFavorite(int i) {}
}