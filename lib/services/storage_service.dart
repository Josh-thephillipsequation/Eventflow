import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calendar_event.dart';

class StorageService {
  static const String _eventsKey = 'calendar_events';
  static const String _selectedEventsKey = 'selected_events';

  Future<void> saveEvents(List<CalendarEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = events.map((event) => event.toJson()).toList();
    await prefs.setString(_eventsKey, jsonEncode(eventsJson));
  }

  Future<List<CalendarEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsString = prefs.getString(_eventsKey);
    
    if (eventsString != null) {
      final List<dynamic> eventsJson = jsonDecode(eventsString);
      return eventsJson.map((json) => CalendarEvent.fromJson(json)).toList();
    }
    
    return [];
  }

  Future<void> saveSelectedEvents(List<CalendarEvent> selectedEvents) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedEventsJson = selectedEvents.map((event) => event.toJson()).toList();
    await prefs.setString(_selectedEventsKey, jsonEncode(selectedEventsJson));
  }

  Future<List<CalendarEvent>> loadSelectedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedEventsString = prefs.getString(_selectedEventsKey);
    
    if (selectedEventsString != null) {
      final List<dynamic> selectedEventsJson = jsonDecode(selectedEventsString);
      return selectedEventsJson.map((json) => CalendarEvent.fromJson(json)).toList();
    }
    
    return [];
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eventsKey);
    await prefs.remove(_selectedEventsKey);
  }
}
