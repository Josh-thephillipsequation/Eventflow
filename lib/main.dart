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
          // Select theme based on current theme type
          ThemeData selectedTheme;
          switch (themeProvider.currentTheme) {
            case AppThemeType.light:
              selectedTheme = AppTheme.lightTheme;
              break;
            case AppThemeType.dark:
              selectedTheme = AppTheme.darkTheme;
              break;
            case AppThemeType.neonDreams2077:
              selectedTheme = CyberpunkTheme.theme;
              break;
          }
          
          return MaterialApp(
            title: 'EventFlow',
            theme: selectedTheme,
            darkTheme: selectedTheme,
            themeMode: ThemeMode.dark, // Always use dark mode for cyberpunk
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
