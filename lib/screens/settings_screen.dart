import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/biometric_service.dart';
import '../services/firestore_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _firestoreService = FirestoreService();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _selectedTheme = 'Dark';

  final List<String> _themes = ['Dark', 'Light', 'System'];

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

  Future<void> _loadSettings() async {
    final biometricService = BiometricService();
    final biometricEnabled = await biometricService.isEnabled();

    try {
      final profile = await _firestoreService.getUserProfile();
      if (profile != null) {
        setState(() {
          _firstNameController.text = profile['firstName'] ?? '';
          _lastNameController.text = profile['lastName'] ?? '';
          _notificationsEnabled = profile['notifications'] ?? true;
          _selectedTheme = profile['theme'] ?? 'Dark';
          _biometricEnabled = biometricEnabled;
        });
        return;
      }
    } catch (e) {
      print('Fehler: $e');
    }

    // Fallback auf lokale Daten
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = prefs.getString('firstName') ?? '';
      _lastNameController.text = prefs.getString('lastName') ?? '';
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _selectedTheme = prefs.getString('theme') ?? 'Dark';
      _biometricEnabled = biometricEnabled;
    });
  }

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

    // Auch lokal speichern als Backup
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', _firstNameController.text);
    await prefs.setString('lastName', _lastNameController.text);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setString('theme', _selectedTheme);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Einstellungen gespeichert!'),
          backgroundColor: Color(0xFF00D4AA),
        ),
      );
    }
  }

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
            // Avatar
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFF00D4AA),
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
                    '${_firstNameController.text} ${_lastNameController.text}'.trim().isEmpty
                        ? 'Kein Name'
                        : '${_firstNameController.text} ${_lastNameController.text}'.trim(),
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

            // Profil Section
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
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Einstellungen Section
            _SectionTitle(title: 'Einstellungen'),
            const SizedBox(height: 12),
            _SettingsCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.palette_outlined,
                            color: Color(0xFF00D4AA), size: 20),
                        const SizedBox(width: 12),
                        Text('Design',
                            style: GoogleFonts.inter(
                                color: Colors.white, fontSize: 14)),
                      ],
                    ),
                    DropdownButton<String>(
                      value: _selectedTheme,
                      dropdownColor: const Color(0xFF1A1F35),
                      style: GoogleFonts.inter(color: Colors.white),
                      underline: const SizedBox(),
                      items: _themes.map((t) {
                        return DropdownMenuItem(
                            value: t,
                            child: Text(t,
                                style: GoogleFonts.inter(
                                    color: Colors.white)));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedTheme = val!),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Benachrichtigungen & Sicherheit
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
                      final available =
                      await biometricService.isAvailable();
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
                ],
              ),
            ),
            const SizedBox(height: 24),

            // App Info
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
                  _InfoRow(
                    icon: Icons.security_outlined,
                    label: 'Datenschutz',
                    value: 'Anzeigen →',
                  ),
                  const Divider(color: Colors.white12),
                  _InfoRow(
                    icon: Icons.description_outlined,
                    label: 'Nutzungsbedingungen',
                    value: 'Anzeigen →',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
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