import 'package:flutter_test/flutter_test.dart';
import 'package:lingo/providers/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test("Signup creates Firestore doc with role:user & premium:false", () async {
    final app = AppState();

    final result = await app.signup(
      "Test User",
      "testuser@example.com",
      "123456",
    );

    expect(result, true);
    expect(app.isLoggedIn, true);
    expect(app.role, "user");
    expect(app.isPremium, false);
  });
}
