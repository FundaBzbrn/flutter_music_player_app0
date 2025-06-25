class Artist {
  final int? id;
  final String name;
  // İleride bu sanatçının albümlerinin/şarkılarının bir listesi eklenebilir
  // String? imagePath; // Sanatçı için bir resim yolu da eklenebilir

  Artist({
    this.id,
    required this.name,
  });

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      id: map['_id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
    };
    if (id != null) {
      map['_id'] = id;
    }
    return map;
  }
}