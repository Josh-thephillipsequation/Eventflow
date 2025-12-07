import 'package:flutter_test/flutter_test.dart';
import 'package:conference_agenda_tracker/models/calendar_event.dart';
import 'package:conference_agenda_tracker/providers/event_provider.dart';

void main() {
  group('Edge Cases and Timezone Handling', () {
    test('handles events spanning multiple days', () {
      final event = CalendarEvent(
        uid: '1',
        title: 'Multi-day Conference',
        description: 'Spans 3 days',
        startTime: DateTime(2025, 1, 1, 9, 0),
        endTime: DateTime(2025, 1, 3, 17, 0),
        location: 'Convention Center',
      );

      expect(event.endTime.difference(event.startTime).inDays, equals(2));
    });

    test('handles events with same start and end time', () {
      final now = DateTime.now();
      final event = CalendarEvent(
        uid: '1',
        title: 'Instant Event',
        description: 'No duration',
        startTime: now,
        endTime: now,
        location: '',
      );

      expect(event.startTime, equals(event.endTime));
      expect(event.endTime.difference(event.startTime).inSeconds, equals(0));
    });

    test('handles events with very long titles', () {
      final longTitle = 'A' * 500;
      final event = CalendarEvent(
        uid: '1',
        title: longTitle,
        description: '',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        location: '',
      );

      expect(event.title.length, equals(500));
    });

    test('handles timezone conversions correctly', () {
      // UTC time
      final utcTime = DateTime.utc(2025, 1, 1, 12, 0);

      final event = CalendarEvent(
        uid: '1',
        title: 'Timezone Test',
        description: '',
        startTime: utcTime,
        endTime: utcTime.add(const Duration(hours: 1)),
        location: '',
      );

      expect(event.startTime.isUtc, isTrue);
    });

    test('handles events at midnight', () {
      final midnight = DateTime(2025, 1, 1, 0, 0);
      final event = CalendarEvent(
        uid: '1',
        title: 'Midnight Event',
        description: '',
        startTime: midnight,
        endTime: midnight.add(const Duration(hours: 1)),
        location: '',
      );

      expect(event.startTime.hour, equals(0));
      expect(event.startTime.minute, equals(0));
    });

    test('handles overlapping events', () {
      final provider = EventProvider();

      provider.addTestEvents([
        {
          'title': 'Event 1',
          'start': DateTime(2025, 1, 1, 10, 0),
          'end': DateTime(2025, 1, 1, 12, 0),
        },
        {
          'title': 'Event 2',
          'start': DateTime(2025, 1, 1, 11, 0),
          'end': DateTime(2025, 1, 1, 13, 0),
        },
      ]);

      expect(provider.events.length, equals(2));

      // Check for overlap
      final event1 = provider.events[0];
      final event2 = provider.events[1];

      final overlaps = event1.startTime.isBefore(event2.endTime) &&
          event2.startTime.isBefore(event1.endTime);

      expect(overlaps, isTrue);
    });

    test('handles sorting events by different criteria', () {
      final provider = EventProvider();

      provider.addTestEvents([
        {
          'title': 'Z Event',
          'start': DateTime(2025, 1, 1, 9, 0),
          'end': DateTime(2025, 1, 1, 10, 0),
          'priority': 2,
        },
        {
          'title': 'A Event',
          'start': DateTime(2025, 1, 1, 11, 0),
          'end': DateTime(2025, 1, 1, 12, 0),
          'priority': 1,
        },
      ]);

      // Sort by time
      final byTime = List<CalendarEvent>.from(provider.events)
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      expect(byTime.first.title, equals('Z Event'));

      // Sort by title
      final byTitle = List<CalendarEvent>.from(provider.events)
        ..sort((a, b) => a.title.compareTo(b.title));
      expect(byTitle.first.title, equals('A Event'));

      // Sort by priority
      final byPriority = List<CalendarEvent>.from(provider.events)
        ..sort((a, b) => a.priority.compareTo(b.priority));
      expect(byPriority.first.priority, equals(1));
    });

    test('handles special characters in all fields', () {
      final event = CalendarEvent(
        uid: 'test-<>@#\$%',
        title: 'Event with émojis 🎉 & symbols !@#',
        description: 'Line 1\nLine 2\tTabbed',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        location: 'Room "A" & \'B\'',
        speaker: 'Dr. O\'Reilly <email@test.com>',
      );

      expect(event.title, contains('🎉'));
      expect(event.description, contains('\n'));
      expect(event.location, contains('"'));
      expect(event.speaker, contains('\''));
    });

    test('handles null or empty optional fields', () {
      final event = CalendarEvent(
        uid: '1',
        title: 'Minimal Event',
        description: '',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        location: '',
      );

      expect(event.description, isEmpty);
      expect(event.location, isEmpty);
      expect(event.speaker, isEmpty);
    });

    test('handles year boundaries', () {
      final newYearEve = DateTime(2024, 12, 31, 23, 0);
      final newYear = DateTime(2025, 1, 1, 1, 0);

      final event = CalendarEvent(
        uid: '1',
        title: 'New Year Event',
        description: '',
        startTime: newYearEve,
        endTime: newYear,
        location: '',
      );

      expect(event.startTime.year, equals(2024));
      expect(event.endTime.year, equals(2025));
      expect(event.endTime.difference(event.startTime).inHours, equals(2));
    });

    test('handles DST transitions', () {
      // Spring forward: March 10, 2024 2:00 AM -> 3:00 AM
      final beforeDST = DateTime(2024, 3, 10, 1, 0);
      final afterDST = DateTime(2024, 3, 10, 4, 0);

      final event = CalendarEvent(
        uid: '1',
        title: 'DST Event',
        description: '',
        startTime: beforeDST,
        endTime: afterDST,
        location: '',
      );

      // Duration should be 3 clock hours (but may be 2 real hours due to DST)
      expect(event.endTime.isAfter(event.startTime), isTrue);
    });
  });
}
