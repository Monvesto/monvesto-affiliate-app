import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

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

  // Anbieter laden
  Stream<QuerySnapshot> getProviders() {
    return _db
        .collection('providers')
        .snapshots();
  }
}