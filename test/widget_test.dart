import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conference_agenda_tracker/main.dart';

void main() {
  group('EventFlow App Tests', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Mock SharedPreferences
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, Object>{};
        }
        if (methodCall.method == 'setString') {
          return true;
        }
        return null;
      });
    });

    testWidgets('app starts with splash screen', (WidgetTester tester) async {
      await tester.pumpWidget(const ConferenceAgendaApp());
      
      // Should show splash screen initially
      expect(find.text('EventFlow'), findsOneWidget);
      expect(find.text('by thephillipsequation llc'), findsOneWidget);
    });

    testWidgets('app transitions to home screen', (WidgetTester tester) async {
      await tester.pumpWidget(const ConferenceAgendaApp());
      
      // Wait for splash screen to complete (1 second + extra time)
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(milliseconds: 500)); // Extra time for transition
      
      // Should show home screen with navigation
      expect(find.text('EventFlow'), findsOneWidget); // App bar title
      expect(find.text('Import'), findsOneWidget);
      expect(find.text('All Events'), findsOneWidget);
      expect(find.text('My Agenda'), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget);
      expect(find.text('Fun'), findsOneWidget);
    });

    testWidgets('navigation tabs work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const ConferenceAgendaApp());
      await tester.pump(const Duration(seconds: 2));
      
      // Test tab navigation
      await tester.tap(find.text('All Events'));
      await tester.pumpAndSettle();
      
      // Should show events list (empty state)
      expect(find.text('No events loaded'), findsOneWidget);
      
      await tester.tap(find.text('My Agenda'));
      await tester.pumpAndSettle();
      
      // Should show agenda (empty state)
      expect(find.text('No events selected'), findsOneWidget);
    });

    testWidgets('fun tab loads correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const ConferenceAgendaApp());
      await tester.pump(const Duration(seconds: 2));
      
      await tester.tap(find.text('Fun'));
      await tester.pumpAndSettle();
      
      // Should show fun zone
      expect(find.text('Fun Zone'), findsOneWidget);
      expect(find.text('Talk Generator'), findsOneWidget);
      expect(find.text('Product Ideas'), findsOneWidget);
      expect(find.text('Conference Bingo'), findsOneWidget);
    });

    testWidgets('insights tab loads correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const ConferenceAgendaApp());
      await tester.pump(const Duration(seconds: 2));
      
      await tester.tap(find.text('Insights'));
      await tester.pumpAndSettle();
      
      // Should show insights (empty state)
      expect(find.text('No data to analyze'), findsOneWidget);
    });

    testWidgets('app shows clear all button when events exist', (WidgetTester tester) async {
      await tester.pumpWidget(const ConferenceAgendaApp());
      await tester.pump(const Duration(seconds: 2));
      
      // Initially no clear button
      expect(find.byIcon(Icons.clear_all), findsNothing);
      
      // Would need to add events to test clear button appearance
      // This requires Provider setup and event addition
    });
  });
}
