import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lingo/providers/app_state.dart';
import 'package:lingo/screens/account/account_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("Admin Panel is hidden for non-admin users",
          (WidgetTester tester) async {
        final app = AppState();
        app.isLoggedIn = true;
        app.role = "user"; // not admin

        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: app,
            child: const MaterialApp(home: AccountScreen()),
          ),
        );

        expect(find.text("Admin Panel"), findsNothing);
      });
}
