import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/app_state.dart';
import 'screens/onboarding/language_select_screen.dart';
import 'screens/shell/root_nav.dart';
import 'screens/premium/premium_screen.dart';
import 'screens/auth/login_signup_screen.dart';
import 'screens/admin/admin_panel_screen.dart';
import 'theme/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Lingo',

            theme: ThemeData(
              colorScheme: customColorScheme,
              useMaterial3: true,
              fontFamily: 'Ubuntu',
            ),

            routes: {
              LanguageSelectScreen.routeName: (_) =>
              const LanguageSelectScreen(),
              '/premium': (_) => const PremiumScreen(),
              RootNav.routeName: (_) => const RootNav(),
            },

            home: _buildStart(appState),
          );
        },
      ),
    );
  }

  Widget _buildStart(AppState app) {
    if (!app.isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // If logged in, check if admin
    if (app.isLoggedIn) {
      // Admin users go directly to admin panel
      if (app.isAdmin) {
        return const AdminPanelScreen();
      }
      
      // Regular users - check language selection
      if (app.targetLanguageCode == null) {
        return const LanguageSelectScreen();
      }
      
      // Regular user with language selected - go to main app
      return const RootNav();
    }

    // Show login/signup/guest screen if not logged in
    // Guest users can still access the app
    return const LoginSignupScreen();
  }
}
