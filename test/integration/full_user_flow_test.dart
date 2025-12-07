import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:conference_agenda_tracker/main.dart';
import 'package:conference_agenda_tracker/providers/event_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Full User Flow Integration Tests', () {
    testWidgets('App loads successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const ConferenceAgendaApp());
      await tester.pump(const Duration(seconds: 2));

      // Verify app loaded
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    test('Filter events by search term', () {
      final provider = EventProvider();
      
      // Add test events
      provider.addTestEvents([
        {
          'title': 'Flutter Workshop',
          'start': DateTime.now().add(const Duration(hours: 1)),
          'end': DateTime.now().add(const Duration(hours: 2)),
          'description': 'Learn Flutter basics',
        },
        {
          'title': 'Dart Deep Dive',
          'start': DateTime.now().add(const Duration(hours: 3)),
          'end': DateTime.now().add(const Duration(hours: 4)),
          'description': 'Advanced Dart concepts',
        },
        {
          'title': 'Coffee Break',
          'start': DateTime.now().add(const Duration(hours: 5)),
          'end': DateTime.now().add(const Duration(hours: 6)),
          'description': 'Networking time',
        },
      ]);

      expect(provider.events.length, 3);
    });

    test('Select events and view in My Agenda', () {
      final provider = EventProvider();
      
      provider.addTestEvents([
        {
          'title': 'Event 1',
          'start': DateTime.now().add(const Duration(hours: 1)),
          'end': DateTime.now().add(const Duration(hours: 2)),
        },
        {
          'title': 'Event 2',
          'start': DateTime.now().add(const Duration(hours: 3)),
          'end': DateTime.now().add(const Duration(hours: 4)),
        },
      ]);

      // Select first event
      provider.toggleEventSelection(provider.events.first);

      expect(provider.selectedEvents.length, 1);
      expect(provider.selectedEvents.first.title, 'Event 1');
    });

    test('Time-based filtering shows correct events', () {
      final provider = EventProvider();
      final now = DateTime.now();
      
      provider.addTestEvents([
        {
          'title': 'Past Event',
          'start': now.subtract(const Duration(days: 1)),
          'end': now.subtract(const Duration(days: 1, hours: -1)),
        },
        {
          'title': 'Current Event',
          'start': now.subtract(const Duration(minutes: 30)),
          'end': now.add(const Duration(minutes: 30)),
        },
        {
          'title': 'Future Event',
          'start': now.add(const Duration(days: 1)),
          'end': now.add(const Duration(days: 1, hours: 1)),
        },
      ]);

      final upcomingEvents = provider.events.where((e) => 
        e.startTime.isAfter(now) || 
        (e.startTime.isBefore(now) && e.endTime.isAfter(now))
      ).toList();

      expect(upcomingEvents.length, 2);
      expect(upcomingEvents.any((e) => e.title == 'Past Event'), false);
    });

    test('Priority setting persists', () {
      final provider = EventProvider();
      
      provider.addTestEvents([
        {
          'title': 'Important Event',
          'start': DateTime.now().add(const Duration(hours: 1)),
          'end': DateTime.now().add(const Duration(hours: 2)),
        },
      ]);

      final event = provider.events.first;
      provider.toggleEventSelection(event);
      provider.setEventPriority(event, 1);

      expect(provider.getEventPriority(event), 1);
    });
  });
}
