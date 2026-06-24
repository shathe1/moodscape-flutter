import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  // CREATE — register new user
  static Future<String> createUser({
    required String name,
    required String email,
  }) async {
    final docRef = await _db.collection('users').add({
      'name': name,
      'email': email,
      'handle': '@${name.toLowerCase().replaceAll(' ', '')}_moods',
      'moodsLogged': 0,
      'savedPlaces': 0,
      'moodStreak': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // READ — get user profile
  static Future<Map<String, dynamic>?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.data();
  }

  // UPDATE — update name and handle
  static Future<void> updateUser(
    String userId,
    String name,
    String handle,
  ) async {
    await _db.collection('users').doc(userId).update({
      'name': name,
      'handle': handle,
    });
  }

  // CREATE — save a place
  static Future<String> savePlace({
    required String userId,
    required String name,
    required String emoji,
    required double rating,
    required double distanceKm,
    required String mood,
  }) async {
    final docRef = await _db.collection('saved_places').add({
      'userId': userId,
      'name': name,
      'emoji': emoji,
      'rating': rating,
      'distanceKm': distanceKm,
      'mood': mood,
      'savedAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('users').doc(userId).update({
      'savedPlaces': FieldValue.increment(1),
    });
    return docRef.id;
  }

  // READ — stream of saved places
  static Stream<QuerySnapshot> getSavedPlaces(String userId) {
    return _db
        .collection('saved_places')
        .where('userId', isEqualTo: userId)
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  // DELETE — remove a saved place
  static Future<void> deletePlace(String placeId, String userId) async {
    await _db.collection('saved_places').doc(placeId).delete();
    await _db.collection('users').doc(userId).update({
      'savedPlaces': FieldValue.increment(-1),
    });
  }

  // READ — find user by email (for login)
  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final query = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    final doc = query.docs.first;
    return {'id': doc.id, ...doc.data()};
  }
}
