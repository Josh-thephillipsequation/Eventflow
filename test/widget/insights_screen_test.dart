import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:conference_agenda_tracker/screens/insights_screen.dart';
import 'package:conference_agenda_tracker/providers/event_provider.dart';
import 'package:conference_agenda_tracker/models/calendar_event.dart';

void main() {
  group('InsightsScreen Widget Tests', () {
    late EventProvider eventProvider;
    late List<CalendarEvent> testEvents;
    
    setUp(() {
      eventProvider = EventProvider();
      testEvents = [
        CalendarEvent(
          uid: 'event-1',
          title: 'AI Conference Session',
          description: 'Learn about artificial intelligence',
          startTime: DateTime(2025, 1, 15, 9, 0),
          endTime: DateTime(2025, 1, 15, 10, 0),
          location: 'Hall A',
          speaker: 'Dr. AI',
        ),
        CalendarEvent(
          uid: 'event-2',
          title: 'Machine Learning Workshop',
          description: 'Hands-on ML training',
          startTime: DateTime(2025, 1, 15, 14, 0),
          endTime: DateTime(2025, 1, 15, 16, 0),
          location: 'Lab B',
          speaker: 'Prof. ML',
        ),
      ];
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => eventProvider,
          child: const Scaffold(
            body: InsightsScreen(),
          ),
        ),
      );
    }

    testWidgets('should show no data message when no events', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('No data to analyze'), findsOneWidget);
      expect(find.text('Import a calendar to see event insights'), findsOneWidget);
      expect(find.byIcon(Icons.insights), findsOneWidget);
    });

    testWidgets('should display overview stats when events exist', (WidgetTester tester) async {
      eventProvider.addEventsForTesting(testEvents);
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Total Events'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // 2 events
    });

    testWidgets('should show time filter dropdown', (WidgetTester tester) async {
      eventProvider.addEventsForTesting(testEvents);
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('Analyze:'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('should display topic cloud when events have titles', (WidgetTester tester) async {
      eventProvider.addEventsForTesting(testEvents);
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('Topic Cloud'), findsOneWidget);
      // Should show common words from titles
      expect(find.textContaining('ai'), findsAny);
      expect(find.textContaining('machine'), findsAny);
    });

    testWidgets('should show time patterns section', (WidgetTester tester) async {
      eventProvider.addEventsForTesting(testEvents);
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('Time Patterns'), findsOneWidget);
      expect(find.text('Daily Schedule Heatmap'), findsOneWidget);
    });

    testWidgets('should display priority distribution', (WidgetTester tester) async {
      eventProvider.addEventsForTesting(testEvents);
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('Priority Distribution'), findsOneWidget);
      expect(find.text('High Priority'), findsOneWidget);
      expect(find.text('Medium Priority'), findsOneWidget);
      expect(find.text('Low Priority'), findsOneWidget);
    });

    testWidgets('should handle filter changes', (WidgetTester tester) async {
      eventProvider.addEventsForTesting(testEvents);
      await tester.pumpWidget(createTestWidget());
      
      // Tap dropdown to open it
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      
      // Should show filter options
      expect(find.text('All Events'), findsWidgets);
      expect(find.text('Upcoming Events'), findsOneWidget);
      expect(find.text('Past Events'), findsOneWidget);
    });

    testWidgets('should show interactive topic bubbles', (WidgetTester tester) async {
      eventProvider.addEventsForTesting(testEvents);
      await tester.pumpWidget(createTestWidget());
      
      // Topic bubbles should be tappable
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('should display schedule heatmap', (WidgetTester tester) async {
      eventProvider.addEventsForTesting(testEvents);
      await tester.pumpWidget(createTestWidget());
      
      // Should show 24-hour heatmap
      expect(find.text('Daily Schedule Heatmap'), findsOneWidget);
      expect(find.text('Tap any hour to see events • Darker = More Events'), findsOneWidget);
    });

    testWidgets('should handle empty states gracefully', (WidgetTester tester) async {
      // Test with events that have no descriptions
      final emptyEvent = CalendarEvent(
        uid: 'empty',
        title: 'Empty Event',
        description: '',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        location: '',
      );
      
      eventProvider.addEventsForTesting([emptyEvent]);
      await tester.pumpWidget(createTestWidget());
      
      // Should still render without errors
      expect(find.text('Overview'), findsOneWidget);
    });
  });
}
