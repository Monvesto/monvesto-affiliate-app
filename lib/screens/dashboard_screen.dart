import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'compare_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const CompareScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF131829),
        selectedItemColor: const Color(0xFF00D4AA),
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows), label: 'Vergleich'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: 'Favoriten'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Einstellungen'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  String _selectedCategory = 'Alle';
  List<String> _favorites = [];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'P2P Kredite',
      'icon': Icons.people_outline,
      'color': const Color(0xFF00D4AA),
    },
    {
      'name': 'Broker',
      'icon': Icons.show_chart,
      'color': const Color(0xFF0088CC),
    },
    {
      'name': 'Bankkonten',
      'icon': Icons.account_balance,
      'color': const Color(0xFFFF6B6B),
    },
    {
      'name': 'Krypto',
      'icon': Icons.currency_bitcoin,
      'color': const Color(0xFFFFD93D),
    },
  ];

  final List<Map<String, dynamic>> _providers = [
    {
      'name': 'Mintos',
      'category': 'P2P Kredite',
      'description': 'Europas größte P2P Plattform',
      'return': '8-12%',
      'rating': 4.5,
      'url': 'https://www.mintos.com',
      'color': const Color(0xFF00D4AA),
      'icon': Icons.people_outline,
      'pros': ['Große Auswahl', 'Sekundärmarkt', 'Auto-Invest'],
      'cons': ['Kreditrisiko', 'Währungsrisiko'],
    },
    {
      'name': 'Trade Republic',
      'category': 'Broker',
      'description': 'Einfaches und günstiges Investieren',
      'return': 'Variabel',
      'rating': 4.7,
      'url': 'https://www.traderepublic.com',
      'color': const Color(0xFF0088CC),
      'icon': Icons.show_chart,
      'pros': ['1€ pro Trade', '4% Zinsen', 'ETF Sparpläne'],
      'cons': ['Kein Margin Trading'],
    },
    {
      'name': 'ING',
      'category': 'Bankkonten',
      'description': 'Kostenloses Girokonto mit Extras',
      'return': '2-3%',
      'rating': 4.3,
      'url': 'https://www.ing.de',
      'color': const Color(0xFFFF6B6B),
      'icon': Icons.account_balance,
      'pros': ['Kostenlos', 'Tagesgeld', 'Kreditkarte'],
      'cons': ['Kein Filialnetz'],
    },
    {
      'name': 'Coinbase',
      'category': 'Krypto',
      'description': 'Die sicherste Krypto Exchange',
      'return': 'Variabel',
      'rating': 4.4,
      'url': 'https://www.coinbase.com',
      'color': const Color(0xFFFFD93D),
      'icon': Icons.currency_bitcoin,
      'pros': ['Sicher', 'Einfach', 'Staking'],
      'cons': ['Hohe Gebühren'],
    },
    {
      'name': 'Bondora',
      'category': 'P2P Kredite',
      'description': 'Go & Grow – einfaches P2P Investment',
      'return': '6.75%',
      'rating': 4.2,
      'url': 'https://www.bondora.com',
      'color': const Color(0xFF00D4AA),
      'icon': Icons.people_outline,
      'pros': ['Einfach', 'Liquide', 'Automatisch'],
      'cons': ['Begrenzte Rendite'],
    },
    {
      'name': 'Scalable Capital',
      'category': 'Broker',
      'description': 'Robo-Advisor & Broker in einem',
      'return': 'Variabel',
      'rating': 4.5,
      'url': 'https://www.scalable.capital',
      'color': const Color(0xFF0088CC),
      'icon': Icons.show_chart,
      'pros': ['Robo-Advisor', 'ETF Sparpläne', '4% Zinsen'],
      'cons': ['Prime Abo nötig'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _toggleFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favorites.contains(name)) {
        _favorites.remove(name);
      } else {
        _favorites.add(name);
      }
    });
    await prefs.setStringList('favorites', _favorites);
  }

  List<Map<String, dynamic>> get _filteredProviders {
    if (_selectedCategory == 'Alle') return _providers;
    return _providers
        .where((p) => p['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hallo 👋',
                        style: GoogleFonts.inter(
                            fontSize: 14, color: Colors.white54)),
                    Text('Monvesto Affiliate',
                        style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                const CircleAvatar(
                  backgroundColor: Color(0xFF00D4AA),
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D4AA), Color(0xFF0088CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Finde den besten Anbieter',
                      style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(
                    'Vergleiche P2P, Broker, Bankkonten und Krypto Exchanges',
                    style: GoogleFonts.inter(
                        fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_providers.length} Anbieter verfügbar',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Kategorien
            Text('Kategorien',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _CategoryChip(
                    label: 'Alle',
                    isSelected: _selectedCategory == 'Alle',
                    onTap: () =>
                        setState(() => _selectedCategory = 'Alle'),
                  ),
                  ..._categories.map((cat) => _CategoryChip(
                    label: cat['name'],
                    isSelected: _selectedCategory == cat['name'],
                    onTap: () => setState(
                            () => _selectedCategory = cat['name']),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Anbieter Liste
            Text('Anbieter',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 16),
            ..._filteredProviders.map((provider) => _ProviderCard(
              provider: provider,
              isFavorite: _favorites.contains(provider['name']),
              onFavoriteToggle: () =>
                  _toggleFavorite(provider['name']),
            )),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00D4AA)
              : const Color(0xFF131829),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(label,
              style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal)),
        ),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final Map<String, dynamic> provider;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _ProviderCard({
    required this.provider,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131829),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (provider['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(provider['icon'] as IconData,
                    color: provider['color'] as Color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(provider['name'],
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(provider['category'],
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.white54)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(provider['return'],
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00D4AA))),
                  Text('Rendite',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: Colors.white38)),
                ],
              ),
              IconButton(
                onPressed: onFavoriteToggle,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite ? Colors.red : Colors.white38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(provider['description'],
              style: GoogleFonts.inter(
                  fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 12),

          // Pros
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: (provider['pros'] as List<String>)
                .map((pro) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00D4AA)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('✓ $pro',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF00D4AA))),
            ))
                .toList(),
          ),
          const SizedBox(height: 12),

          // Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(provider['url']);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri,
                      mode: LaunchMode.externalApplication);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: provider['color'] as Color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Jetzt anmelden →',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}