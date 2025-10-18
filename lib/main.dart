import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'screens/splash_screen.dart';
import 'providers/event_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';
import 'theme/cyberpunk_theme.dart';

void main() {
  // Preserve the native splash screen briefly
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const ConferenceAgendaApp());
}

class ConferenceAgendaApp extends StatelessWidget {
  const ConferenceAgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Determine theme mode based on selection
          ThemeMode themeMode;
          switch (themeProvider.currentTheme) {
            case AppThemeType.light:
              themeMode = ThemeMode.light;
              break;
            case AppThemeType.dark:
              themeMode = ThemeMode.dark;
              break;
            case AppThemeType.neonDreams2077:
              themeMode = ThemeMode.dark; // Cyberpunk uses dark mode
              break;
          }

          return MaterialApp(
            title: 'EventFlow',
            theme: themeProvider.currentTheme == AppThemeType.neonDreams2077
                ? CyberpunkTheme.theme
                : AppTheme.lightTheme,
            darkTheme: themeProvider.currentTheme == AppThemeType.neonDreams2077
                ? CyberpunkTheme.theme
                : AppTheme.darkTheme,
            themeMode: themeMode,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
