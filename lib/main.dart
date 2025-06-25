import 'package:flutter/material.dart';
import 'package:flutter_application_0/themes/theme_provider.dart'; // KENDİ PROJE ADINIZI KULLANIN
import 'package:provider/provider.dart';
import 'package:flutter_application_0/main_navigation_page.dart'; // KENDİ PROJE ADINIZI KULLANIN
import 'package:flutter_application_0/providers/music_player_provider.dart'; // KENDİ PROJE ADINIZI KULLANIN


void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Önemli: Eklentilerin düzgün çalışması için
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => MusicPlayerProvider()), // MusicPlayerProvider eklendi
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MelodyFlow', // Uygulama adını değiştirebilirsiniz
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const MainNavigationPage(),
    );
  }
}