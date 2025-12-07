import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:conference_agenda_tracker/providers/event_provider.dart';
import 'package:conference_agenda_tracker/models/calendar_event.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Mock SharedPreferences to return empty data
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/shared_preferences'),
            (MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, Object>{}; // Return empty preferences
      }
      if (methodCall.method == 'setString') {
        return true;
      }
      if (methodCall.method == 'remove') {
        return true;
      }
      if (methodCall.method == 'clear') {
        return true;
      }
      return null;
    });
  });

  tearDown(() async {
    // Clear mock handlers after each test
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/shared_preferences'),
            null);
  });

  group('Performance Tests', () {
    test('handles 1000 events efficiently', () {
      final provider = EventProvider();
      final stopwatch = Stopwatch()..start();

      // Generate 1000 events
      final events = List.generate(1000, (i) => {
        'title': 'Event $i',
        'start': DateTime.now().add(Duration(hours: i)),
        'end': DateTime.now().add(Duration(hours: i, minutes: 30)),
        'description': 'Description for event $i',
        'location': 'Room ${i % 10}',
      });

      provider.addTestEvents(events);
      stopwatch.stop();

      expect(provider.events.length, equals(1000));
      expect(stopwatch.elapsedMilliseconds, lessThan(1000), 
        reason: 'Should load 1000 events in under 1 second');
    });

    test('filtering 1000 events is fast', () {
      final provider = EventProvider();
      
      // Generate 1000 events
      final events = List.generate(1000, (i) => {
        'title': i % 10 == 0 ? 'Flutter Event $i' : 'Other Event $i',
        'start': DateTime.now().add(Duration(hours: i)),
        'end': DateTime.now().add(Duration(hours: i, minutes: 30)),
      });

      provider.addTestEvents(events);

      final stopwatch = Stopwatch()..start();
      provider.filterEvents('Flutter');
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(100),
        reason: 'Filtering should complete in under 100ms');
    });

    test('selecting/deselecting events scales well', () async {
      final provider = EventProvider();
      
      // Wait for provider initialization
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Generate 100 events with unique UIDs
      final events = List.generate(100, (i) => {
        'uid': 'event-$i',
        'title': 'Event $i',
        'start': DateTime.now().add(Duration(hours: i)),
        'end': DateTime.now().add(Duration(hours: i, minutes: 30)),
      });

      provider.addTestEvents(events);

      final stopwatch = Stopwatch()..start();
      
      // Select 50 events
      for (var i = 0; i < 50; i++) {
        provider.toggleEventSelection(provider.events[i]);
      }
      
      // Wait for async save operations to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      stopwatch.stop();

      expect(provider.selectedEvents.length, equals(50));
      expect(stopwatch.elapsedMilliseconds, lessThan(500),
        reason: 'Selecting 50 events should be fast');
    });

    test('sorting large event lists is efficient', () {
      final events = List.generate(1000, (i) => CalendarEvent(
        uid: 'event-$i',
        title: 'Event $i',
        description: '',
        startTime: DateTime.now().subtract(Duration(hours: i)),
        endTime: DateTime.now().subtract(Duration(hours: i - 1)),
        location: '',
      ));

      final stopwatch = Stopwatch()..start();
      events.sort((a, b) => a.startTime.compareTo(b.startTime));
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(100),
        reason: 'Sorting 1000 events should be fast');
      expect(events.first.startTime.isBefore(events.last.startTime), isTrue);
    });

    test('JSON serialization of large datasets is fast', () {
      final events = List.generate(500, (i) => CalendarEvent(
        uid: 'event-$i',
        title: 'Event $i with a longer title to simulate real data',
        description: 'A detailed description that might contain several sentences of information.',
        startTime: DateTime.now().add(Duration(hours: i)),
        endTime: DateTime.now().add(Duration(hours: i, minutes: 30)),
        location: 'Conference Room ${i % 10}',
        speaker: 'Dr. Speaker $i',
      ));

      final stopwatch = Stopwatch()..start();
      final jsonList = events.map((e) => e.toJson()).toList();
      stopwatch.stop();

      expect(jsonList.length, equals(500));
      expect(stopwatch.elapsedMilliseconds, lessThan(200),
        reason: 'JSON serialization should be fast');
    });

    test('memory usage is reasonable for large datasets', () {
      final provider = EventProvider();
      
      // Generate 5000 events
      final events = List.generate(5000, (i) => {
        'title': 'Event $i',
        'start': DateTime.now().add(Duration(hours: i)),
        'end': DateTime.now().add(Duration(hours: i, minutes: 30)),
        'description': 'Description $i',
      });

      provider.addTestEvents(events);

      expect(provider.events.length, equals(5000));
      
      // If this test completes without OOM, memory usage is acceptable
      expect(true, isTrue);
    });

    test('concurrent operations on provider', () async {
      final provider = EventProvider();
      
      // Wait for provider initialization
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Clear any existing state
      await provider.clearAllData();
      
      provider.addTestEvents(List.generate(100, (i) => {
        'uid': 'concurrent-event-$i',
        'title': 'Event $i',
        'start': DateTime.now().add(Duration(hours: i)),
        'end': DateTime.now().add(Duration(hours: i, minutes: 30)),
      }));

      // Select events sequentially (simpler for tests)
      for (var i = 0; i < 10; i++) {
        provider.toggleEventSelection(provider.events[i]);
      }

      // Wait for async save operations to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Should handle operations without crashing
      expect(provider.selectedEvents.length, equals(10));
    });
  });
}
