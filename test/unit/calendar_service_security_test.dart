import 'package:flutter_test/flutter_test.dart';
import 'package:conference_agenda_tracker/services/calendar_service.dart';
import 'dart:io';

void main() {
  group('Calendar Service Security Tests', () {
    late CalendarService service;

    setUp(() {
      service = CalendarService();
    });

    group('URL Security', () {
      test('blocks localhost URLs', () async {
        expect(
          () async => await service
              .parseCalendarFromUrl('https://localhost/calendar.ics'),
          throwsA(predicate((e) => e.toString().contains('private IP'))),
        );
      });

      test('blocks 127.0.0.1 URLs', () async {
        expect(
          () async => await service
              .parseCalendarFromUrl('https://127.0.0.1/calendar.ics'),
          throwsA(predicate((e) => e.toString().contains('private IP'))),
        );
      });

      test('blocks private IP 10.x.x.x', () async {
        expect(
          () async => await service
              .parseCalendarFromUrl('https://10.0.0.1/calendar.ics'),
          throwsA(predicate((e) => e.toString().contains('private IP'))),
        );
      });

      test('blocks private IP 192.168.x.x', () async {
        expect(
          () async => await service
              .parseCalendarFromUrl('https://192.168.1.1/calendar.ics'),
          throwsA(predicate((e) => e.toString().contains('private IP'))),
        );
      });

      test('blocks private IP 172.16-31.x.x', () async {
        expect(
          () async => await service
              .parseCalendarFromUrl('https://172.16.0.1/calendar.ics'),
          throwsA(predicate((e) => e.toString().contains('private IP'))),
        );
      });

      test('blocks IPv6 localhost ::1', () async {
        expect(
          () async =>
              await service.parseCalendarFromUrl('https://[::1]/calendar.ics'),
          throwsA(predicate((e) => e.toString().contains('private IP'))),
        );
      });

      test('blocks HTTP URLs', () async {
        expect(
          () async => await service
              .parseCalendarFromUrl('http://example.com/calendar.ics'),
          throwsA(predicate((e) => e.toString().contains('HTTPS'))),
        );
      });
    });

    group('Content Validation', () {
      test('rejects content without BEGIN:VCALENDAR', () async {
        final tempDir = Directory.systemTemp.createTempSync();
        final invalidFile = File('${tempDir.path}/invalid.ics');
        await invalidFile.writeAsString('INVALID CONTENT');

        expect(
          () async => await service.parseCalendarFromFile(invalidFile),
          throwsA(predicate((e) => e.toString().contains('BEGIN:VCALENDAR'))),
        );

        await invalidFile.delete();
        await tempDir.delete();
      });

      test('caps title length to 500 characters', () async {
        final tempDir = Directory.systemTemp.createTempSync();
        final longTitleFile = File('${tempDir.path}/longtitle.ics');
        final longTitle = 'A' * 600; // 600 characters

        await longTitleFile.writeAsString('''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Test//Test//EN
BEGIN:VEVENT
UID:test@example.com
SUMMARY:$longTitle
DTSTART:20250101T100000Z
DTEND:20250101T110000Z
END:VEVENT
END:VCALENDAR
''');

        final events = await service.parseCalendarFromFile(longTitleFile);
        expect(events, isNotEmpty);
        expect(events.first.title.length, equals(500));

        await longTitleFile.delete();
        await tempDir.delete();
      });

      test('caps description length to 10000 characters', () async {
        final tempDir = Directory.systemTemp.createTempSync();
        final longDescFile = File('${tempDir.path}/longdesc.ics');
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
        expect(events.first.description.length, equals(10000));

        await longDescFile.delete();
        await tempDir.delete();
      });

      test('limits to 1000 events maximum', () async {
        final tempDir = Directory.systemTemp.createTempSync();
        final largeFile = File('${tempDir.path}/large.ics');

        // Create ICS with 1500 events
        final buffer = StringBuffer();
        buffer.writeln('BEGIN:VCALENDAR');
        buffer.writeln('VERSION:2.0');
        buffer.writeln('PRODID:-//Test//Test//EN');

        for (int i = 0; i < 1500; i++) {
          buffer.writeln('BEGIN:VEVENT');
          buffer.writeln('UID:event-$i@example.com');
          buffer.writeln('SUMMARY:Event $i');
          buffer.writeln('DTSTART:20250101T100000Z');
          buffer.writeln('DTEND:20250101T110000Z');
          buffer.writeln('END:VEVENT');
        }

        buffer.writeln('END:VCALENDAR');
        await largeFile.writeAsString(buffer.toString());

        final events = await service.parseCalendarFromFile(largeFile);
        expect(events.length, equals(1000));

        await largeFile.delete();
        await tempDir.delete();
      });
    });
  });
}
