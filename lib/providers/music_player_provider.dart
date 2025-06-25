import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/app_song_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application_0/database_helper.dart'; // Favori kontrolü için
import 'package:flutter_application_0/models/playlist_model.dart'; // Playlist sınıfı için

class MusicPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance; // Favori için

  AppSong? _currentSong;
  List<AppSong> _songQueue = [];
  int _currentIndex = -1;

  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isFavorite = false; // O an çalan şarkının favori durumu

  // Stream abonelikleri
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateSubscription;

  AppSong? get currentSong => _currentSong;
  List<AppSong> get songQueue => _songQueue;
  int get currentIndex => _currentIndex;
  PlayerState get playerState => _playerState;
  bool get isPlaying => _playerState == PlayerState.playing;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get isFavorite => _isFavorite;

  MusicPlayerProvider() {
    _initAudioPlayerListeners();
  }

  get currentSongIndex => null;

  void _initAudioPlayerListeners() {
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      notifyListeners();
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((newDuration) {
      _duration = newDuration;
      notifyListeners();
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      playNext(); // Şarkı bittiğinde sonraki şarkıya geç
    });
  }

  Future<void> _checkCurrentSongFavoriteStatus() async {
    if (_currentSong != null && _currentSong!.id != null) {
      _isFavorite = await _dbHelper.isFavorite(_currentSong!.id!);
    } else {
      _isFavorite = false;
    }
    notifyListeners();
  }

  Future<void> playSong(AppSong song, List<AppSong> queue, int index) async {
    await _audioPlayer.stop(); // Önce mevcut şarkıyı durdur
    _currentSong = song;
    _songQueue = queue;
    _currentIndex = index;
    _position = Duration.zero; // Pozisyonu sıfırla
    // _duration sıfırlanmayacak, onDurationChanged ile güncellenecek

    if (_currentSong!.filePath != null && _currentSong!.filePath!.isNotEmpty) {
      try {
        String assetPath = "audio/${_currentSong!.filePath}";
        await _audioPlayer.play(AssetSource(assetPath));
        await _checkCurrentSongFavoriteStatus(); // Favori durumunu yükle
      } catch (e) {
        print("MusicPlayerProvider - Şarkı çalınırken hata: $e");
        _playerState = PlayerState.stopped;
        notifyListeners();
      }
    } else {
      _playerState = PlayerState.stopped;
      print("MusicPlayerProvider - Şarkı dosya yolu bulunamadı.");
      notifyListeners();
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _position = Duration.zero; // Durdurulduğunda pozisyonu sıfırla
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> playNext() async {
    if (_songQueue.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _songQueue.length;
    _currentSong = _songQueue[_currentIndex];
    await playSong(_currentSong!, _songQueue, _currentIndex); // Tekrar playSong çağırıyoruz
  }

  Future<void> playPrevious() async {
    if (_songQueue.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _songQueue.length) % _songQueue.length;
    _currentSong = _songQueue[_currentIndex];
    await playSong(_currentSong!, _songQueue, _currentIndex);
  }

  Future<void> toggleFavorite() async {
    if (_currentSong == null || _currentSong!.id == null) return;
    bool newFavoriteStatus = !_isFavorite;
    if (newFavoriteStatus) {
      await _dbHelper.addFavorite(_currentSong!.id!);
    } else {
      await _dbHelper.removeFavorite(_currentSong!.id!);
    }
    _isFavorite = newFavoriteStatus;
    notifyListeners();
    // SnackBar gösterme işi UI tarafında yapılabilir
  }

  // Çalma listesine ekleme
  Future<bool> addCurrentSongToPlaylist(Playlist playlist) async {
    if (_currentSong == null || _currentSong!.id == null || playlist.id == null) return false;
    try {
      int result = await _dbHelper.addSongToPlaylist(playlist.id!, _currentSong!.id!);
      return result > 0;
    } catch (e) {
      print("MusicPlayerProvider - Çalma listesine ekleme hatası: $e");
      return false;
    }
  }


  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose(); // En önemlisi player'ı dispose etmek
    super.dispose();
  }
}