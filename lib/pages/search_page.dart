import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      if(mounted) { // State güncellenmeden önce widget'in mount olup olmadığını kontrol et
        setState(() {
          _searchResults = [];
          _hasSearched = false;
        });
      }
      return;
    }

    if(mounted) {
      setState(() {
        _isLoading = true;
        _hasSearched = true;
      });
    }


    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          if (query.toLowerCase().contains("şarkı")) {
            _searchResults = List.generate(5, (index) => "Bulunan Şarkı: ${query.trim()} ${index + 1}");
          } else if (query.toLowerCase().contains("sanatçı")) {
            _searchResults = List.generate(3, (index) => "Bulunan Sanatçı: ${query.trim()} ${index + 1}");
          } else {
            _searchResults = [];
          }
          _isLoading = false;
        });
      }
    });
  }

  Widget _buildDiscoveryCard({
    required String imagePath,
    required String title,
    required Color backgroundColor, // Temadan bağımsız belirli renkler için
    VoidCallback? onTap,
  }) {
    // Belirli renkler yerine tema renklerini de kullanabilirsiniz.
    // final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap ?? () => print("$title tıklandı"),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43, // Genişliği biraz ayarladım
        height: 100, // Yüksekliği Spotify benzeri yaptım
        margin: const EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6.0), // Köşeleri daha az yuvarlak
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade800, // Hata durumunda koyu renk
                    child: Icon(Icons.broken_image, color: Colors.grey.shade600),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8, // Yazıyı üste aldım
              left: 8,
              right: 8,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white, // Genelde bu kartlarda beyaz yazı kullanılır
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(blurRadius: 1.0, color: Colors.black45, offset: Offset(0,1))
                  ]
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseCategoryCard({
    required String title,
    required Color backgroundColor, // Temadan bağımsız belirli renkler için
    String? cornerImagePath,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () => print("$title kategorisi tıklandı"),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge, // Köşedeki resmin taşmasını engellemek için
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left:12.0, right: 12.0, bottom: 25.0), // Alt padding artırıldı
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17, // Yazı boyutu biraz büyütüldü
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2, // Uzun başlıklar için
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (cornerImagePath != null)
              Positioned(
                bottom: -8, // Daha iyi görünüm için ayarlandı
                right: -20, // Daha iyi görünüm için ayarlandı
                child: Transform.rotate(
                  angle: 0.43, // Açı biraz ayarlandı
                  child: ClipRRect( // Köşeleri resme de uygula
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.asset(
                      cornerImagePath,
                      width: 70, // Boyut biraz büyütüldü
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    Widget bodyContent;
    if (_isLoading) {
      bodyContent = Center(child: CircularProgressIndicator(color: colorScheme.primary));
    } else if (_hasSearched && _searchResults.isEmpty) {
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "\"${_searchController.text.trim()}\" için sonuç bulunamadı.",
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 16),
          ),
        ),
      );
    } else if (_hasSearched && _searchResults.isNotEmpty) {
      bodyContent = ListView.builder(
        padding: const EdgeInsets.only(top: 8.0),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.music_note_rounded, color: colorScheme.primary),
            title: Text(_searchResults[index], style: TextStyle(color: colorScheme.onSurface)),
            onTap: () {
              print("${_searchResults[index]} tıklandı");
            },
          );
        },
      );
    } else {
      bodyContent = ListView(
        padding: const EdgeInsets.only(top:16.0, bottom: 16.0), // İçerik için genel padding
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Yeni bir şey keşfet",
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100, // _buildDiscoveryCard yüksekliği ile aynı
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildDiscoveryCard(
                  imagePath: 'assets/images/album_art_1.webp',
                  title: 'Sana özel müzikler',
                  backgroundColor: Colors.deepPurple.shade400,
                ),
                _buildDiscoveryCard(
                  imagePath: 'assets/images/album_art_2.webp',
                  title: '#anadolu rock',
                  backgroundColor: Colors.orange.shade500,
                ),
                _buildDiscoveryCard(
                  imagePath: 'assets/images/album_art_3.webp',
                  title: 'Sana uygun Podcast\'ler',
                  backgroundColor: Colors.teal.shade400,
                ),
                 _buildDiscoveryCard( // Bir tane daha ekleyelim
                  imagePath: 'assets/images/album_art_4.jpg',
                  title: 'Yeni Çıkanlar',
                  backgroundColor: Colors.indigo.shade400,
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Hepsine göz at",
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 16/9, // Daha yaygın bir oran (Spotify'a benzer)
              children: [
                _buildBrowseCategoryCard(
                  title: 'Müzik',
                  backgroundColor: Colors.pink.shade400,
                  cornerImagePath: 'assets/images/album_art_4.jpg',
                ),
                _buildBrowseCategoryCard(
                  title: 'Podcast\'ler',
                  backgroundColor: Colors.green.shade600,
                  cornerImagePath: 'assets/images/album_art_5.jpg',
                ),
                _buildBrowseCategoryCard(
                  title: 'Canlı Etkinlikler',
                  backgroundColor: Colors.purple.shade400,
                  cornerImagePath: 'assets/images/album_art_6.jpg',
                ),
                _buildBrowseCategoryCard(
                  title: 'Senin için Hazırlandı',
                  backgroundColor: Colors.blueGrey.shade500,
                  cornerImagePath: 'assets/images/album_art_1.webp',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Geri tuşunu gösterme
        backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: appBarTheme.elevation ?? 0,
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: colorScheme.secondary,
            child: Icon(Icons.person_outline_rounded, color: colorScheme.onSecondary, size: 22),
          ),
        ),
        title: Text(
          "Ara",
          style: appBarTheme.titleTextStyle ?? TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 24, // Spotify gibi daha büyük başlık
          ),
        ),
        centerTitle: false, // Spotify'da sola yakın
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt_outlined, color: appBarTheme.actionsIconTheme?.color ?? colorScheme.onSurface),
            onPressed: () {
              print("Kamera ikonu tıklandı");
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0), // Dikey padding ayarlandı
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: colorScheme.onSecondary), // Input text rengi
              decoration: InputDecoration(
                hintText: "Ne dinlemek istiyorsun?",
                hintStyle: TextStyle(color: colorScheme.onSecondary.withOpacity(0.7)),
                prefixIcon: Icon(Icons.search_rounded, color: colorScheme.onSecondary.withOpacity(0.7)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded, color: colorScheme.onSecondary.withOpacity(0.7)),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                          if(mounted) setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.secondary,
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0), // Dikey padding ayarlandı
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                if(mounted) setState(() {}); // Suffix icon'u güncellemek için
                // Debounce ile arama yapmak daha iyi olur:
                // _performSearch(value);
              },
              onSubmitted: _performSearch,
            ),
          ),
          Expanded(child: bodyContent),
        ],
      ),
    );
  }
}