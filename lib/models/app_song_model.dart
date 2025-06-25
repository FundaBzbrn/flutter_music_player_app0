// lib/models/app_song_model.dart

class AppSong { // SINIF ADI DEĞİŞTİ
  final int? id;
  final String title;
  final String? artist;
  final String? album;
  final String? imagePath; // Asset yolu veya URL (ileride byte[] olabilir)
  final String? filePath;  // Cihazdaki gerçek dosya yolu
  final int? duration;    // Saniye cinsinden
  final int? albumId;
  final int? artistId;
  bool isFavorite;

  AppSong({ // CONSTRUCTOR ADI DEĞİŞTİ
    this.id,
    required this.title,
    this.artist,
    this.album,
    this.imagePath,
    this.filePath,
    this.duration,
    this.albumId,
    this.artistId,
    this.isFavorite = false,
  });

  factory AppSong.fromMap(Map<String, dynamic> map) { // FACTORY METOT ADI DEĞİŞTİ
    return AppSong(
      id: map['_id'] as int?, // Tip dönüşümlerini ekleyelim
      title: map['title'] as String? ?? 'Bilinmeyen Başlık',
      artist: map['artist'] as String?,
      album: map['album'] as String?,
      imagePath: map['imagePath'] as String?,
      filePath: map['filePath'] as String?,
      duration: map['duration'] as int?,
      albumId: map['album_id'] as int?,
      artistId: map['artist_id'] as int?,
      // isFavorite, bu factory metoduyla doğrudan atanmaz, genellikle ayrı bir sorguyla belirlenir.
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'artist': artist,
      'album': album,
      'imagePath': imagePath,
      'filePath': filePath,
      'duration': duration,
      'album_id': albumId,
      'artist_id': artistId,
    };
    if (id != null) {
      map['_id'] = id;
    }
    return map;
  }
}