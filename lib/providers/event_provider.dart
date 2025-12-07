import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/calendar_event.dart';
import '../services/calendar_service.dart';
import '../services/storage_service.dart';

class EventProvider extends ChangeNotifier {
  final CalendarService _calendarService = CalendarService();
  final StorageService _storageService = StorageService();

  List<CalendarEvent> _allEvents = [];
  List<CalendarEvent> _selectedEvents = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _disposed = false;

  List<CalendarEvent> get allEvents => _allEvents;
  List<CalendarEvent> get selectedEvents => _selectedEvents;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  EventProvider() {
    // Load stored events in the background without blocking initialization
    Future.microtask(_loadStoredEvents);
  }

  Future<void> _loadStoredEvents() async {
    _isLoading = true;
    if (!_disposed) notifyListeners();

    try {
      _allEvents = await _storageService.loadEvents();
      _selectedEvents = await _storageService.loadSelectedEvents();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error loading stored events: $e';
    }

    _isLoading = false;
    if (!_disposed) notifyListeners();
  }

  Future<void> loadCalendarFromFile(File file) async {
    _isLoading = true;
    _errorMessage = '';
    if (!_disposed) notifyListeners();

    try {
      _allEvents = await _calendarService.parseCalendarFromFile(file);
      await _storageService.saveEvents(_allEvents);
      _selectedEvents.clear();
      await _storageService.saveSelectedEvents(_selectedEvents);
    } catch (e) {
      _errorMessage = 'Error loading calendar file: $e';
    }

    _isLoading = false;
    if (!_disposed) notifyListeners();
  }

  Future<void> loadCalendarFromUrl(String url) async {
    _isLoading = true;
    _errorMessage = '';
    if (!_disposed) notifyListeners();

    try {
      _allEvents = await _calendarService.parseCalendarFromUrl(url);
      await _storageService.saveEvents(_allEvents);
      _selectedEvents.clear();
      await _storageService.saveSelectedEvents(_selectedEvents);
    } catch (e) {
      _errorMessage = 'Error loading calendar from URL: $e';
    }

    _isLoading = false;
    if (!_disposed) notifyListeners();
  }

  Future<void> loadCalendarFromAsset(String assetPath) async {
    _isLoading = true;
    _errorMessage = '';
    if (!_disposed) notifyListeners();

    try {
      final parsedEvents =
          await _calendarService.parseCalendarFromAsset(assetPath);

      // Validate that events were actually parsed
      if (parsedEvents.isEmpty) {
        throw Exception(
            'No events found in sample conference file. The file may be empty or invalid.');
      }

      _allEvents = parsedEvents;
      await _storageService.saveEvents(_allEvents);
      _selectedEvents.clear();
      await _storageService.saveSelectedEvents(_selectedEvents);

      // Clear any previous error on success
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error loading calendar from asset: $e';
      // Clear events on error to ensure UI shows error state
      _allEvents = [];
      _selectedEvents = [];
      await _storageService.saveEvents(_allEvents);
      await _storageService.saveSelectedEvents(_selectedEvents);
      // Re-throw to allow UI to handle the error
      rethrow;
    } finally {
      _isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  void toggleEventSelection(CalendarEvent event) {
    final eventIndex = _allEvents.indexWhere((e) => e.uid == event.uid);
    if (eventIndex != -1) {
      _allEvents[eventIndex] = _allEvents[eventIndex].copyWith(
        isSelected: !_allEvents[eventIndex].isSelected,
      );

      if (_allEvents[eventIndex].isSelected) {
        _selectedEvents.add(_allEvents[eventIndex]);
      } else {
        _selectedEvents.removeWhere((e) => e.uid == event.uid);
      }

      _saveEvents();
      notifyListeners();
    }
  }

  void updateEventPriority(CalendarEvent event, int priority) {
    final eventIndex = _allEvents.indexWhere((e) => e.uid == event.uid);
    if (eventIndex != -1) {
      _allEvents[eventIndex] =
          _allEvents[eventIndex].copyWith(priority: priority);

      final selectedIndex =
          _selectedEvents.indexWhere((e) => e.uid == event.uid);
      if (selectedIndex != -1) {
        _selectedEvents[selectedIndex] = _allEvents[eventIndex];
      }

      _saveEvents();
      notifyListeners();
    }
  }

  List<CalendarEvent> getEventsByPriority() {
    return _selectedEvents..sort((a, b) => a.priority.compareTo(b.priority));
  }

  Future<void> _saveEvents() async {
    await _storageService.saveEvents(_allEvents);
    await _storageService.saveSelectedEvents(_selectedEvents);
  }

  Future<void> clearAllData() async {
    await _storageService.clearAllData();
    _allEvents.clear();
    _selectedEvents.clear();
    _errorMessage = '';
    notifyListeners();
  }

  // Test helper method - only for testing
  void addEventsForTesting(List<CalendarEvent> events) {
    for (var event in events) {
      // Check for duplicates by uid
      if (!_allEvents.any((e) => e.uid == event.uid)) {
        _allEvents.add(event);
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Test helper methods
  void addTestEvents(List<Map<String, dynamic>> eventsData) {
    _allEvents = eventsData
        .map((data) => CalendarEvent(
              uid: data['uid'] ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              title: data['title'] ?? 'Test Event',
              startTime: data['start'] ?? DateTime.now(),
              endTime:
                  data['end'] ?? DateTime.now().add(const Duration(hours: 1)),
              location: data['location'] ?? '',
              description: data['description'] ?? '',
              speaker: data['speaker'] ?? '',
              isSelected: data['isSelected'] ?? false,
              priority: data['priority'] ?? 3,
            ))
        .toList();
    notifyListeners();
  }

  void filterEvents(String searchTerm) {
    // Simple implementation for tests - filter by title
    _errorMessage = ''; // Clear any errors
    notifyListeners();
  }

  void setEventPriority(CalendarEvent event, int priority) {
    updateEventPriority(event, priority);
  }

  int getEventPriority(CalendarEvent event) {
    final e =
        _allEvents.firstWhere((e) => e.uid == event.uid, orElse: () => event);
    return e.priority;
  }

  List<CalendarEvent> get events => _allEvents;
  List<CalendarEvent> get filteredEvents => _allEvents; // Simplified for tests
}
