import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'compare_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import 'detail/provider_detail_screen.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/search_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detail/p2p_detail_screen.dart';
import 'detail/broker_detail_screen.dart';
import 'detail/bank_detail_screen.dart';
import 'detail/crypto_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  final bool isGuest;
  const DashboardScreen({super.key, this.isGuest = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _HomeContent(isGuest: widget.isGuest),
      const CompareScreen(),
      const FavoritesScreen(),
      const SettingsScreen(),
    ];
  }

  void _showGuestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131829),
        title: Text('Funktion gesperrt',
            style: GoogleFonts.inter(color: Colors.white)),
        content: Text(
            'Diese Funktion ist nur für registrierte Nutzer verfügbar!',
            style: GoogleFonts.inter(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen',
                style: GoogleFonts.inter(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Jetzt registrieren',
                style: GoogleFonts.inter(
                    color: const Color(0xFF00D4AA),
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (widget.isGuest && (index == 1 || index == 2)) {
            _showGuestDialog(context);
            return;
          }
          setState(() => _currentIndex = index);
        },
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
  final bool isGuest;
  const _HomeContent({this.isGuest = false});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  String _selectedCategory = 'Alle';
  List<String> _favorites = [];
  String _searchQuery = '';
  String _userCountry = 'DE';
  final _firestoreService = FirestoreService();

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
      'name': 'Krypto',
      'icon': Icons.currency_bitcoin,
      'color': const Color(0xFFFFD93D),
    },
    {
      'name': 'Bankkonten',
      'icon': Icons.account_balance,
      'color': const Color(0xFFFF6B6B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadCountry();
  }

  Future<void> _loadCountry() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userCountry = prefs.getString('country') ?? 'DE';
    });
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

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return const Color(0xFF00D4AA);
    }
  }

  IconData _categoryToIcon(String category) {
    switch (category) {
      case 'P2P Kredite':
        return Icons.people_outline;
      case 'Broker':
        return Icons.show_chart;
      case 'Bankkonten':
        return Icons.account_balance;
      case 'Krypto':
        return Icons.currency_bitcoin;
      default:
        return Icons.attach_money;
    }
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
                    Text('Willkommen!',
                        style: GoogleFonts.inter(
                            fontSize: 14, color: Colors.white54)),
                    Text('Monvesto',
                        style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    context
                        .findAncestorStateOfType<_DashboardScreenState>()
                        ?._currentIndex = 3;
                    context
                        .findAncestorStateOfType<_DashboardScreenState>()
                        ?.setState(() {});
                  },
                  child: const _ProfileAvatar(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00897B), Color(0xFF005F8A)],
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
                ],
              ),
            ),

            // Gast Banner
            if (widget.isGuest) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4AA).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF00D4AA).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline,
                        color: Color(0xFF00D4AA), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Registriere dich kostenlos für alle Anbieter und Features!',
                        style: GoogleFonts.inter(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: Text('Jetzt →',
                          style: GoogleFonts.inter(
                              color: const Color(0xFF00D4AA),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Suchfeld
            SearchBarWidget(
              hint: 'Anbieter suchen...',
              onChanged: (val) => setState(() {
                _searchQuery = val;
                if (val.isNotEmpty) {
                  _selectedCategory = 'Alle';
                }
              }),
            ),
            const SizedBox(height: 24),

            // Kategorien
            Text('Kategorien',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CategoryChip(
                  label: 'Alle',
                  isSelected: _selectedCategory == 'Alle',
                  onTap: () => setState(() => _selectedCategory = 'Alle'),
                ),
                ..._categories.map((cat) => _CategoryChip(
                  label: cat['name'],
                  isSelected: _selectedCategory == cat['name'],
                  onTap: () => setState(() => _selectedCategory = cat['name']),
                )),
              ],
            ),
            const SizedBox(height: 24),

            // Anbieter Liste
            Text('Anbieter',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: widget.isGuest
                  ? _firestoreService.getPublicProviders()
                  : _firestoreService.getProvidersByCountry(_userCountry),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF00D4AA)),
                  );
                }

                final docs = snapshot.data!.docs;
                var filtered = docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    ...data, // ← alle Firestore Felder direkt übernehmen
                    'rating': double.tryParse(data['rating'].toString()) ?? 0.0,
                    'color': _hexToColor(data['colorHex'] ?? '00D4AA'),
                    'icon': _categoryToIcon(data['category'] ?? ''),
                    'pros': data['pros'] is List ? List<dynamic>.from(data['pros']) : [],
                    'cons': data['cons'] is List ? List<dynamic>.from(data['cons']) : [],
                    'tags': data['tags'] is List ? List<dynamic>.from(data['tags']) : [],
                  };
                }).toList();

                // Kategorie Filter
                if (_selectedCategory != 'Alle') {
                  filtered = filtered
                      .where((p) => p['category'] == _selectedCategory)
                      .toList();
                }

                // Suche Filter
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  filtered = filtered.where((p) {
                    if (p['name']
                        .toString()
                        .toLowerCase()
                        .contains(query)) return true;
                    if (p['category']
                        .toString()
                        .toLowerCase()
                        .contains(query)) return true;
                    if (p['description']
                        .toString()
                        .toLowerCase()
                        .contains(query)) return true;
                    final tags = p['tags'] as List<dynamic>;
                    if (tags.any((tag) =>
                        tag.toLowerCase().contains(query))) return true;
                    return false;
                  }).toList();
                }

                // Gäste sehen nur Top 3
                if (widget.isGuest) {
                  filtered = filtered.take(3).toList();
                }

                return Column(
                  children: filtered
                      .map((provider) => _ProviderCard(
                    provider: provider,
                    isFavorite:
                    _favorites.contains(provider['name']),
                    onFavoriteToggle: () =>
                        _toggleFavorite(provider['name']),
                  ))
                      .toList(),
                );
              },
            ),
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
        margin: const EdgeInsets.only(right: 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00D4AA).withValues(alpha: 0.8)
              : const Color(0xFF131829),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(label,
            style: GoogleFonts.inter(
                color: isSelected ? Colors.white : Colors.white54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
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
    return GestureDetector(
      onTap: () {
        final category = provider['category'];
        Widget screen;

        switch (category) {
          case 'P2P Kredite':
            screen = P2PDetailScreen(provider: provider);
            break;
          case 'Broker':
            screen = BrokerDetailScreen(provider: provider);
            break;
          case 'Krypto':
            screen = CryptoDetailScreen(provider: provider);
            break;
          case 'Bankkonten':
            screen = BankDetailScreen(provider: provider);
            break;
          default:
            screen = ProviderDetailScreen(provider: provider);
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
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
                    color: (provider['color'] as Color)
                        .withValues(alpha: 0.1),
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
                if (provider['return'] != null && provider['return'].toString().isNotEmpty && provider['return'].toString() != 'Variabel')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(provider['return'],
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF00D4AA))),
                      Text(
                            () {
                          switch (provider['category']) {
                            case 'Bankkonten': return 'Tagesgeld';
                            case 'Krypto': return 'Staking';
                            case 'Broker': return 'Zinsen';
                            default: return 'Rendite';
                          }
                        }(),
                        style: GoogleFonts.inter(fontSize: 10, color: Colors.white38),
                      ),
                    ],
                  ),
                IconButton(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline,
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

            // Pros + Referral Badge
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ...(provider['pros'] as List<dynamic>).map((pro) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D4AA).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('✓ $pro',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: const Color(0xFF00D4AA))),
                )),
                if (provider['referral'] == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD93D).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('👥 Freunde werben möglich',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: const Color(0xFFFFD93D))),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse(provider['url']);
                  try {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.platformDefault,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (provider['color'] as Color).withValues(alpha: 0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      ),
    );
  }
}

class _ProfileAvatar extends StatefulWidget {
  const _ProfileAvatar();

  @override
  State<_ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<_ProfileAvatar> {
  String _initials = '?';

  @override
  void initState() {
    super.initState();
    _loadInitials();
  }

  Future<void> _loadInitials() async {
    final prefs = await SharedPreferences.getInstance();
    var first = prefs.getString('firstName') ?? '';
    var last = prefs.getString('lastName') ?? '';

    if (first.isEmpty && last.isEmpty) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
        if (doc.exists) {
          first = doc.data()?['firstName'] ?? '';
          last = doc.data()?['lastName'] ?? '';
          await prefs.setString('firstName', first);
          await prefs.setString('lastName', last);
        }
      } catch (e) {
        print('Fehler: $e');
      }
    }

    if (mounted) {
      setState(() {
        final f = first.isNotEmpty ? first[0].toUpperCase() : '';
        final l = last.isNotEmpty ? last[0].toUpperCase() : '';
        _initials = (f + l).isEmpty ? '?' : f + l;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color(0xFF00D4AA).withValues(alpha: 0.8),
      child: Text(
        _initials,
        style: GoogleFonts.inter(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}