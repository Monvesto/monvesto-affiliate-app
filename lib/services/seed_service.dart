import 'package:cloud_firestore/cloud_firestore.dart';

class SeedService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> seedProviders() async {
    final providers = [
      // ─────────────────────────────────────────
      // P2P
      // ─────────────────────────────────────────
      {
        // Basis
        'name': 'Mintos',
        'category': 'P2P Kredite',
        'description': 'Europas größte P2P Plattform mit über 70 Kreditgebern aus ganz Europa.',
        'return': '8-12%',
        'rating': 4.5,
        'url': 'https://www.mintos.com',
        'colorHex': '00D4AA',
        'order': 11.0,
        'active': true,
        'public': true,
        'referral': false,
        'countries': ['DE', 'AT', 'CH', 'EU'],
        'pros': ['Große Auswahl', 'Sekundärmarkt', 'Auto-Invest'],
        'cons': ['Kreditrisiko', 'Währungsrisiko'],
        'tags': ['p2p', 'kredit', 'zinsen', 'passiveseinkommen', 'autoinvest', 'rendite'],
        // P2P-spezifisch
        'minInvestment': 10.0,
        'buyback': true,
        'autoInvest': true,
        'secondaryMarket': true,
        'avgDuration': '12 Monate',
        'regulation': '',
      },
      {
        // Basis
        'name': 'Bondora',
        'category': 'P2P Kredite',
        'description': 'Go & Grow – einfaches und liquides P2P Investment mit fester Rendite.',
        'return': '6.75%',
        'rating': 4.2,
        'url': 'https://www.bondora.com',
        'colorHex': '00D4AA',
        'order': 5.0,
        'active': true,
        'public': true,
        'referral': false,
        'countries': ['DE', 'AT', 'CH', 'EU'],
        'pros': ['Einfach', 'Liquide', 'Automatisch'],
        'cons': ['Begrenzte Rendite'],
        'tags': ['p2p', 'kredit', 'zinsen', 'passiveseinkommen', 'liquide', 'rendite'],
        // P2P-spezifisch
        'minInvestment': 1.0,
        'buyback': false,
        'autoInvest': true,
        'secondaryMarket': false,
        'avgDuration': 'Flexibel',
        'regulation': '',
      },
      {
        // Basis
        'name': 'Peerberry',
        'category': 'P2P Kredite',
        'description': 'Zuverlässige P2P Plattform mit Buyback Garantie.',
        'return': '9-11%',
        'rating': 4.3,
        'url': 'https://www.peerberry.com',
        'colorHex': '00D4AA',
        'order': 9.0,
        'active': true,
        'public': true,
        'referral': false,
        'countries': ['DE', 'AT', 'CH', 'EU'],
        'pros': ['Buyback Garantie', 'Stabil', 'Einfach'],
        'cons': ['Weniger Auswahl', 'Kreditrisiko'],
        'tags': ['p2p', 'kredit', 'zinsen', 'buyback', 'rendite', 'passiveseinkommen'],
        // P2P-spezifisch
        'minInvestment': 10.0,
        'buyback': true,
        'autoInvest': true,
        'secondaryMarket': false,
        'avgDuration': '12 Monate',
        'regulation': '',
      },

      // ─────────────────────────────────────────
      // BROKER
      // ─────────────────────────────────────────
      {
        // Basis
        'name': 'Trade Republic',
        'category': 'Broker',
        'description': 'Einfaches und günstiges Investieren in Aktien, ETFs und Krypto.',
        'return': 'Variabel',
        'rating': 4.7,
        'url': 'https://www.traderepublic.com',
        'colorHex': '0088CC',
        'order': 2.0,
        'active': true,
        'public': true,
        'referral': false,
        'countries': ['DE', 'AT', 'CH', 'EU'],
        'pros': ['1€ pro Trade', '4% Zinsen', 'ETF Sparpläne'],
        'cons': ['Kein Margin Trading'],
        'tags': ['broker', 'aktien', 'etf', 'sparplan', 'depot', 'trading', 'zinsen'],
        // Broker-spezifisch
        'orderFee': '1€',
        'depotFee': 'Kostenlos',
        'markets': ['Aktien', 'ETFs', 'Krypto', 'Derivate'],
        'etfSavingsPlan': true,
        'cryptoTrading': true,
        'interestRate': '4%',
        'regulation': 'BaFin',
      },
      {
        // Basis
        'name': 'Scalable Capital',
        'category': 'Broker',
        'description': 'Robo-Advisor und Broker in einem – ideal für langfristiges Investieren.',
        'return': 'Variabel',
        'rating': 4.5,
        'url': 'https://www.scalable.capital',
        'colorHex': '0088CC',
        'order': 6.0,
        'active': true,
        'public': true,
        'referral': false,
        'countries': ['DE', 'AT', 'CH'],
        'pros': ['Robo-Advisor', 'ETF Sparpläne', '4% Zinsen'],
        'cons': ['Prime Abo nötig'],
        'tags': ['broker', 'aktien', 'etf', 'roboadvisor', 'sparplan', 'depot', 'trading'],
        // Broker-spezifisch
        'orderFee': '0€ (Prime)',
        'depotFee': 'Kostenlos',
        'markets': ['Aktien', 'ETFs', 'Fonds', 'Krypto'],
        'etfSavingsPlan': true,
        'cryptoTrading': true,
        'interestRate': '4%',
        'regulation': 'BaFin',
      },
      {
        // Basis
        'name': 'ING Depot',
        'category': 'Broker',
        'description': 'Günstiges Depot der ING Bank für Aktien und ETFs.',
        'return': 'Variabel',
        'rating': 4.3,
        'url': 'https://www.ing.de/depot',
        'colorHex': '0088CC',
        'order': 10.0,
        'active': true,
        'public': true,
        'referral': false,
        'countries': ['DE'],
        'pros': ['Günstig', 'Seriös', 'ETF Sparpläne'],
        'cons': ['Weniger Features'],
        'tags': ['broker', 'aktien', 'etf', 'sparplan', 'depot', 'trading'],
        // Broker-spezifisch
        'orderFee': 'Ab 3,90€',
        'depotFee': 'Kostenlos',
        'markets': ['Aktien', 'ETFs', 'Fonds', 'Anleihen'],
        'etfSavingsPlan': true,
        'cryptoTrading': false,
        'interestRate': '',
        'regulation': 'BaFin',
      },

      // ─────────────────────────────────────────
      // BANK
      // ─────────────────────────────────────────
      {
        // Basis
        'name': 'C24 Bank',
        'category': 'Bankkonten',
        'description': 'Kostenloses Girokonto mit Tagesgeld, Unterkonten und Kreditkarte.',
        'return': '1,5%',
        'rating': 5,
        'url': 'https://www.ing.de',
        'colorHex': 'FF6B6B',
        'order': 1.0,
        'active': true,
        'public': true,
        'referral': true,
        'countries': ['DE'],
        'pros': ['Kostenlos', 'Tagesgeld', 'Kreditkarte'],
        'cons': ['Kein Filialnetz'],
        'tags': ['bank', 'girokonto', 'tagesgeld', 'zinsen', 'kreditkarte', 'kostenlos', 'sparen'],
        // Bank-spezifisch
        'accountFee': 'Kostenlos',
        'savingsRate': '1,5%',
        'creditCard': true,
        'branches': false,
        'depositInsurance': '100.000€',
        'mobilePay': false,
      },
      {
        // Basis
        'name': 'ING',
        'category': 'Bankkonten',
        'description': 'Kostenloses Girokonto mit Tagesgeld und Kreditkarte.',
        'return': '2-3%',
        'rating': 4.3,
        'url': 'https://www.ing.de',
        'colorHex': 'FF6B6B',
        'order': 3.0,
        'active': true,
        'public': true,
        'referral': false,
        'countries': ['DE'],
        'pros': ['Kostenlos', 'Tagesgeld', 'Kreditkarte'],
        'cons': ['Kein Filialnetz'],
        'tags': ['bank', 'girokonto', 'tagesgeld', 'zinsen', 'kreditkarte', 'kostenlos', 'sparen'],
        // Bank-spezifisch
        'accountFee': 'Kostenlos',
        'savingsRate': '2.75%',
        'creditCard': true,
        'branches': false,
        'depositInsurance': '100.000€',
        'mobilePay': true,
      },
      {
        // Basis
        'name': 'DKB',
        'category': 'Bankkonten',
        'description': 'Kostenloses Girokonto mit Visa Karte und attraktivem Tagesgeld.',
        'return': '2.5%',
        'rating': 4.2,
        'url': 'https://www.dkb.de',
        'colorHex': 'FF6B6B',
        'order': 7.0,
        'active': true,
        'public': true,
        'referral': false,
        'countries': ['DE'],
        'pros': ['Kostenlos', 'Visa Karte', 'Tagesgeld'],
        'cons': ['Nur online', 'Kein Filialnetz'],
        'tags': ['bank', 'girokonto', 'tagesgeld', 'zinsen', 'visa', 'kostenlos', 'sparen'],
        // Bank-spezifisch
        'accountFee': 'Kostenlos',
        'savingsRate': '2.5%',
        'creditCard': true,
        'branches': false,
        'depositInsurance': '100.000€',
        'mobilePay': true,
      },

      // ─────────────────────────────────────────
      // KRYPTO
      // ─────────────────────────────────────────
      {
        // Basis
        'name': 'Coinbase',
        'category': 'Krypto',
        'description': 'Die sicherste und bekannteste Krypto Exchange weltweit.',
        'return': 'Variabel',
        'rating': 4.4,
        'url': 'https://www.coinbase.com',
        'colorHex': 'FFD93D',
        'order': 4.0,
        'active': true,
        'public': true,
        'referral': false,
        'countries': ['DE', 'AT', 'CH', 'EU'],
        'pros': ['Sicher', 'Einfach', 'Staking'],
        'cons': ['Hohe Gebühren'],
        'tags': ['krypto', 'bitcoin', 'ethereum', 'crypto', 'trading', 'staking', 'btc', 'eth'],
        // Krypto-spezifisch
        'tradingFees': '0.5-1.5%',
        'coinCount': 250,
        'staking': true,
        'regulation': 'MiCA lizenziert',
      },
      {
        // Basis
        'name': 'Binance',
        'category': 'Krypto',
        'description': 'Weltgrößte Krypto Exchange mit über 600 Kryptowährungen.',
        'return': 'Variabel',
        'rating': 4.3,
        'url': 'https://www.binance.com',
        'colorHex': 'FFD93D',
        'order': 8.0,
        'active': true,
        'public': true,
        'referral': false,
        'countries': ['DE', 'AT', 'CH', 'EU'],
        'pros': ['Günstig', 'Große Auswahl', 'Staking'],
        'cons': ['Komplex', 'Regulierungsrisiko'],
        'tags': ['krypto', 'bitcoin', 'ethereum', 'crypto', 'trading', 'staking', 'btc', 'eth', 'altcoins'],
        // Krypto-spezifisch
        'tradingFees': '0.1%',
        'coinCount': 600,
        'staking': true,
        'regulation': '',
      },
    ];

    // Bestehende Namen aus Firestore laden
    final existing = await _db.collection('providers').get();
    final existingNames = existing.docs.map((d) => d.data()['name'] as String).toSet();

    int added = 0;
    int skipped = 0;

    for (final provider in providers) {
      final name = provider['name'] as String;
      if (existingNames.contains(name)) {
        print('⏭️  Übersprungen (existiert bereits): $name');
        skipped++;
      } else {
        await _db.collection('providers').add(provider);
        print('✅ Hinzugefügt: $name');
        added++;
      }
    }

    print('🎉 Fertig! $added hinzugefügt, $skipped übersprungen.');
  }
}