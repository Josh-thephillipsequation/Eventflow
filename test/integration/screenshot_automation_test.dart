import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:conference_agenda_tracker/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Screenshot Automation', () {
    testWidgets('Take screenshots for App Store', (WidgetTester tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for splash screen to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Skip onboarding if present (tap through or find skip button)
      await tester.pumpAndSettle(const Duration(seconds: 1));
      
      // Try to find and tap skip/next buttons
      final skipButton = find.text('Skip');
      final nextButton = find.text('Next');
      if (skipButton.evaluate().isNotEmpty) {
        await tester.tap(skipButton);
        await tester.pumpAndSettle();
      } else if (nextButton.evaluate().isNotEmpty) {
        // Tap through onboarding
        for (int i = 0; i < 5; i++) {
          if (nextButton.evaluate().isNotEmpty) {
            await tester.tap(nextButton);
            await tester.pumpAndSettle();
          }
        }
      }

      // Wait for home screen
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Load sample data via Settings
      // First, try to find settings icon in app bar
      final settingsIcon = find.byIcon(Icons.settings);
      if (settingsIcon.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        // Find and tap "Import Sample Conference" button
        final importSampleButton = find.text('Import Sample Conference');
        if (importSampleButton.evaluate().isNotEmpty) {
          await tester.tap(importSampleButton);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }
        
        // Go back to home
        final backButton = find.byIcon(Icons.arrow_back);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pumpAndSettle();
        }
      }

      // Screenshot 1: Import Screen (default tab - index 0)
      await tester.pumpAndSettle(const Duration(seconds: 1));
      // Screenshots are automatically saved when using --screenshot-dir flag
      // The test framework will capture screenshots at each step
      
      // Navigate to All Events tab (index 1)
      final allEventsTab = find.text('All Events');
      if (allEventsTab.evaluate().isNotEmpty) {
        await tester.tap(allEventsTab);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Navigate to My Agenda tab (index 2)
      final myAgendaTab = find.text('My Agenda');
      if (myAgendaTab.evaluate().isNotEmpty) {
        await tester.tap(myAgendaTab);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Navigate to Insights tab (index 3)
      final insightsTab = find.text('Insights');
      if (insightsTab.evaluate().isNotEmpty) {
        await tester.tap(insightsTab);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Navigate to Fun tab (index 4)
      final funTab = find.text('Fun');
      if (funTab.evaluate().isNotEmpty) {
        await tester.tap(funTab);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Open Settings again for settings screenshot
      final settingsIcon2 = find.byIcon(Icons.settings);
      if (settingsIcon2.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon2);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
      
      // Note: Screenshots are captured automatically when running with:
      // flutter test integration_test/screenshot_automation_test.dart --screenshot-dir screenshots/
    });
  });
}

