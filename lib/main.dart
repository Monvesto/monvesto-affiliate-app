import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initialize();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider()..init(),
      child: const MonvestoAffiliateApp(),
    ),
  );
}

class MonvestoAffiliateApp extends StatelessWidget {
  const MonvestoAffiliateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Monvesto Affiliate',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF00D4AA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF00D4AA),
          secondary: Color(0xFF1A1F35),
          surface: Color(0xFFF5F5F5),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
        primaryColor: const Color(0xFF00D4AA),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D4AA),
          secondary: Color(0xFF1A1F35),
          surface: Color(0xFF131829),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/guest': (context) => const DashboardScreen(isGuest: true),
      },
    );
  }
}