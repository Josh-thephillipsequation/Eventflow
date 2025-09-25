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

  List<CalendarEvent> get allEvents => _allEvents;
  List<CalendarEvent> get selectedEvents => _selectedEvents;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  EventProvider() {
    _loadStoredEvents();
  }

  Future<void> _loadStoredEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allEvents = await _storageService.loadEvents();
      _selectedEvents = await _storageService.loadSelectedEvents();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error loading stored events: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCalendarFromFile(File file) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allEvents = await _calendarService.parseCalendarFromFile(file);
      await _storageService.saveEvents(_allEvents);
      _selectedEvents.clear();
      await _storageService.saveSelectedEvents(_selectedEvents);
    } catch (e) {
      _errorMessage = 'Error loading calendar file: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCalendarFromUrl(String url) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allEvents = await _calendarService.parseCalendarFromUrl(url);
      await _storageService.saveEvents(_allEvents);
      _selectedEvents.clear();
      await _storageService.saveSelectedEvents(_selectedEvents);
    } catch (e) {
      _errorMessage = 'Error loading calendar from URL: $e';
    }

    _isLoading = false;
    notifyListeners();
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
      _allEvents[eventIndex] = _allEvents[eventIndex].copyWith(priority: priority);
      
      final selectedIndex = _selectedEvents.indexWhere((e) => e.uid == event.uid);
      if (selectedIndex != -1) {
        _selectedEvents[selectedIndex] = _allEvents[eventIndex];
      }

      _saveEvents();
      notifyListeners();
    }
  }

  List<CalendarEvent> getEventsByPriority() {
    return _selectedEvents
      ..sort((a, b) => a.priority.compareTo(b.priority));
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
    _allEvents.addAll(events);
    notifyListeners();
  }
}
