import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../services/biometric_service.dart';
import '../services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _firestoreService = FirestoreService();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _newsletterEnabled = false;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _selectedTheme = 'Dark';
  String _selectedCountry = 'DE';

  final List<Map<String, String>> _countries = [
    {'code': 'DE', 'name': '🇩🇪 Deutschland'},
    {'code': 'AT', 'name': '🇦🇹 Österreich'},
    {'code': 'CH', 'name': '🇨🇭 Schweiz'},
    {'code': 'EU', 'name': '🇪🇺 Europa (alle)'},
    {'code': 'ALL', 'name': '🌍 Weltweit'},
  ];

  // ─── Initialen ───
  String get _initials {
    final first = _firstNameController.text.isNotEmpty
        ? _firstNameController.text[0].toUpperCase()
        : '';
    final last = _lastNameController.text.isNotEmpty
        ? _lastNameController.text[0].toUpperCase()
        : '';
    if (first.isEmpty && last.isEmpty) return '?';
    return '$first$last';
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // ─── Einstellungen laden ───
  Future<void> _loadSettings() async {
    final biometricService = BiometricService();
    final biometricEnabled = await biometricService.isEnabled();
    final prefs = await SharedPreferences.getInstance();

    try {
      final profile = await _firestoreService.getUserProfile();
      if (profile != null) {
        setState(() {
          _firstNameController.text = profile['firstName'] ?? '';
          _lastNameController.text = profile['lastName'] ?? '';
          _notificationsEnabled = profile['notifications'] ?? true;
          _selectedTheme = profile['theme'] ?? 'Dark';
          _biometricEnabled = biometricEnabled;
          _newsletterEnabled = prefs.getBool('newsletter') ?? false;
          _selectedCountry = prefs.getString('country') ?? 'DE';
        });
        return;
      }
    } catch (e) {
      print('Fehler: $e');
    }

    // ─── Fallback auf lokale Daten ───
    setState(() {
      _firstNameController.text = prefs.getString('firstName') ?? '';
      _lastNameController.text = prefs.getString('lastName') ?? '';
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _selectedTheme = prefs.getString('theme') ?? 'Dark';
      _biometricEnabled = biometricEnabled;
      _newsletterEnabled = prefs.getBool('newsletter') ?? false;
      _selectedCountry = prefs.getString('country') ?? 'DE';
    });
  }

  // ─── Einstellungen speichern ───
  Future<void> _saveSettings() async {
    try {
      await _firestoreService.saveUserProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        notifications: _notificationsEnabled,
        theme: _selectedTheme,
      );
    } catch (e) {
      print('Fehler Firestore: $e');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', _firstNameController.text);
    await prefs.setString('lastName', _lastNameController.text);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setString('theme', _selectedTheme);
    await prefs.setBool('newsletter', _newsletterEnabled);
    await prefs.setString('country', _selectedCountry);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Einstellungen gespeichert!'),
          backgroundColor: Color(0xFF00D4AA),
        ),
      );
    }
  }

  // ─── Logout ───
  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131829),
        title: Text('Abmelden',
            style: GoogleFonts.inter(color: Colors.white)),
        content: Text('Möchtest du dich wirklich abmelden?',
            style: GoogleFonts.inter(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen',
                style: GoogleFonts.inter(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: Text('Abmelden',
                style: GoogleFonts.inter(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        automaticallyImplyLeading: false,
        title: Text('Einstellungen',
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: Text('Speichern',
                style: GoogleFonts.inter(color: const Color(0xFF00D4AA))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Avatar ───
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFF00D4AA).withValues(alpha: 0.8),
                    child: Text(
                      _initials,
                      style: GoogleFonts.inter(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_firstNameController.text} ${_lastNameController.text}'
                        .trim()
                        .isEmpty
                        ? 'Kein Name'
                        : '${_firstNameController.text} ${_lastNameController.text}'
                        .trim(),
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: GoogleFonts.inter(
                        fontSize: 14, color: Colors.white54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ─── Profil Section ───
            _SectionTitle(title: 'Profil'),
            const SizedBox(height: 12),
            _SettingsCard(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _firstNameController,
                    label: 'Vorname',
                    icon: Icons.person_outline,
                    onChanged: (_) => setState(() {}),
                  ),
                  const Divider(color: Colors.white12),
                  _buildTextField(
                    controller: _lastNameController,
                    label: 'Nachname',
                    icon: Icons.person_outline,
                    onChanged: (_) => setState(() {}),
                  ),
                  const Divider(color: Colors.white12),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'E-Mail',
                    value: user?.email ?? '',
                  ),
                  const Divider(color: Colors.white12),
                  _InfoRow(
                    icon: Icons.verified_user_outlined,
                    label: 'Konto Status',
                    value: user?.emailVerified == true
                        ? 'Verifiziert ✓'
                        : 'Nicht verifiziert',
                  ),
                  const Divider(color: Colors.white12),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Land',
                    value: _selectedCountry == 'DE'
                        ? '🇩🇪 Deutschland'
                        : _selectedCountry == 'AT'
                        ? '🇦🇹 Österreich'
                        : _selectedCountry == 'CH'
                        ? '🇨🇭 Schweiz'
                        : _selectedCountry == 'EU'
                        ? '🇪🇺 Europa'
                        : '🌍 Weltweit',
                  ),
                  const Divider(color: Colors.white12),

                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Benachrichtigungen & Sicherheit ───
            _SectionTitle(title: 'Benachrichtigungen & Sicherheit'),
            const SizedBox(height: 12),
            _SettingsCard(
              child: Column(
                children: [
                  _SwitchRow(
                    icon: Icons.notifications_outlined,
                    label: 'Push Benachrichtigungen',
                    value: _notificationsEnabled,
                    onChanged: (val) =>
                        setState(() => _notificationsEnabled = val),
                  ),
                  const Divider(color: Colors.white12),
                  _SwitchRow(
                    icon: Icons.fingerprint,
                    label: 'Biometrischer Login',
                    value: _biometricEnabled,
                    onChanged: (val) async {
                      final biometricService = BiometricService();
                      final available = await biometricService.isAvailable();
                      if (available) {
                        await biometricService.setEnabled(val);
                        setState(() => _biometricEnabled = val);
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Biometrie nicht verfügbar auf diesem Gerät!'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(color: Colors.white12),
                  _SwitchRow(
                    icon: Icons.email_outlined,
                    label: 'Newsletter abonnieren',
                    value: _newsletterEnabled,
                    onChanged: (val) =>
                        setState(() => _newsletterEnabled = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── App Info ───
            _SectionTitle(title: 'App Info'),
            const SizedBox(height: 12),
            _SettingsCard(
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.info_outline,
                    label: 'Version',
                    value: '1.0.0',
                  ),
                  const Divider(color: Colors.white12),
                  GestureDetector(
                    onTap: () async {
                      final uri = Uri.parse('https://monvesto.de/app-datenschutz');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: _InfoRow(
                      icon: Icons.security_outlined,
                      label: 'Datenschutz',
                      value: 'Anzeigen →',
                    ),
                  ),
                  const Divider(color: Colors.white12),
                  GestureDetector(
                    onTap: () async {
                      final uri = Uri.parse('https://monvesto.de/app-nutzungsbedingungen');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: _InfoRow(
                      icon: Icons.description_outlined,
                      label: 'Nutzungsbedingungen',
                      value: 'Anzeigen →',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Logout Button ───
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text('Abmelden',
                    style: GoogleFonts.inter(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ─── TextField Builder ───
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00D4AA), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                labelText: label,
                labelStyle:
                GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Title Widget ───
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF00D4AA),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2));
  }
}

// ─── Settings Card Widget ───
class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131829),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

// ─── Info Row Widget ───
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF00D4AA), size: 20),
              const SizedBox(width: 12),
              Text(label,
                  style:
                  GoogleFonts.inter(color: Colors.white, fontSize: 14)),
            ],
          ),
          Flexible(
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                style:
                GoogleFonts.inter(color: Colors.white54, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

// ─── Switch Row Widget ───
class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow(
      {required this.icon,
        required this.label,
        required this.value,
        required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF00D4AA), size: 20),
              const SizedBox(width: 12),
              Text(label,
                  style:
                  GoogleFonts.inter(color: Colors.white, fontSize: 14)),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF00D4AA),
          ),
        ],
      ),
    );
  }
}