class Album {
  final int? id;
  final String title;
  final String? artist; // Veya artistId
  final String? imagePath;
  final int? releaseYear;
  // İleride bu albümdeki şarkıların bir listesi de eklenebilir: List<Song> songs;

  Album({
    this.id,
    required this.title,
    this.artist,
    this.imagePath,
    this.releaseYear,
  });

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['_id'],
      title: map['title'],
      artist: map['artist'],
      imagePath: map['imagePath'],
      releaseYear: map['releaseYear'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'artist': artist,
      'imagePath': imagePath,
      'releaseYear': releaseYear,
    };
    if (id != null) {
      map['_id'] = id;
    }
    return map;
  }
}