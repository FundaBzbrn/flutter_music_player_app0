class Playlist {
  final int? id;
  String title;
  String? description;
  String? imagePath; // Çalma listesi için özel bir kapak resmi olabilir
  // int songCount; // UI'da göstermek için şarkı sayısı, DB'den ayrıca sorgulanabilir

  Playlist({
    this.id,
    required this.title,
    this.description,
    this.imagePath,
    // this.songCount = 0,
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['_id'],
      title: map['title'],
      description: map['description'],
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'description': description,
      'imagePath': imagePath,
    };
    if (id != null) {
      map['_id'] = id;
    }
    return map;
  }
}