import 'package:flutter/material.dart';
import 'package:flutter_application_0/themes/theme_provider.dart'; // Proje adına göre yolu güncelle
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'A Y A R L A R',
          style: appBarTheme.titleTextStyle ?? TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: appBarTheme.elevation ?? 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 8.0), // Dikey padding azaltıldı
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Koyu Mod",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.onSecondary,
                    ),
                  ),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: colorScheme.primary,
                    inactiveThumbColor: colorScheme.onSecondary.withOpacity(0.6),
                    inactiveTrackColor: colorScheme.onSecondary.withOpacity(0.3),
                  ),
                ],
              ),
              // Buraya başka ayar seçenekleri eklenebilir
              // Divider(color: colorScheme.onSecondary.withOpacity(0.2)),
              // ListTile(
              //   title: Text("Dil", style: TextStyle(color: colorScheme.onSecondary)),
              //   trailing: Icon(Icons.arrow_forward_ios_rounded, color: colorScheme.onSecondary.withOpacity(0.7)),
              //   onTap: () {},
              // ),
            ],
          ),
        ),
      ),
    );
  }
}