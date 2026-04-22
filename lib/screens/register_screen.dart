import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ─── Controller ───
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ─── State Variablen ───
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  String? _errorMessage;
  String _selectedCountry = 'DE';

  // ─── Länderliste ───
  final List<Map<String, String>> _countries = [
    {'code': 'DE', 'name': '🇩🇪 Deutschland'},
    {'code': 'AT', 'name': '🇦🇹 Österreich'},
    {'code': 'CH', 'name': '🇨🇭 Schweiz'},
    {'code': 'EU', 'name': '🇪🇺 Europa (alle)'},
    {'code': 'ALL', 'name': '🌍 Weltweit'},
  ];

  // ─── Registrierung ───
  Future<void> _register() async {
    // Validierung
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      setState(() => _errorMessage = 'Bitte Vor- und Nachname eingeben!');
      return;
    }
    if (_emailController.text.isEmpty) {
      setState(() => _errorMessage = 'Bitte E-Mail eingeben!');
      return;
    }
    if (_passwordController.text.length < 6) {
      setState(
              () => _errorMessage = 'Passwort muss mindestens 6 Zeichen haben!');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwörter stimmen nicht überein!');
      return;
    }
    if (!_acceptedTerms) {
      setState(() =>
      _errorMessage = 'Bitte Datenschutz und Nutzungsbedingungen akzeptieren!');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Firebase Account erstellen
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Profil in Firestore speichern
      if (credential.user != null) {
        final firestoreService = FirestoreService();
        await firestoreService.saveUserProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          notifications: true,
          theme: 'Dark',
        );

        // Land lokal speichern
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('country', _selectedCountry);
        await prefs.setString('firstName', _firstNameController.text.trim());
        await prefs.setString('lastName', _lastNameController.text.trim());
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _getError(e.code));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ─── Fehlermeldungen ───
  String _getError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Diese E-Mail wird bereits verwendet.';
      case 'weak-password':
        return 'Das Passwort ist zu schwach.';
      case 'invalid-email':
        return 'Ungültige E-Mail Adresse.';
      default:
        return 'Ein Fehler ist aufgetreten.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Registrieren',
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ───
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D4AA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Konto erstellen',
                  style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Alle Features kostenlos nutzen',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.white54),
                ),
              ),
              const SizedBox(height: 32),

              // ─── Fehlermeldung ───
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Text(_errorMessage!,
                      style:
                      GoogleFonts.inter(color: Colors.red, fontSize: 14)),
                ),

              // ─── Vorname ───
              Text('Vorname',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _firstNameController,
                hint: 'Max',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              // ─── Nachname ───
              Text('Nachname',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _lastNameController,
                hint: 'Mustermann',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              // ─── E-Mail ───
              Text('E-Mail',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: 'deine@email.de',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // ─── Passwort ───
              Text('Passwort',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF131829),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.lock_outlined,
                      color: Color(0xFF00D4AA)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white38,
                    ),
                    onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ─── Passwort bestätigen ───
              Text('Passwort bestätigen',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF131829),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.lock_outlined,
                      color: Color(0xFF00D4AA)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white38,
                    ),
                    onPressed: () => setState(() =>
                    _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ─── Land ───
              Text('Land',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF131829),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: _selectedCountry,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1A1F35),
                  style: GoogleFonts.inter(color: Colors.white),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Color(0xFF00D4AA)),
                  items: _countries.map((c) {
                    return DropdownMenuItem(
                      value: c['code'],
                      child: Text(c['name']!,
                          style: GoogleFonts.inter(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _selectedCountry = val!),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Datenschutz Checkbox ───
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    onChanged: (val) =>
                        setState(() => _acceptedTerms = val!),
                    activeColor: const Color(0xFF00D4AA),
                    side: const BorderSide(color: Colors.white38),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                              color: Colors.white70, fontSize: 13),
                          children: [
                            const TextSpan(text: 'Ich akzeptiere die '),
                            TextSpan(
                              text: 'Datenschutzerklärung',
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF00D4AA),
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final uri = Uri.parse('https://monvesto.de/app-datenschutz');
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                },
                            ),
                            const TextSpan(text: ' und die '),
                            TextSpan(
                              text: 'Nutzungsbedingungen',
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF00D4AA),
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final uri = Uri.parse('https://monvesto.de/app-nutzungsbedingungen');
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                },
                            ),
                            const TextSpan(text: ' *'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ─── Registrieren Button ───
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4AA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Jetzt registrieren',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ─── TextField Builder ───
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF131829),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF00D4AA)),
      ),
    );
  }
}