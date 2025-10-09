import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import '../models/calendar_event.dart';

class CalendarService {
  Future<List<CalendarEvent>> parseCalendarFromFile(File file) async {
    final contents = await file.readAsString();
    return parseICalendarContent(contents);
  }

  Future<List<CalendarEvent>> parseCalendarFromUrl(String url) async {
    try {
      // Security: Only allow HTTPS and webcal:// URLs
      var fetchUrl = url.trim();
      if (fetchUrl.startsWith('webcal://')) {
        fetchUrl = fetchUrl.replaceFirst('webcal://', 'https://');
      } else if (!fetchUrl.startsWith('https://')) {
        throw Exception(
            'Security Error: Only HTTPS URLs are allowed for calendar imports. HTTP is not secure.');
      }

      // Validate URL structure
      final uri = Uri.parse(fetchUrl);
      if (!uri.hasScheme || !uri.hasAuthority) {
        throw Exception('Invalid URL format');
      }

      // Fetch with timeout and size limit
      final response = await http.get(uri).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Enforce maximum file size (10MB)
        if (response.bodyBytes.length > 10 * 1024 * 1024) {
          throw Exception('Calendar file too large. Maximum size is 10MB.');
        }
        return parseICalendarContent(response.body);
      } else {
        throw Exception(
            'Failed to fetch calendar from URL: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching calendar: $e');
    }
  }

  Future<List<CalendarEvent>> parseCalendarFromAsset(String assetPath) async {
    try {
      final contents = await rootBundle.loadString(assetPath);
      return parseICalendarContent(contents);
    } catch (e) {
      throw Exception('Error loading calendar asset: $e');
    }
  }

  List<CalendarEvent> parseICalendarContent(String content) {
    final List<CalendarEvent> events = [];

    try {
      final calendar = ICalendar.fromString(content);
      // The new ICalendar API exposes parsed components in `data` as a
      // List<Map<String, dynamic>> where each map contains a `type` (e.g.
      // 'VEVENT') and parsed fields like 'dtstart' / 'dtend' (IcsDateTime),
      // 'uid', 'summary', 'description', 'location', etc.
      for (final component in calendar.data) {
        try {
          if (component['type'] != 'VEVENT') continue;

          final startRaw = component['dtstart'];
          final endRaw = component['dtend'];

          DateTime? start;
          DateTime? end;

          if (startRaw is IcsDateTime) start = startRaw.toDateTime();
          if (endRaw is IcsDateTime) end = endRaw.toDateTime();

          if (start == null || end == null) continue;

          final uid = (component['uid'] as String?) ??
              DateTime.now().millisecondsSinceEpoch.toString();
          final title = (component['summary'] as String?) ?? 'Untitled Event';
          final description = (component['description'] as String?) ?? '';
          final location = (component['location'] as String?) ?? '';

          // Extract speaker/organizer information
          String speaker = '';

          // Try multiple field names that might contain speaker info
          final speakerFields = [
            'organizer',
            'ORGANIZER',
            'attendee',
            'ATTENDEE'
          ];

          for (final field in speakerFields) {
            if (component[field] != null) {
              final fieldValue = component[field].toString();

              // Extract name from various formats
              RegExp cnRegex = RegExp(r'CN=([^;,]+)', caseSensitive: false);
              final cnMatch = cnRegex.firstMatch(fieldValue);
              if (cnMatch != null) {
                speaker = cnMatch.group(1)?.trim().replaceAll('"', '') ?? '';
                break;
              }

              // If no CN format, try to use the value directly if it looks like a name
              if (speaker.isEmpty &&
                  !fieldValue.contains('@') &&
                  fieldValue.length < 50) {
                speaker = fieldValue.trim().replaceAll('"', '');
                break;
              }
            }
          }

          // Fallback: try to extract from description if it mentions a speaker
          if (speaker.isEmpty && description.isNotEmpty) {
            final speakerMatch = RegExp(
                    r'(?:Speaker|Presenter|By):?\s*([^\n,;]+)',
                    caseSensitive: false)
                .firstMatch(description);
            if (speakerMatch != null) {
              speaker = speakerMatch.group(1)?.trim() ?? '';
            }
          }

          events.add(CalendarEvent(
            uid: uid,
            title: title,
            description: description,
            startTime: start,
            endTime: end,
            location: location,
            speaker: speaker,
          ));
        } catch (_) {
          // Skip malformed components
          continue;
        }
      }
    } catch (e) {
      throw Exception('Error parsing calendar content: $e');
    }

    return events;
  }
}
