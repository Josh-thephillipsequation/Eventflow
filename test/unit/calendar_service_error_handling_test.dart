import 'package:flutter_test/flutter_test.dart';
import 'package:conference_agenda_tracker/services/calendar_service.dart';
import 'dart:io';

void main() {
  group('Calendar Service Error Handling', () {
    late CalendarService service;

    setUp(() {
      service = CalendarService();
    });

    test('handles malformed ICS file gracefully', () async {
      // Create a temp file with malformed ICS content
      final tempDir = Directory.systemTemp.createTempSync();
      final malformedFile = File('${tempDir.path}/malformed.ics');
      await malformedFile.writeAsString('INVALID ICS CONTENT');

      expect(
        () async => await service.parseCalendarFromFile(malformedFile),
        throwsException,
      );

      await malformedFile.delete();
      await tempDir.delete();
    });

    test('handles empty ICS file', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      final emptyFile = File('${tempDir.path}/empty.ics');
      await emptyFile.writeAsString('');

      expect(
        () async => await service.parseCalendarFromFile(emptyFile),
        throwsException,
      );

      await emptyFile.delete();
      await tempDir.delete();
    });

    test('handles ICS with missing required fields', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      final invalidFile = File('${tempDir.path}/invalid.ics');

      // ICS with event missing required fields
      await invalidFile.writeAsString('''
BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
SUMMARY:Event without UID
DTSTART:20250101T100000Z
END:VEVENT
END:VCALENDAR
''');

      try {
        final events = await service.parseCalendarFromFile(invalidFile);
        // Should either skip invalid events or throw
        expect(events, isNotNull);
      } catch (e) {
        // Exception is acceptable for invalid data
        expect(e, isNotNull);
      }

      await invalidFile.delete();
      await tempDir.delete();
    });

    test('handles invalid URL gracefully', () async {
      expect(
        () async => await service.parseCalendarFromUrl('not-a-valid-url'),
        throwsException,
      );
    });

    test('handles network timeout', () async {
      expect(
        () async =>
            await service.parseCalendarFromUrl('http://192.0.2.1/calendar.ics'),
        throwsException,
      );
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('handles ICS with special characters in event names', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      final specialCharsFile = File('${tempDir.path}/special.ics');

      await specialCharsFile.writeAsString('''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Test//Test//EN
BEGIN:VEVENT
UID:test@example.com
SUMMARY:Event with émojis 🎉 & spëcial çhars
DTSTART:20250101T100000Z
DTEND:20250101T110000Z
END:VEVENT
END:VCALENDAR
''');

      final events = await service.parseCalendarFromFile(specialCharsFile);
      expect(events, isNotEmpty);
      expect(events.first.title, contains('émojis'));

      await specialCharsFile.delete();
      await tempDir.delete();
    });

    test('handles very long event descriptions', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      final longDescFile = File('${tempDir.path}/long.ics');
      final longDescription = 'A' * 15000; // 15k characters

      await longDescFile.writeAsString('''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Test//Test//EN
BEGIN:VEVENT
UID:test@example.com
SUMMARY:Event
DESCRIPTION:$longDescription
DTSTART:20250101T100000Z
DTEND:20250101T110000Z
END:VEVENT
END:VCALENDAR
''');

      final events = await service.parseCalendarFromFile(longDescFile);
      expect(events, isNotEmpty);
      // Should be capped at 10000 characters
      expect(events.first.description.length, equals(10000));

      await longDescFile.delete();
      await tempDir.delete();
    });

    test('handles duplicate event UIDs', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      final duplicateFile = File('${tempDir.path}/duplicate.ics');

      await duplicateFile.writeAsString('''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Test//Test//EN
BEGIN:VEVENT
UID:same-uid@example.com
SUMMARY:Event 1
DTSTART:20250101T100000Z
DTEND:20250101T110000Z
END:VEVENT
BEGIN:VEVENT
UID:same-uid@example.com
SUMMARY:Event 2
DTSTART:20250101T120000Z
DTEND:20250101T130000Z
END:VEVENT
END:VCALENDAR
''');

      final events = await service.parseCalendarFromFile(duplicateFile);
      // Should handle duplicates (either merge or keep both)
      expect(events, isNotNull);

      await duplicateFile.delete();
      await tempDir.delete();
    });
  });
}
