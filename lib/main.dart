import 'package:flutter/material.dart';
import 'package:flutter_application_0/themes/theme_provider.dart'; // Proje adına göre yolu güncelle
import 'package:provider/provider.dart';
import 'package:flutter_application_0/main_navigation_page.dart'; // Proje adına göre yolu güncelle

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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
      title: 'Müzik Uygulaması',
      theme: Provider.of<ThemeProvider>(context).themeData, // Temayı Provider'dan al
      home: const MainNavigationPage(), // Ana navigasyon sayfasını başlat
    );
  }
}