import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/admin_service.dart';

class AppState extends ChangeNotifier {
  bool isReady = false;

  // ---------------- BASIC SETTINGS ----------------
  String? targetLanguageCode = 'es';
  String difficulty = 'normal';

  bool isLoggedIn = false;
  bool isPremium = false; // FINAL CORRECT VARIABLE NAME
  String? displayName;
  String? role; // "user" or "admin"
  
  bool get isAdmin => role == 'admin';

  AppState() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Check if user is already logged in
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final snap = await _db.collection('users').doc(user.uid).get();
        if (snap.exists) {
          final data = snap.data()!;
          isLoggedIn = true;
          displayName = data['name'] ?? "User";
          isPremium = data['premium'] ?? false;
          // Check role from Firestore, or check if email is admin
          role = data['role'];
          if (role == null || role == 'user') {
            // Check if email is a master admin
            if (AdminService.isMasterAdminEmail(user.email ?? '')) {
              role = 'admin';
              // Update Firestore to set role as admin
              await _db.collection('users').doc(user.uid).update({
                'role': 'admin',
                'premium': true,
                'updatedAt': FieldValue.serverTimestamp(),
              });
              isPremium = true;
            } else {
              role = 'user';
            }
          }
          targetLanguageCode = data['targetLanguageCode'] ?? targetLanguageCode;
          streak = data['streak'] ?? 0;
          totalQuestions = data['totalQuestions'] ?? 0;
          totalChallenges = data['totalChallenges'] ?? 0;
          dailyActivity = List<int>.from(data['dailyActivity'] ?? List<int>.filled(7, 0));
        } else {
          // User exists in Auth but not in Firestore - check if admin email
          isLoggedIn = true;
          if (AdminService.isMasterAdminEmail(user.email ?? '')) {
            role = 'admin';
            isPremium = true;
            displayName = user.email == 'shreyashkerkar@gmail.com' 
                ? 'Student Admin' 
                : 'Professor Admin';
            // Create Firestore document
            await _db.collection('users').doc(user.uid).set({
              'email': user.email?.toLowerCase(),
              'role': 'admin',
              'name': displayName,
              'premium': true,
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            });
          } else {
            role = 'user';
            displayName = user.displayName ?? "User";
          }
        }
      } catch (e) {
        print("Initialize error: $e");
      }
    }
    isReady = true;
    notifyListeners();
  }

  // ---------------- FAVORITES ----------------
  final Set<String> _favorites = {};

  bool isFavorite(String text) => _favorites.contains(text);

  void addFavorite(String text) {
    _favorites.add(text);
    notifyListeners();
  }

  void removeFavorite(String text) {
    _favorites.remove(text);
    notifyListeners();
  }

  void setTargetLanguage(String code) {
    targetLanguageCode = code;
    notifyListeners();
    
    // Save to Firestore if user is logged in
    if (isLoggedIn) {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        _db.collection('users').doc(uid).update({
          'targetLanguageCode': code,
          'updatedAt': FieldValue.serverTimestamp(),
        }).catchError((e) {
          print("Error saving target language: $e");
        });
      }
    }
  }

  void setDifficulty(String diff) {
    difficulty = diff;
    notifyListeners();
  }

  // ---------------- FIREBASE AUTH ----------------
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------------- LOGIN ----------------
  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = _auth.currentUser!.uid;
      final snap = await _db.collection('users').doc(uid).get();

      if (snap.exists) {
        final data = snap.data()!;

        isLoggedIn = true;
        displayName = data['name'] ?? "User";
        isPremium = data['premium'] ?? false;
        
        // Check role from Firestore, or check if email is admin
        role = data['role'];
        if (role == null || role == 'user') {
          // Check if email is a master admin
          final userEmail = _auth.currentUser?.email ?? '';
          if (AdminService.isMasterAdminEmail(userEmail)) {
            role = 'admin';
            isPremium = true;
            // Update Firestore to set role as admin
            await _db.collection('users').doc(uid).update({
              'role': 'admin',
              'premium': true,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          } else {
            role = 'user';
          }
        }
        
        targetLanguageCode = data['targetLanguageCode'] ?? targetLanguageCode;

        streak = data['streak'] ?? 0;
        totalQuestions = data['totalQuestions'] ?? 0;
        totalChallenges = data['totalChallenges'] ?? 0;

        dailyActivity =
        List<int>.from(data['dailyActivity'] ?? List<int>.filled(7, 0));

        notifyListeners();
      }

      return true;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  // ---------------- ADMIN LOGIN ----------------
  Future<Map<String, dynamic>> adminLogin(String email, String password) async {
    final result = await AdminService.adminLogin(email, password);
    if (result['success'] == true) {
      isLoggedIn = true;
      role = 'admin';
      final user = _auth.currentUser;
      if (user != null) {
        final snap = await _db.collection('users').doc(user.uid).get();
        if (snap.exists) {
          final data = snap.data()!;
          displayName = data['name'] ?? "Admin";
          isPremium = data['premium'] ?? true;
          role = data['role'] ?? 'admin';
        }
      }
      notifyListeners();
    }
    return result;
  }

  // ---------------- SIGNUP ----------------
  Future<bool> signup(String name, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = _auth.currentUser!.uid;
      final now = FieldValue.serverTimestamp();

      await _db.collection('users').doc(uid).set({
        'email': email.toLowerCase(),
        'name': name,
        'role': 'user',
        'premium': false,
        'streak': 0,
        'totalQuestions': 0,
        'totalChallenges': 0,
        'dailyActivity': List<int>.filled(7, 0),
        'createdAt': now,
        'updatedAt': now,
      });

      isLoggedIn = true;
      isPremium = false;
      role = 'user';
      displayName = name;
      streak = 0;
      totalQuestions = 0;
      totalChallenges = 0;
      dailyActivity = List<int>.filled(7, 0);

      notifyListeners();
      return true;
    } catch (e) {
      print("Signup error: $e");
      return false;
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await _auth.signOut();
    isLoggedIn = false;
    isPremium = false;
    role = null;
    displayName = null;
    streak = 0;
    totalQuestions = 0;
    totalChallenges = 0;
    dailyActivity = List<int>.filled(7, 0);
    notifyListeners();
  }

  // ---------------- UPDATE NAME ----------------
  Future<void> updateProfileName(String name) async {
    displayName = name;
    notifyListeners();

    if (isLoggedIn) {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await _db.collection('users').doc(uid).update({
          'name': name,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // ---------------- PREMIUM UNLOCK ----------------
  Future<void> upgradeToPremium() async {
    isPremium = true;
    notifyListeners();

    if (isLoggedIn) {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await _db.collection('users').doc(uid).update({
          'premium': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // ---------------- PROGRESS ----------------
  int streak = 0;
  int totalQuestions = 0;
  int totalChallenges = 0;

  List<int> dailyActivity = List<int>.filled(7, 0);
  DateTime? _lastActiveDay;

  void _shiftActivity() {
    dailyActivity.removeAt(0);
    dailyActivity.add(0);
  }

  void _registerActivity() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastActiveDay == null) {
      streak = 1;
      _lastActiveDay = today;
      dailyActivity[6] += 1;
      return;
    }

    final diff = today.difference(_lastActiveDay!).inDays;

    if (diff == 0) {
      dailyActivity[6] += 1;
    } else if (diff == 1) {
      streak += 1;
      _shiftActivity();
      _lastActiveDay = today;
      dailyActivity[6] += 1;
    } else if (diff > 1) {
      streak = 1;
      dailyActivity = List<int>.filled(7, 0);
      _lastActiveDay = today;
      dailyActivity[6] = 1;
    }
  }

  void recordQuestionSolved() {
    totalQuestions++;
    _registerActivity();
    notifyListeners();
    _pushProgressToFirestore();
  }

  void recordDailyChallenge() {
    totalChallenges++;
    _registerActivity();
    notifyListeners();
    _pushProgressToFirestore();
  }

  Future<void> _pushProgressToFirestore() async {
    if (!isLoggedIn) return;
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).update({
      'streak': streak,
      'totalQuestions': totalQuestions,
      'totalChallenges': totalChallenges,
      'dailyActivity': dailyActivity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
