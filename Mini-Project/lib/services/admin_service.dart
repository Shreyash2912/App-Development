import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Master admin credentials
  static const Map<String, String> _masterAdmins = {
    'shreyashkerkar@gmail.com': 'shreyash',
    'vpg@gmail.com': '987654',
  };

  // Check if email is a master admin
  static bool isMasterAdminEmail(String email) {
    return _masterAdmins.containsKey(email.toLowerCase());
  }

  // ---------------------- ADMIN LOGIN ----------------------
  static Future<Map<String, dynamic>> adminLogin(String email, String password) async {
    final normalizedEmail = email.toLowerCase();

    if (!_masterAdmins.containsKey(normalizedEmail)) {
      return {'success': false, 'error': 'Email is not a master admin'};
    }

    if (_masterAdmins[normalizedEmail] != password) {
      return {'success': false, 'error': 'Invalid password'};
    }

    try {
      try {
        await _auth.signInWithEmailAndPassword(
          email: normalizedEmail,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          await _auth.createUserWithEmailAndPassword(
            email: normalizedEmail,
            password: password,
          );
        } else {
          return {'success': false, 'error': e.message ?? e.code};
        }
      }

      final uid = _auth.currentUser?.uid;
      if (uid == null) return {'success': false, 'error': 'Authentication failed'};

      final now = FieldValue.serverTimestamp();
      await _db.collection('users').doc(uid).set({
        'email': normalizedEmail,
        'role': 'admin',
        'name': normalizedEmail == 'shreyashkerkar@gmail.com'
            ? 'Student Admin'
            : 'Professor Admin',
        'premium': true,
        'createdAt': now,
        'updatedAt': now,
      }, SetOptions(merge: true));

      await _logAdminAction(
        action: 'admin_login',
        target: normalizedEmail,
      );

      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // ---------------------- ROLE CHECK ----------------------
  static Future<bool> isCurrentUserAdmin() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _db.collection('users').doc(user.uid).get();
    final role = doc.data()?['role'];
    return role == 'admin' || isMasterAdminEmail(user.email ?? '');
  }

  // ---------------------- SEARCH USER ----------------------
  static Future<Map<String, dynamic>?> searchUserByEmail(String email) async {
    try {
      final query = await _db
          .collection('users')
          .where('email', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final doc = query.docs.first;
      return {'uid': doc.id, ...doc.data()};
    } catch (e) {
      print('Search user error: $e');
      return null;
    }
  }

  // ---------------------- TOGGLE PREMIUM ----------------------
  static Future<bool> toggleUserPremium(String uid, bool premium) async {
    try {
      final actorUid = _auth.currentUser?.uid;
      if (actorUid == null) return false;

      await _db.collection('users').doc(uid).update({
        'premium': premium,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _logAdminAction(
        action: 'toggle_premium',
        target: uid,
      );

      return true;
    } catch (e) {
      print('Toggle premium error: $e');
      return false;
    }
  }

  // ============================================================
  //               🚀 FIXED FEATURE FLAGS SYSTEM
  // ============================================================

  // ----------- READ FEATURE FLAGS -----------
  static Future<Map<String, dynamic>> getFeatureFlags() async {
    try {
      final doc = await _db.collection('feature_flags').doc('global').get();

      if (doc.exists && (doc.data()?['flags'] != null)) {
        return Map<String, dynamic>.from(doc.data()!['flags']);
      }

      // Create defaults if missing
      const defaultFlags = {'newUI': false};

      await _db.collection('feature_flags').doc('global').set({
        'flags': defaultFlags,
      }, SetOptions(merge: true));

      return defaultFlags;
    } catch (e) {
      print('Get feature flags error: $e');
      return {'newUI': false};
    }
  }

  // ----------- STREAM FEATURE FLAGS -----------
  static Stream<Map<String, dynamic>> getFeatureFlagsStream() {
    return _db
        .collection('feature_flags')
        .doc('global')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data()!.containsKey('flags')) {
        return Map<String, dynamic>.from(snapshot.data()!['flags']);
      }
      return {'newUI': false};
    });
  }

  // ----------- UPDATE A FEATURE FLAG -----------
  static Future<bool> updateFeatureFlag(String flag, bool value) async {
    try {
      final docRef = _db.collection('feature_flags').doc('global');

      await docRef.set({
        'flags': {flag: value}
      }, SetOptions(merge: true));

      await _logAdminAction(
        action: 'update_feature_flag',
        target: flag,
      );

      return true;
    } catch (e) {
      print('Update feature flag error: $e');
      return false;
    }
  }

  // ============================================================

  // ---------------------- AUDIT LOGS ----------------------
  static Stream<List<Map<String, dynamic>>> getAuditLogs({int limit = 50}) {
    return _db
        .collection('audit_logs')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // ---------------------- LOG ACTION ----------------------
  static Future<void> _logAdminAction({
    required String action,
    required String target,
  }) async {
    try {
      final actorUid = _auth.currentUser?.uid;
      if (actorUid == null) return;

      await _db.collection('audit_logs').add({
        'actorUid': actorUid,
        'action': action,
        'target': target,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Log admin action error: $e');
    }
  }

  // Public wrapper
  static Future<void> logAdminAction({
    required String action,
    required String target,
  }) async {
    await _logAdminAction(action: action, target: target);
  }
}
