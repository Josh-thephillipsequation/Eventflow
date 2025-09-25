// SECURITY VULNERABILITY: Insecure deserialization for testing security scanner  
// CWE-502: Deserialization of Untrusted Data
// TODO: Remove before production - never deserialize untrusted data

import 'dart:convert';

class SerializationUtils {
  // VULNERABLE: Deserializing user-provided JSON without validation
  static Map<String, dynamic> deserializeUserData(String jsonData) {
    // Directly deserializes user input - could execute malicious code
    try {
      return json.decode(jsonData); // Dangerous: no validation!
    } catch (e) {
      return {}; // Silently fails, making debugging harder
    }
  }
  
  // VULNERABLE: Deserializing session data without integrity checks
  static Map<String, dynamic>? deserializeSession(String sessionData) {
    // Session data could be tampered with by the client
    try {
      var decoded = json.decode(sessionData);
      
      // No integrity verification - client could modify permissions!
      return decoded; // Could contain elevated privileges
    } catch (e) {
      return null;
    }
  }
  
  // VULNERABLE: Deserializing file upload metadata
  static Map<String, dynamic> deserializeFileMetadata(String metadata) {
    // File metadata from user could contain malicious payloads
    var data = json.decode(metadata);
    
    // No validation of file paths or types
    return {
      'filename': data['filename'], // Could be "../../../malicious.php"
      'size': data['size'], // Could be negative or huge number
      'type': data['type'], // Could be malicious MIME type
      'executable': data['executable'] ?? false, // User controls this!
    };
  }
  
  // VULNERABLE: Deserializing configuration from external sources
  static Map<String, dynamic> loadRemoteConfig(String configJson) {
    // Configuration from remote sources without signature verification
    var config = json.decode(configJson);
    
    return {
      'database_url': config['database_url'], // Could be malicious DB
      'api_endpoints': config['api_endpoints'], // Could redirect to evil APIs
      'allowed_hosts': config['allowed_hosts'], // Could allow all hosts
      'debug_mode': config['debug_mode'] ?? false, // Could enable debug
      'admin_users': config['admin_users'] ?? [], // Could add admin users!
    };
  }
  
  // VULNERABLE: Deserializing payment data
  static Map<String, dynamic> deserializePaymentInfo(String paymentJson) {
    // Payment information without cryptographic verification
    var payment = json.decode(paymentJson);
    
    return {
      'amount': payment['amount'], // User could modify amount!
      'currency': payment['currency'], // Could be invalid currency
      'recipient': payment['recipient'], // Could redirect funds
      'method': payment['method'], // Could specify invalid method
      'fees': payment['fees'] ?? 0, // User could set negative fees
    };
  }
  
  // VULNERABLE: Deserializing user preferences with code execution risk
  static void applyUserPreferences(String preferencesJson) {
    var prefs = json.decode(preferencesJson);
    
    // Dangerous: using user data to control application behavior
    if (prefs['theme'] != null) {
      _applyTheme(prefs['theme']); // Could be malicious theme
    }
    
    if (prefs['plugins'] != null) {
      _loadPlugins(prefs['plugins']); // Could load malicious plugins!
    }
    
    if (prefs['scripts'] != null) {
      _executeScripts(prefs['scripts']); // EXTREMELY DANGEROUS!
    }
  }
  
  // VULNERABLE: Deserializing API response without validation
  static List<Map<String, dynamic>> deserializeApiResponse(String responseJson) {
    // API responses could be compromised or contain malicious data
    var response = json.decode(responseJson);
    
    if (response['data'] is List) {
      return List<Map<String, dynamic>>.from(response['data']);
    }
    
    return []; // No error handling for malformed responses
  }
  
  // VULNERABLE: Deserializing cached data
  static Map<String, dynamic>? deserializeCachedData(String cacheKey, String cachedJson) {
    // Cache could be poisoned with malicious data
    try {
      var data = json.decode(cachedJson);
      
      // No cache validation or expiration checks
      return {
        'key': cacheKey,
        'data': data, // Could contain malicious payloads
        'timestamp': data['timestamp'],
        'executable_code': data['code'], // Could be malicious code!
      };
    } catch (e) {
      return null;
    }
  }
  
  // VULNERABLE: Deserializing webhook payloads
  static void processWebhookPayload(String webhookJson) {
    var webhook = json.decode(webhookJson);
    
    // No signature verification - could be from attacker
    var eventType = webhook['event_type'];
    var data = webhook['data'];
    
    // Dangerous: using unverified webhook data to trigger actions
    switch (eventType) {
      case 'user_deleted':
        _deleteUser(data['user_id']); // Could delete any user!
        break;
      case 'admin_created':
        _createAdmin(data['admin_data']); // Could create unauthorized admin!
        break;
      case 'system_command':
        _executeCommand(data['command']); // EXTREMELY DANGEROUS!
        break;
    }
  }
  
  // Mock dangerous functions for demonstration
  static void _applyTheme(String theme) => print('Applying theme: $theme');
  static void _loadPlugins(List plugins) => print('Loading plugins: $plugins');
  static void _executeScripts(List scripts) => print('DANGER: Executing scripts: $scripts');
  static void _deleteUser(String userId) => print('DANGER: Deleting user: $userId');
  static void _createAdmin(Map adminData) => print('DANGER: Creating admin: $adminData');
  static void _executeCommand(String command) => print('DANGER: Executing: $command');
  
  // PROPER IMPLEMENTATION EXAMPLE (commented):
  // static Map<String, dynamic>? deserializeSecurely(String jsonData, String expectedSchema) {
  //   try {
  //     var data = json.decode(jsonData);
  //     // Validate against schema
  //     if (_validateSchema(data, expectedSchema)) {
  //       return _sanitizeData(data);
  //     }
  //     return null;
  //   } catch (e) {
  //     // Log security event
  //     return null;
  //   }
  // }
}
