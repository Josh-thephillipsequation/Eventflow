import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conference_agenda_tracker/widgets/event_card.dart';
import 'package:conference_agenda_tracker/models/calendar_event.dart';

void main() {
  group('EventCard Widget Tests', () {
    late CalendarEvent testEvent;

    setUp(() {
      testEvent = CalendarEvent(
        uid: 'test-1',
        title: 'Flutter Conference',
        description: 'A great conference about Flutter development',
        startTime: DateTime(2025, 1, 15, 14, 0),
        endTime: DateTime(2025, 1, 15, 15, 30),
        location: 'Conference Center',
        speaker: 'John Flutter',
        priority: 2,
      );
    });

    Widget createTestWidget(CalendarEvent event) {
      return MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: event,
            onSelectionChanged: () {},
            onPriorityChanged: (priority) {},
          ),
        ),
      );
    }

    testWidgets('should display event title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testEvent));

      expect(find.text('Flutter Conference'), findsOneWidget);
    });

    testWidgets('should display event time in AM/PM format',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testEvent));

      // Should show time in 12-hour format
      expect(find.textContaining('2:00 PM'), findsOneWidget);
      expect(find.textContaining('3:30 PM'), findsOneWidget);
    });

    testWidgets('should display speaker when available',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testEvent));

      expect(find.text('John Flutter'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should display location when available',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testEvent));

      expect(find.text('Conference Center'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('should show checkbox for selection',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testEvent));

      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('should show priority controls when selected',
        (WidgetTester tester) async {
      testEvent.isSelected = true;
      await tester.pumpWidget(createTestWidget(testEvent));

      // Should show priority chips
      expect(find.byType(ChoiceChip), findsWidgets);
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      bool selectionChanged = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: testEvent,
            onSelectionChanged: () => selectionChanged = true,
            onPriorityChanged: (priority) {},
          ),
        ),
      ));

      await tester.tap(find.byType(Card));
      expect(selectionChanged, isTrue);
    });

    testWidgets('should show "more" button for long descriptions',
        (WidgetTester tester) async {
      final longEvent = testEvent.copyWith(
        description:
            'This is a very long description that should trigger the more button to appear because it exceeds the character limit we set for showing the more button functionality.',
      );

      await tester.pumpWidget(createTestWidget(longEvent));

      expect(find.text('more'), findsOneWidget);
    });

    testWidgets('should not show date when showDate is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: testEvent,
            showDate: false,
            onSelectionChanged: () {},
            onPriorityChanged: (priority) {},
          ),
        ),
      ));

      expect(find.byIcon(Icons.calendar_today), findsNothing);
    });

    testWidgets('should handle empty speaker gracefully',
        (WidgetTester tester) async {
      final noSpeakerEvent = testEvent.copyWith(speaker: '');
      await tester.pumpWidget(createTestWidget(noSpeakerEvent));

      // Should not show person icon when no speaker
      expect(find.byIcon(Icons.person), findsNothing);
    });

    testWidgets('should handle empty location gracefully',
        (WidgetTester tester) async {
      final noLocationEvent = testEvent.copyWith(location: '');
      await tester.pumpWidget(createTestWidget(noLocationEvent));

      // Should not show location icon when no location
      expect(find.byIcon(Icons.location_on), findsNothing);
    });
  });
}
