import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favorites = [];

  final List<Map<String, dynamic>> _allProviders = [
    {
      'name': 'Mintos',
      'category': 'P2P Kredite',
      'return': '8-12%',
      'color': const Color(0xFF00D4AA),
      'icon': Icons.people_outline,
      'url': 'https://www.mintos.com',
    },
    {
      'name': 'Trade Republic',
      'category': 'Broker',
      'return': 'Variabel',
      'color': const Color(0xFF0088CC),
      'icon': Icons.show_chart,
      'url': 'https://www.traderepublic.com',
    },
    {
      'name': 'ING',
      'category': 'Bankkonten',
      'return': '2-3%',
      'color': const Color(0xFFFF6B6B),
      'icon': Icons.account_balance,
      'url': 'https://www.ing.de',
    },
    {
      'name': 'Coinbase',
      'category': 'Krypto',
      'return': 'Variabel',
      'color': const Color(0xFFFFD93D),
      'icon': Icons.currency_bitcoin,
      'url': 'https://www.coinbase.com',
    },
    {
      'name': 'Bondora',
      'category': 'P2P Kredite',
      'return': '6.75%',
      'color': const Color(0xFF00D4AA),
      'icon': Icons.people_outline,
      'url': 'https://www.bondora.com',
    },
    {
      'name': 'Scalable Capital',
      'category': 'Broker',
      'return': 'Variabel',
      'color': const Color(0xFF0088CC),
      'icon': Icons.show_chart,
      'url': 'https://www.scalable.capital',
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

  Future<void> _removeFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites.remove(name);
    });
    await prefs.setStringList('favorites', _favorites);
  }

  List<Map<String, dynamic>> get _favoriteProviders {
    return _allProviders
        .where((p) => _favorites.contains(p['name']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        automaticallyImplyLeading: false,
        title: Text('Favoriten',
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _favoriteProviders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_outline,
                color: Colors.white24, size: 64),
            const SizedBox(height: 16),
            Text('Noch keine Favoriten',
                style: GoogleFonts.inter(
                    color: Colors.white54, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Füge Anbieter zu deinen Favoriten hinzu!',
                style: GoogleFonts.inter(
                    color: Colors.white38, fontSize: 14)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _favoriteProviders.length,
        itemBuilder: (context, index) {
          final provider = _favoriteProviders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131829),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (provider['color'] as Color)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(provider['icon'] as IconData,
                      color: provider['color'] as Color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(provider['name'],
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(
                          '${provider['category']} • ${provider['return']}',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white54)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        final uri =
                        Uri.parse(provider['url'] as String);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: const Icon(Icons.open_in_new,
                          color: Color(0xFF00D4AA)),
                    ),
                    IconButton(
                      onPressed: () =>
                          _removeFavorite(provider['name']),
                      icon: const Icon(Icons.favorite,
                          color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}