import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String age,
    required String batch,
    required String university,
    String role = 'student',
  }) async {
    // Check if this specific email should be an admin
    final actualRole = email.trim().toLowerCase() == 'admin@events.com' ? 'admin' : role;

    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'age': age,
      'batch': batch,
      'university': university,
      'role': actualRole,
    });
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.id, doc.data()!);
  }

  Future<bool> isAdmin(String uid) async {
    final profile = await getUserProfile(uid);
    return profile?.role == 'admin';
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];

    final results = <UserModel>[];
    for (var i = 0; i < userIds.length; i += 10) {
      final chunk = userIds.sublist(i, i + 10 > userIds.length ? userIds.length : i + 10);
      final snapshot = await _db.collection('users').where(FieldPath.documentId, whereIn: chunk).get();
      results.addAll(snapshot.docs.map((doc) => UserModel.fromMap(doc.id, doc.data())));
    }
    return results;
  }

  Future<int> getStudentCount() async {
    final snapshot = await _db.collection('users').get();
    return snapshot.size;
  }
}
