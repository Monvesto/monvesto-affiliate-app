import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/search_bar_widget.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

String _searchQuery = '';

class _CompareScreenState extends State<CompareScreen> {
  String _selectedCategory = 'P2P Kredite';

  final Map<String, List<Map<String, dynamic>>> _compareData = {
    'P2P Kredite': [
      {
        'name': 'Mintos',
        'rendite': '8-12%',
        'minInvest': '10€',
        'rating': '4.5',
        'sicherheit': 'Mittel',
        'liquidität': 'Hoch',
        'color': const Color(0xFF00D4AA),
        'url': 'https://www.mintos.com',
      },
      {
        'name': 'Bondora',
        'rendite': '6.75%',
        'minInvest': '1€',
        'rating': '4.2',
        'sicherheit': 'Mittel',
        'liquidität': 'Hoch',
        'color': const Color(0xFF0088CC),
        'url': 'https://www.bondora.com',
      },
      {
        'name': 'Peerberry',
        'rendite': '9-11%',
        'minInvest': '10€',
        'rating': '4.3',
        'sicherheit': 'Mittel',
        'liquidität': 'Mittel',
        'color': const Color(0xFFFF6B6B),
        'url': 'https://www.peerberry.com',
      },
    ],
    'Broker': [
      {
        'name': 'Trade Republic',
        'rendite': '4% Zinsen',
        'minInvest': '1€',
        'rating': '4.7',
        'sicherheit': 'Hoch',
        'liquidität': 'Hoch',
        'color': const Color(0xFF00D4AA),
        'url': 'https://www.traderepublic.com',
      },
      {
        'name': 'Scalable',
        'rendite': '4% Zinsen',
        'minInvest': '1€',
        'rating': '4.5',
        'sicherheit': 'Hoch',
        'liquidität': 'Hoch',
        'color': const Color(0xFF0088CC),
        'url': 'https://www.scalable.capital',
      },
      {
        'name': 'ING Depot',
        'rendite': 'Variabel',
        'minInvest': '1€',
        'rating': '4.3',
        'sicherheit': 'Hoch',
        'liquidität': 'Hoch',
        'color': const Color(0xFFFF6B6B),
        'url': 'https://www.ing.de',
      },
    ],
    'Bankkonten': [
      {
        'name': 'ING',
        'rendite': '3%',
        'minInvest': '0€',
        'rating': '4.3',
        'sicherheit': 'Sehr Hoch',
        'liquidität': 'Sehr Hoch',
        'color': const Color(0xFF00D4AA),
        'url': 'https://www.ing.de',
      },
      {
        'name': 'DKB',
        'rendite': '2.5%',
        'minInvest': '0€',
        'rating': '4.2',
        'sicherheit': 'Sehr Hoch',
        'liquidität': 'Sehr Hoch',
        'color': const Color(0xFF0088CC),
        'url': 'https://www.dkb.de',
      },
    ],
    'Krypto': [
      {
        'name': 'Coinbase',
        'rendite': 'Variabel',
        'minInvest': '2€',
        'rating': '4.4',
        'sicherheit': 'Hoch',
        'liquidität': 'Hoch',
        'color': const Color(0xFF00D4AA),
        'url': 'https://www.coinbase.com',
      },
      {
        'name': 'Binance',
        'rendite': 'Variabel',
        'minInvest': '1€',
        'rating': '4.3',
        'sicherheit': 'Mittel',
        'liquidität': 'Sehr Hoch',
        'color': const Color(0xFF0088CC),
        'url': 'https://www.binance.com',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> providers = _compareData[_selectedCategory] ?? [];
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      providers = providers.where((p) =>
      p['name'].toString().toLowerCase().contains(query) ||
          p['rendite'].toString().toLowerCase().contains(query) ||
          p['sicherheit'].toString().toLowerCase().contains(query)
      ).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        automaticallyImplyLeading: false,
        title: Text('Vergleich',
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Kategorie auswählen
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _compareData.keys.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF00D4AA)
                            : const Color(0xFF131829),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(cat,
                            style: GoogleFonts.inter(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white54,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Suchfeld
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchBarWidget(
              hint: 'Anbieter suchen...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Vergleichstabelle
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131829),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text('Kriterium',
                                style: GoogleFonts.inter(
                                    color: Colors.white54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))),
                        ...providers.map((p) => Expanded(
                          child: Text(p['name'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  color: p['color'] as Color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Zeilen
                  _CompareRow(
                    label: 'Rendite',
                    values: providers
                        .map((p) => p['rendite'] as String)
                        .toList(),
                    colors: providers
                        .map((p) => p['color'] as Color)
                        .toList(),
                  ),
                  _CompareRow(
                    label: 'Min. Invest',
                    values: providers
                        .map((p) => p['minInvest'] as String)
                        .toList(),
                    colors: providers
                        .map((p) => p['color'] as Color)
                        .toList(),
                  ),
                  _CompareRow(
                    label: 'Bewertung',
                    values: providers
                        .map((p) => '⭐ ${p['rating']}')
                        .toList(),
                    colors: providers
                        .map((p) => p['color'] as Color)
                        .toList(),
                  ),
                  _CompareRow(
                    label: 'Sicherheit',
                    values: providers
                        .map((p) => p['sicherheit'] as String)
                        .toList(),
                    colors: providers
                        .map((p) => p['color'] as Color)
                        .toList(),
                  ),
                  _CompareRow(
                    label: 'Liquidität',
                    values: providers
                        .map((p) => p['liquidität'] as String)
                        .toList(),
                    colors: providers
                        .map((p) => p['color'] as Color)
                        .toList(),
                  ),
                  const SizedBox(height: 16),

                  // Buttons
                  ...providers.map((p) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () async {
                        final uri = Uri.parse(p['url'] as String);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: p['color'] as Color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('${p['name']} →',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  final String label;
  final List<String> values;
  final List<Color> colors;

  const _CompareRow({
    required this.label,
    required this.values,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF131829),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: GoogleFonts.inter(
                    color: Colors.white70, fontSize: 12)),
          ),
          ...values.asMap().entries.map((entry) => Expanded(
            child: Text(entry.value,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    color: colors[entry.key],
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          )),
        ],
      ),
    );
  }
}