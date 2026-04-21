import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        automaticallyImplyLeading: false,
        title: Text('Vergleich',
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Text('Vergleich kommt bald!',
            style: GoogleFonts.inter(color: Colors.white54)),
      ),
    );
  }
}