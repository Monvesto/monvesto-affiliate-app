import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // Alle Anbieter für eingeloggte Nutzer
  Stream<QuerySnapshot> getProviders() {
    return _db
        .collection('providers')
        .where('active', isEqualTo: true)
        .orderBy('order')
        .snapshots();
  }

  // Nur öffentliche Anbieter für Gäste
  Stream<QuerySnapshot> getPublicProviders() {
    return _db
        .collection('providers')
        .where('active', isEqualTo: true)
        .where('public', isEqualTo: true)
        .orderBy('order')
        .snapshots();
  }

  // Nutzerdaten speichern
  Future<void> saveUserProfile({
    required String firstName,
    required String lastName,
    required bool notifications,
    required String theme,
  }) async {
    await _db.collection('users').doc(_uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'notifications': notifications,
      'theme': theme,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Nutzerdaten laden
  Future<Map<String, dynamic>?> getUserProfile() async {
    final doc = await _db.collection('users').doc(_uid).get();
    return doc.data();
  }
}