import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CryptoDetailScreen extends StatefulWidget {
  final Map<String, dynamic> provider;

  const CryptoDetailScreen({super.key, required this.provider});

  @override
  State<CryptoDetailScreen> createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends State<CryptoDetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      _isFavorite = favorites.contains(widget.provider['name']);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      if (_isFavorite) {
        favorites.remove(widget.provider['name']);
      } else {
        favorites.add(widget.provider['name']);
      }
      _isFavorite = !_isFavorite;
    });
    await prefs.setStringList('favorites', favorites);
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
          Text(value,
              style: GoogleFonts.inter(
                  color: valueColor ?? Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final color = provider['color'] as Color;
    final hasReturn = provider['return'] != null &&
        provider['return'].toString().isNotEmpty &&
        provider['return'].toString() != 'Variabel';

    final coinCount = provider['coinCount'] != null
        ? provider['coinCount'].toString()
        : 'k.A.';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: CustomScrollView(
        slivers: [
          // ─── Header ───
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF0A0E1A),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(provider['icon'] as IconData, color: Colors.white, size: 48),
                    ),
                    const SizedBox(height: 12),
                    Text(provider['name'],
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Krypto Exchange',
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Badges ───
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Staking Badge – nur wenn gepflegt
                      if (hasReturn)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: color.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.trending_up, color: color, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${provider['return']} Staking',
                                style: GoogleFonts.inter(color: color, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      // Bewertung Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131829),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFFD93D), size: 16),
                            const SizedBox(width: 4),
                            Text('${provider['rating']}',
                                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      // Referral Badge
                      if (provider['referral'] == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD93D).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFFD93D).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.people_outline, color: Color(0xFFFFD93D), size: 16),
                              const SizedBox(width: 4),
                              Text('Freunde werben möglich ✓',
                                  style: GoogleFonts.inter(
                                      color: const Color(0xFFFFD93D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ─── Beschreibung ───
                  Text('Über ${provider['name']}',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(provider['description'],
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.white70, height: 1.5)),
                  const SizedBox(height: 24),

                  // ─── Krypto Details ───
                  Text('Krypto Details',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131829),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _infoRow('Trading Gebühren', provider['tradingFees'] ?? 'k.A.'),
                        const Divider(color: Colors.white12),
                        _infoRow('Anzahl Coins', coinCount),
                        const Divider(color: Colors.white12),
                        _infoRow(
                          'Staking',
                          provider['staking'] == true ? 'Ja ✓' : 'Nein',
                          valueColor: provider['staking'] == true
                              ? const Color(0xFF00D4AA)
                              : Colors.white54,
                        ),
                        const Divider(color: Colors.white12),
                        _infoRow('Regulierung', provider['regulation'] ?? 'k.A.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ─── Vorteile ───
                  Text('Vorteile',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  ...(provider['pros'] as List<dynamic>).map((pro) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4AA).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF00D4AA), size: 18),
                        const SizedBox(width: 8),
                        Text(pro, style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 24),

                  // ─── Nachteile ───
                  Text('Nachteile',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  ...(provider['cons'] as List<dynamic>).map((con) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cancel, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Text(con, style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 32),

                  // ─── Anmelden Button ───
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        final uri = Uri.parse(provider['url']);
                        try {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } catch (e) {
                          await launchUrl(uri, mode: LaunchMode.platformDefault);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.withValues(alpha: 0.8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Jetzt bei ${provider['name']} anmelden →',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      '* Affiliate Link – wir erhalten eine Provision',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}