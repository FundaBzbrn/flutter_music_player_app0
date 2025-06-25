import 'package:flutter/material.dart';
import 'package:flutter_application_0/themes/theme_provider.dart'; // Yolu kontrol et
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    final textTheme = Theme.of(context).textTheme;
    final switchTheme = Theme.of(context).switchTheme; // Switch temasını alalım

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'A Y A R L A R',
          style: appBarTheme.titleTextStyle ??
                 TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
        ),
        backgroundColor: appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: appBarTheme.elevation ?? 0,
        centerTitle: true,
        iconTheme: appBarTheme.iconTheme ?? IconThemeData(color: colorScheme.onSurface),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Görünüm Ayarları",
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Koyu Mod",
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: switchTheme.thumbColor?.resolve({WidgetState.selected}) ?? colorScheme.primary,
                    activeTrackColor: switchTheme.trackColor?.resolve({WidgetState.selected}) ?? colorScheme.primary.withOpacity(0.5),
                    inactiveThumbColor: switchTheme.thumbColor?.resolve({}) ?? Colors.grey.shade400,
                    inactiveTrackColor: switchTheme.trackColor?.resolve({}) ?? Colors.grey.shade200,
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}