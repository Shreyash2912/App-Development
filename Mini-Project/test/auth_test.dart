import 'package:flutter_test/flutter_test.dart';
import 'package:lingo/providers/app_state.dart';

/// Fake AppState that does NOT touch Firebase.
/// We override login(), signup() and logout() for testing.
class FakeAppState extends AppState {
  @override
  Future<bool> login(String email, String password) async {
    // Fake login success if password matches
    if (password == "test123") {
      isLoggedIn = true;
      displayName = "Test User";
      isPremium = false;
      role = "user";
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  Future<bool> signup(String name, String email, String password) async {
    // Always succeed
    isLoggedIn = true;
    displayName = name;
    isPremium = false;
    role = "user";
    notifyListeners();
    return true;
  }

  @override
  Future<void> logout() async {
    isLoggedIn = false;
    isPremium = false;
    displayName = null;
    role = null;
    notifyListeners();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("Auth Tests", () {
    test("Signup creates user with correct default values", () async {
      final app = FakeAppState();

      final result = await app.signup("John", "john@gmail.com", "abc123");

      expect(result, true);
      expect(app.isLoggedIn, true);
      expect(app.displayName, "John");
      expect(app.isPremium, false); // Default free user
      expect(app.role, "user");
    });

    test("Login works with correct password", () async {
      final app = FakeAppState();

      final result = await app.login("john@gmail.com", "test123");

      expect(result, true);
      expect(app.isLoggedIn, true);
      expect(app.displayName, "Test User");
    });

    test("Login fails with wrong password", () async {
      final app = FakeAppState();

      final result = await app.login("john@gmail.com", "wrongpass");

      expect(result, false);
      expect(app.isLoggedIn, false);
    });

    test("Logout resets all values", () async {
      final app = FakeAppState();

      // First login to set values
      await app.login("john@gmail.com", "test123");

      // Now logout
      await app.logout();

      expect(app.isLoggedIn, false);
      expect(app.isPremium, false);
      expect(app.displayName, null);
      expect(app.role, null);
    });
  });
}
