import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:lingo/providers/app_state.dart';
import 'package:lingo/screens/practice/question_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("VIP upsell is hidden for premium users",
          (WidgetTester tester) async {
        final app = AppState();
        app.isLoggedIn = true;
        app.isPremium = true;

        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: app,
            child: const MaterialApp(home: QuestionScreen()),
          ),
        );

        expect(find.text("Upgrade"), findsNothing);
      });
}
