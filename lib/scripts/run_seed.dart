import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/seed_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  print('🔐 Einloggen...');
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: 'monvesto@yahoo.com',
    password: 'Test123!',
  );
  print('✅ Eingeloggt!');

  print('🌱 Starte Seed...');
  await SeedService().seedProviders();
  print('✅ Seed abgeschlossen!');
}