import 'package:flutter/material.dart';
import 'package:flutter_application_0/components/my_drawer.dart'; // Proje adına göre yolu güncelle

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> newReleases = [
    {"image": "assets/images/album_art_1.webp", "title": "Yaz Rüyası", "artist": "Pop Sanatçısı"},
    {"image": "assets/images/album_art_2.webp", "title": "Gece Yolculuğu", "artist": "Elektronik DJ"},
    {"image": "assets/images/album_art_3.webp", "title": "Akustik Akşamlar", "artist": "Folk Müzisyen"},
    {"image": "assets/images/album_art_4.jpg", "title": "Ritim Kutusu", "artist": "Beat Maker"},
    {"image": "assets/images/album_art_5.jpg", "title": "Sonsuz Ufuklar", "artist": "Ambient Müzik"},
  ];

  final List<Map<String, String>> recommendedSongs = [
    {"image": "assets/images/album_art_5.jpg", "title": "Enerji Patlaması", "artist": "Rock Grubu"},
    {"image": "assets/images/album_art_1.webp", "title": "Sakin Melodiler", "artist": "Chillhop Prodüktörü"},
    {"image": "assets/images/album_art_2.webp", "title": "Dans Et Benimle", "artist": "Pop Vokalisti"},
  ];

  final List<String> moods = ["Romantik", "Antrenman", "Parti", "Odaklanma", "Hip Hop", "Retro", "Sakin", "Yolculuk"];

  Widget _buildHorizontalListSection({
    required String title,
    required List<Map<String, String>> items,
    VoidCallback? onSeeAll,
    required BuildContext context,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface, // inversePrimary yerine onSurface
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    "Tümünü Gör",
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            padding: const EdgeInsets.only(left: 20.0, right: 5.0, bottom: 10.0), // Sağ padding eklendi
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () {
                  print("${item["title"]} tıklandı!");
                  // Detay sayfasına yönlendirme veya çalma işlemi eklenebilir
                },
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              item["image"]!,
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Icon(Icons.music_off_rounded, color: colorScheme.onSecondary.withOpacity(0.5), size: 40,),
                                );
                              },
                            ),
                          ),
                          // Padding( // Opsiyonel oynat butonu
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: CircleAvatar(
                          //     backgroundColor: colorScheme.primary.withOpacity(0.8),
                          //     radius: 18,
                          //     child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item["title"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["artist"]!,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMoodsSection({required BuildContext context}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Modlar",
            style: TextStyle(
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
                },
                borderRadius: BorderRadius.circular(20.0),
                child: Chip(
                  label: Text(mood),
                  backgroundColor: colorScheme.secondary,
                  labelStyle: TextStyle(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: colorScheme.primary.withOpacity(0.5),
                      width: 1.5,
                    ),
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

    String greeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Günaydın';
      }
      if (hour < 17) {
        return 'Tünaydın';
      }
      return 'İyi Akşamlar';
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer: const MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            snap: false,
            elevation: Theme.of(context).appBarTheme.elevation ?? 0,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? colorScheme.surface,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor ?? colorScheme.onSurface,
            iconTheme: Theme.of(context).appBarTheme.iconTheme ?? IconThemeData(color: colorScheme.onSurface), // Drawer ikonu için
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 60.0, bottom: 16.0), // Drawer ikonu için sola boşluk
              title: Text(
                greeting(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color ?? colorScheme.onSurface,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_none_rounded, color: Theme.of(context).appBarTheme.actionsIconTheme?.color ?? colorScheme.onSurface),
                onPressed: () {
                  print("Bildirimler tıklandı");
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: TextField(
                    style: TextStyle(color: colorScheme.onSecondary), // Input text rengi
                    decoration: InputDecoration(
                      hintText: "Şarkı, sanatçı veya albüm ara...",
                      hintStyle: TextStyle(color: colorScheme.onSecondary.withOpacity(0.6)),
                      prefixIcon: Icon(Icons.search_rounded, color: colorScheme.onSecondary.withOpacity(0.7)),
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    ),
                    onSubmitted: (value) {
                      print("Aranan: $value");
                      // İdeal olarak burada SearchPage'e yönlendirme ve arama sorgusunu iletmek
                      // veya MainNavigationPage'deki _selectedIndex'i değiştirip SearchPage'e geçmek
                      // ve SearchPage'e bu değeri iletmek daha iyi olur.
                      // Örnek: (context.findAncestorStateOfType<_MainNavigationPageState>() as _MainNavigationPageState)._onItemTapped(1);
                      // SearchPage'in arama field'ını da bu değerle doldurmak gerekebilir.
                    },
                  ),
                ),
                _buildHorizontalListSection(
                  title: "Yeni Çıkanlar",
                  items: newReleases,
                  onSeeAll: () => print("Yeni Çıkanlar Tümünü Gör tıklandı"),
                  context: context,
                ),
                _buildHorizontalListSection(
                  title: "Sana Özel Öneriler",
                  items: recommendedSongs,
                  onSeeAll: () => print("Önerilenler Tümünü Gör tıklandı"),
                  context: context,
                ),
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