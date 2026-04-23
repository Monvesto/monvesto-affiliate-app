import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'icon': Icons.trending_up,
      'title': 'Willkommen bei Monvesto',
      'description':
      'Deine Plattform für die besten Finanzanbieter – einfach, übersichtlich und kostenlos.',
      'color': const Color(0xFF00D4AA),
    },
    {
      'icon': Icons.compare_arrows,
      'title': 'Vergleiche Anbieter',
      'description':
      'P2P Kredite, Broker, Bankkonten und Krypto Exchanges auf einen Blick vergleichen.',
      'color': const Color(0xFF0088CC),
    },
    {
      'icon': Icons.favorite_outline,
      'title': 'Merke dir deine Favoriten',
      'description':
      'Speichere die besten Anbieter in deinen Favoriten und greife jederzeit darauf zu.',
      'color': const Color(0xFFFF6B6B),
    },
    {
      'icon': Icons.rocket_launch_outlined,
      'title': 'Bereit loszulegen?',
      'description':
      'Registriere dich kostenlos für alle Features oder schaue dich erst unverbindlich um.',
      'color': const Color(0xFF00D4AA),
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: SafeArea(
        child: Column(
          children: [
            // Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  final isLast = index == _slides.length - 1;

                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: (slide['color'] as Color)
                                .withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            slide['icon'] as IconData,
                            size: 60,
                            color: slide['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Titel
                        Text(
                          slide['title'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 16),

                        // Beschreibung
                        Text(
                          slide['description'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.white54,
                              height: 1.5),
                        ),
                        const SizedBox(height: 48),

                        // Letzter Slide - Buttons
                        if (isLast) ...[
                          // Registrieren Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _completeOnboarding();
                                if (mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, '/register');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFF00D4AA).withValues(alpha: 0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text('Registrieren',
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Ohne Anmeldung Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () async {
                                await _completeOnboarding();
                                if (mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, '/guest');
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: const Color(0xFF00D4AA)
                                        .withValues(alpha: 0.5)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text('Ohne Anmeldung fortfahren',
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00D4AA))),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Ich habe schon einen Account
                          GestureDetector(
                            onTap: () async {
                              await _completeOnboarding();
                              if (mounted) {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              }
                            },
                            child: Text(
                              'Ich habe schon einen Account',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white38,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white38),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots & Next Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots
                  Row(
                    children: List.generate(
                      _slides.length,
                          (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF00D4AA)
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Next Button
                  if (_currentPage < _slides.length - 1)
                    GestureDetector(
                      onTap: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D4AA).withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                      ),
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