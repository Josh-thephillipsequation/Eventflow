import 'package:flutter_test/flutter_test.dart';
import 'package:conference_agenda_tracker/models/calendar_event.dart';

void main() {
  group('CalendarEvent Model Tests', () {
    late CalendarEvent testEvent;
    
    setUp(() {
      testEvent = CalendarEvent(
        uid: 'test-uid-123',
        title: 'Test Event',
        description: 'Test Description',
        startTime: DateTime(2025, 1, 15, 14, 0),
        endTime: DateTime(2025, 1, 15, 15, 30),
        location: 'Test Location',
        speaker: 'John Doe',
        priority: 2,
      );
    });

    test('should create event with correct properties', () {
      expect(testEvent.uid, equals('test-uid-123'));
      expect(testEvent.title, equals('Test Event'));
      expect(testEvent.description, equals('Test Description'));
      expect(testEvent.startTime, equals(DateTime(2025, 1, 15, 14, 0)));
      expect(testEvent.endTime, equals(DateTime(2025, 1, 15, 15, 30)));
      expect(testEvent.location, equals('Test Location'));
      expect(testEvent.speaker, equals('John Doe'));
      expect(testEvent.priority, equals(2));
      expect(testEvent.isSelected, isFalse);
    });

    test('should have default values', () {
      final defaultEvent = CalendarEvent(
        uid: 'default',
        title: 'Default Event',
        description: '',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        location: '',
      );
      
      expect(defaultEvent.speaker, equals(''));
      expect(defaultEvent.isSelected, isFalse);
      expect(defaultEvent.priority, equals(3));
    });

    test('should serialize to JSON correctly', () {
      final json = testEvent.toJson();
      
      expect(json['uid'], equals('test-uid-123'));
      expect(json['title'], equals('Test Event'));
      expect(json['speaker'], equals('John Doe'));
      expect(json['priority'], equals(2));
      expect(json['isSelected'], isFalse);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'uid': 'json-uid',
        'title': 'JSON Event',
        'description': 'JSON Description',
        'startTime': '2025-01-15T14:00:00.000',
        'endTime': '2025-01-15T15:30:00.000',
        'location': 'JSON Location',
        'speaker': 'Jane Doe',
        'isSelected': true,
        'priority': 1,
      };
      
      final event = CalendarEvent.fromJson(json);
      
      expect(event.uid, equals('json-uid'));
      expect(event.title, equals('JSON Event'));
      expect(event.speaker, equals('Jane Doe'));
      expect(event.isSelected, isTrue);
      expect(event.priority, equals(1));
    });

    test('should handle copyWith correctly', () {
      final updated = testEvent.copyWith(
        title: 'Updated Title',
        priority: 1,
        isSelected: true,
      );
      
      expect(updated.title, equals('Updated Title'));
      expect(updated.priority, equals(1));
      expect(updated.isSelected, isTrue);
      // Unchanged properties
      expect(updated.uid, equals('test-uid-123'));
      expect(updated.speaker, equals('John Doe'));
    });

    test('should handle missing JSON fields gracefully', () {
      final minimalJson = {
        'uid': 'minimal',
        'title': 'Minimal Event',
        'description': '',
        'startTime': '2025-01-15T14:00:00.000',
        'endTime': '2025-01-15T15:00:00.000',
        'location': '',
      };
      
      final event = CalendarEvent.fromJson(minimalJson);
      
      expect(event.speaker, equals(''));
      expect(event.isSelected, isFalse);
      expect(event.priority, equals(3));
    });
  });
}
