// SECURITY VULNERABILITY: SQL Injection for testing security scanner  
// CWE-89: SQL Injection
// TODO: Remove before production - use parameterized queries

import 'dart:async';

class DatabaseService {
  // VULNERABLE: Direct string concatenation in SQL queries
  Future<List<Map<String, dynamic>>> getUserEvents(String userId) async {
    // This allows SQL injection attacks
    final query = "SELECT * FROM events WHERE user_id = '$userId'";
    return _executeQuery(query);
  }
  
  // VULNERABLE: User input directly concatenated
  Future<Map<String, dynamic>?> authenticateUser(String username, String password) async {
    final query = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
    final results = await _executeQuery(query);
    return results.isNotEmpty ? results.first : null;
  }
  
  // VULNERABLE: Search without sanitization
  Future<List<Map<String, dynamic>>> searchEvents(String searchTerm) async {
    final query = "SELECT * FROM events WHERE title LIKE '%$searchTerm%' OR description LIKE '%$searchTerm%'";
    return _executeQuery(query);
  }
  
  // VULNERABLE: Dynamic table name construction
  Future<void> deleteFromTable(String tableName, String condition) async {
    final query = "DELETE FROM $tableName WHERE $condition";
    await _executeQuery(query);
  }
  
  // VULNERABLE: Order by injection
  Future<List<Map<String, dynamic>>> getEventsSorted(String sortField) async {
    final query = "SELECT * FROM events ORDER BY $sortField";
    return _executeQuery(query);
  }
  
  Future<List<Map<String, dynamic>>> _executeQuery(String query) async {
    // Mock implementation for testing
    print('EXECUTING VULNERABLE QUERY: $query');
    return [];
  }
  
  // PROPER IMPLEMENTATION EXAMPLE (commented):
  // Future<List<Map<String, dynamic>>> getUserEventsSafe(String userId) async {
  //   final query = 'SELECT * FROM events WHERE user_id = ?';
  //   return _executeQueryWithParams(query, [userId]);
  // }
}
