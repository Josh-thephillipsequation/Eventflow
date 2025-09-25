import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:conference_agenda_tracker/providers/event_provider.dart';
import 'package:conference_agenda_tracker/models/calendar_event.dart';

void main() {
  group('EventProvider Tests', () {
    late EventProvider eventProvider;
    late CalendarEvent testEvent1;
    late CalendarEvent testEvent2;
    
    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Mock SharedPreferences to return empty data
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, Object>{}; // Return empty preferences
        }
        if (methodCall.method == 'setString') {
          return true;
        }
        return null;
      });
      
      eventProvider = EventProvider();
      
      // Wait for storage loading to complete
      await Future.delayed(const Duration(milliseconds: 100));
      testEvent1 = CalendarEvent(
        uid: 'event-1',
        title: 'First Event',
        description: 'Description 1',
        startTime: DateTime(2025, 1, 15, 14, 0),
        endTime: DateTime(2025, 1, 15, 15, 0),
        location: 'Location 1',
        priority: 1,
      );
      testEvent2 = CalendarEvent(
        uid: 'event-2', 
        title: 'Second Event',
        description: 'Description 2',
        startTime: DateTime(2025, 1, 16, 10, 0),
        endTime: DateTime(2025, 1, 16, 11, 0),
        location: 'Location 2',
        priority: 3,
      );
    });

    test('should start with empty events list', () {
      expect(eventProvider.allEvents, isEmpty);
      expect(eventProvider.isLoading, isFalse);
      expect(eventProvider.errorMessage, equals(''));
    });

    test('should add events correctly', () {
      eventProvider.addEventsForTesting([testEvent1, testEvent2]);
      
      expect(eventProvider.allEvents.length, equals(2));
      expect(eventProvider.allEvents.contains(testEvent1), isTrue);
      expect(eventProvider.allEvents.contains(testEvent2), isTrue);
    });

    test('should toggle event selection', () {
      eventProvider.addEventsForTesting([testEvent1]);
      expect(testEvent1.isSelected, isFalse);
      
      eventProvider.toggleEventSelection(testEvent1);
      expect(testEvent1.isSelected, isTrue);
      
      eventProvider.toggleEventSelection(testEvent1);
      expect(testEvent1.isSelected, isFalse);
    });

    test('should update event priority', () {
      eventProvider.addEventsForTesting([testEvent1]);
      expect(testEvent1.priority, equals(1));
      
      eventProvider.updateEventPriority(testEvent1, 5);
      expect(testEvent1.priority, equals(5));
    });

    test('should return events by priority correctly', () {
      testEvent1.isSelected = true;
      testEvent2.isSelected = true;
      eventProvider.addEventsForTesting([testEvent1, testEvent2]);
      
      final selectedEvents = eventProvider.getEventsByPriority();
      
      expect(selectedEvents.length, equals(2));
      // Should be sorted by priority (1 comes before 3)
      expect(selectedEvents[0].priority, equals(1));
      expect(selectedEvents[1].priority, equals(3));
    });

    test('should return only selected events', () {
      testEvent1.isSelected = true;
      testEvent2.isSelected = false;
      eventProvider.addEventsForTesting([testEvent1, testEvent2]);
      
      final selectedEvents = eventProvider.getEventsByPriority();
      
      expect(selectedEvents.length, equals(1));
      expect(selectedEvents[0].uid, equals('event-1'));
    });

    test('should clear all data', () {
      eventProvider.addEventsForTesting([testEvent1, testEvent2]);
      eventProvider.clearAllData();
      
      expect(eventProvider.allEvents, isEmpty);
    });

    test('should handle loading state', () {
      expect(eventProvider.isLoading, isFalse);
      
      // Would test loading state changes during async operations
      // This requires mocking the calendar service calls
    });

    test('should handle error messages', () {
      expect(eventProvider.errorMessage, equals(''));
      
      // Would test error handling during failed imports
      // This requires mocking failed calendar service calls
    });

    test('should not add duplicate events', () {
      eventProvider.addEventsForTesting([testEvent1]);
      eventProvider.addEventsForTesting([testEvent1]); // Add same event again
      
      expect(eventProvider.allEvents.length, equals(1));
    });
  });
}
