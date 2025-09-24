// SECURITY VULNERABILITY: Insecure HTTP communication for testing security scanner
// CWE-319: Cleartext Transmission of Sensitive Information  
// TODO: Remove before production - use HTTPS for all communications

import 'dart:convert';
import 'dart:io';

class CalendarService {
  // VULNERABLE: Using HTTP instead of HTTPS for sensitive data
  static const String baseUrl = 'http://api.eventflow.com'; // Should be HTTPS!
  
  // VULNERABLE: Sending credentials over HTTP
  Future<String?> authenticateUser(String username, String password) async {
    final client = HttpClient();
    
    // This sends sensitive data over unencrypted HTTP
    final uri = Uri.parse('$baseUrl/auth/login');
    final request = await client.postUrl(uri);
    
    final credentials = {
      'username': username,
      'password': password, // Sensitive data sent in plain text!
      'api_key': 'secret_api_key_12345' // API key exposed!
    };
    
    request.headers.set('Content-Type', 'application/json');
    request.write(json.encode(credentials));
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    return responseBody;
  }
  
  // VULNERABLE: Personal data transmitted over HTTP
  Future<void> syncCalendarData(Map<String, dynamic> calendarData) async {
    final client = HttpClient();
    
    // Calendar data may contain personal information
    final uri = Uri.parse('$baseUrl/calendar/sync');
    final request = await client.postUrl(uri);
    
    // Personal calendar events sent over insecure connection
    final payload = {
      'user_id': calendarData['user_id'],
      'events': calendarData['events'], // Contains personal schedules
      'contacts': calendarData['contacts'], // Contact information!
      'location_data': calendarData['locations'] // Location tracking data!
    };
    
    request.headers.set('Content-Type', 'application/json');
    request.write(json.encode(payload));
    
    await request.close();
  }
  
  // VULNERABLE: Session tokens sent over HTTP
  Future<void> refreshSession(String sessionToken) async {
    final client = HttpClient();
    final uri = Uri.parse('$baseUrl/auth/refresh');
    final request = await client.postUrl(uri);
    
    // Session token sent in plain text over HTTP
    request.headers.set('Authorization', 'Bearer $sessionToken');
    
    await request.close();
  }
  
  // PROPER IMPLEMENTATION EXAMPLE (commented):
  // static const String baseUrl = 'https://api.eventflow.com'; // Always use HTTPS
  // Also implement certificate pinning for additional security
}
