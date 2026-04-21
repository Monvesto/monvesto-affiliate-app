import 'package:cloud_firestore/cloud_firestore.dart';

class SeedService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> seedProviders() async {
    final providers = [
      {
        'name': 'Mintos',
        'category': 'P2P Kredite',
        'description': 'Europas größte P2P Plattform mit über 70 Kreditgebern aus ganz Europa.',
        'return': '8-12%',
        'rating': 4.5,
        'url': 'https://www.mintos.com',
        'colorHex': '00D4AA',
        'order': 1,
        'active': true,
        'pros': ['Große Auswahl', 'Sekundärmarkt', 'Auto-Invest'],
        'cons': ['Kreditrisiko', 'Währungsrisiko'],
        'tags': ['p2p', 'kredit', 'zinsen', 'passiveseinkommen', 'investieren', 'europa', 'autoinvest', 'rendite'],
      },
      {
        'name': 'Trade Republic',
        'category': 'Broker',
        'description': 'Einfaches und günstiges Investieren in Aktien, ETFs und Krypto.',
        'return': 'Variabel',
        'rating': 4.7,
        'url': 'https://www.traderepublic.com',
        'colorHex': '0088CC',
        'order': 2,
        'active': true,
        'pros': ['1€ pro Trade', '4% Zinsen', 'ETF Sparpläne'],
        'cons': ['Kein Margin Trading'],
        'tags': ['broker', 'aktien', 'etf', 'sparplan', 'investieren', 'depot', 'trading', 'zinsen'],
      },
      {
        'name': 'ING',
        'category': 'Bankkonten',
        'description': 'Kostenloses Girokonto mit Tagesgeld und Kreditkarte.',
        'return': '2-3%',
        'rating': 4.3,
        'url': 'https://www.ing.de',
        'colorHex': 'FF6B6B',
        'order': 3,
        'active': true,
        'pros': ['Kostenlos', 'Tagesgeld', 'Kreditkarte'],
        'cons': ['Kein Filialnetz'],
        'tags': ['bank', 'girokonto', 'tagesgeld', 'zinsen', 'kreditkarte', 'kostenlos', 'sparen'],
      },
      {
        'name': 'Coinbase',
        'category': 'Krypto',
        'description': 'Die sicherste und bekannteste Krypto Exchange weltweit.',
        'return': 'Variabel',
        'rating': 4.4,
        'url': 'https://www.coinbase.com',
        'colorHex': 'FFD93D',
        'order': 4,
        'active': true,
        'pros': ['Sicher', 'Einfach', 'Staking'],
        'cons': ['Hohe Gebühren'],
        'tags': ['krypto', 'bitcoin', 'ethereum', 'crypto', 'trading', 'staking', 'btc', 'eth'],
      },
      {
        'name': 'Bondora',
        'category': 'P2P Kredite',
        'description': 'Go & Grow – einfaches und liquides P2P Investment mit fester Rendite.',
        'return': '6.75%',
        'rating': 4.2,
        'url': 'https://www.bondora.com',
        'colorHex': '00D4AA',
        'order': 5,
        'active': true,
        'pros': ['Einfach', 'Liquide', 'Automatisch'],
        'cons': ['Begrenzte Rendite'],
        'tags': ['p2p', 'kredit', 'zinsen', 'passiveseinkommen', 'investieren', 'liquide', 'rendite'],
      },
      {
        'name': 'Scalable Capital',
        'category': 'Broker',
        'description': 'Robo-Advisor und Broker in einem – ideal für langfristiges Investieren.',
        'return': 'Variabel',
        'rating': 4.5,
        'url': 'https://www.scalable.capital',
        'colorHex': '0088CC',
        'order': 6,
        'active': true,
        'pros': ['Robo-Advisor', 'ETF Sparpläne', '4% Zinsen'],
        'cons': ['Prime Abo nötig'],
        'tags': ['broker', 'aktien', 'etf', 'roboadvisor', 'sparplan', 'investieren', 'depot', 'trading'],
      },
      {
        'name': 'DKB',
        'category': 'Bankkonten',
        'description': 'Kostenloses Girokonto mit Visa Karte und attraktivem Tagesgeld.',
        'return': '2.5%',
        'rating': 4.2,
        'url': 'https://www.dkb.de',
        'colorHex': 'FF6B6B',
        'order': 7,
        'active': true,
        'pros': ['Kostenlos', 'Visa Karte', 'Tagesgeld'],
        'cons': ['Nur online', 'Kein Filialnetz'],
        'tags': ['bank', 'girokonto', 'tagesgeld', 'zinsen', 'visa', 'kostenlos', 'sparen'],
      },
      {
        'name': 'Binance',
        'category': 'Krypto',
        'description': 'Weltgrößte Krypto Exchange mit über 600 Kryptowährungen.',
        'return': 'Variabel',
        'rating': 4.3,
        'url': 'https://www.binance.com',
        'colorHex': 'FFD93D',
        'order': 8,
        'active': true,
        'pros': ['Günstig', 'Große Auswahl', 'Staking'],
        'cons': ['Komplex', 'Regulierungsrisiko'],
        'tags': ['krypto', 'bitcoin', 'ethereum', 'crypto', 'trading', 'staking', 'btc', 'eth', 'altcoins'],
      },
      {
        'name': 'Peerberry',
        'category': 'P2P Kredite',
        'description': 'Zuverlässige P2P Plattform mit Buyback Garantie.',
        'return': '9-11%',
        'rating': 4.3,
        'url': 'https://www.peerberry.com',
        'colorHex': '00D4AA',
        'order': 9,
        'active': true,
        'pros': ['Buyback Garantie', 'Stabil', 'Einfach'],
        'cons': ['Weniger Auswahl', 'Kreditrisiko'],
        'tags': ['p2p', 'kredit', 'zinsen', 'buyback', 'investieren', 'rendite', 'passiveseinkommen'],
      },
      {
        'name': 'ING Depot',
        'category': 'Broker',
        'description': 'Günstiges Depot der ING Bank für Aktien und ETFs.',
        'return': 'Variabel',
        'rating': 4.3,
        'url': 'https://www.ing.de/depot',
        'colorHex': '0088CC',
        'order': 10,
        'active': true,
        'pros': ['Günstig', 'Seriös', 'ETF Sparpläne'],
        'cons': ['Weniger Features'],
        'tags': ['broker', 'aktien', 'etf', 'sparplan', 'investieren', 'depot', 'trading'],
      },
    ];

    // Bestehende Anbieter löschen
    final existing = await _db.collection('providers').get();
    for (final doc in existing.docs) {
      await doc.reference.delete();
    }

    // Neue Anbieter eintragen
    for (final provider in providers) {
      await _db.collection('providers').add(provider);
    }

    print('✅ ${providers.length} Anbieter erfolgreich importiert!');
  }
}