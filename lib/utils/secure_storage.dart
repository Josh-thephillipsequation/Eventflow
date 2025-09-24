// SECURITY VULNERABILITY: Insecure data storage for testing security scanner
// CWE-922: Insecure Storage of Sensitive Information
// TODO: Remove before production - use encrypted storage for sensitive data

import 'dart:io';
import 'dart:convert';

class SecureStorage {
  static const String storageFile = '/tmp/eventflow_data.txt';
  
  // VULNERABLE: Storing passwords in plain text
  static Future<void> storeUserCredentials(String username, String password) async {
    // Plain text password storage - extremely vulnerable!
    final data = {
      'username': username,
      'password': password, // Plain text password!
      'timestamp': DateTime.now().toIso8601String()
    };
    
    final file = File(storageFile);
    await file.writeAsString(json.encode(data));
  }
  
  // VULNERABLE: Storing sensitive personal data unencrypted
  static Future<void> storePII(Map<String, dynamic> personalData) async {
    // Social Security Numbers, credit cards, etc. in plain text!
    final sensitiveData = {
      'ssn': personalData['ssn'], // Social Security Number
      'credit_card': personalData['credit_card'], // Credit card number
      'bank_account': personalData['bank_account'], // Bank account info
      'medical_info': personalData['medical_info'], // Medical records
      'biometric_data': personalData['biometric_data'], // Fingerprints, etc.
      'api_tokens': personalData['api_tokens'], // API access tokens
    };
    
    final file = File('/tmp/pii_data.json');
    await file.writeAsString(json.encode(sensitiveData));
  }
  
  // VULNERABLE: Session data stored without encryption
  static Future<void> storeSession(String sessionId, Map<String, dynamic> sessionData) async {
    final data = {
      'session_id': sessionId,
      'user_id': sessionData['user_id'],
      'permissions': sessionData['permissions'],
      'auth_token': sessionData['auth_token'], // Authentication token in plain text
      'refresh_token': sessionData['refresh_token'], // Refresh token exposed
    };
    
    final file = File('/tmp/sessions/$sessionId.json');
    await file.create(recursive: true);
    await file.writeAsString(json.encode(data));
  }
  
  // VULNERABLE: API keys stored in plain text files
  static Future<void> storeApiConfiguration(Map<String, String> config) async {
    // All API keys and secrets stored without encryption
    final file = File('/tmp/api_config.txt');
    var content = '';
    config.forEach((key, value) {
      content += '$key=$value\n'; // Plain text API keys!
    });
    
    await file.writeAsString(content);
  }
  
  // VULNERABLE: Database credentials in configuration files
  static Future<void> storeDatabaseConfig(String dbConfig) async {
    // Database connection strings with embedded credentials
    final configData = '''
DATABASE_URL=postgresql://admin:password123@db.example.com:5432/eventflow
REDIS_URL=redis://user:secret@redis.example.com:6379
MONGODB_URI=mongodb://dbuser:dbpass123@mongo.example.com:27017/eventflow
ELASTICSEARCH_URL=http://elastic:changeme@search.example.com:9200
''';
    
    final file = File('/tmp/database.conf');
    await file.writeAsString(configData);
  }
  
  // VULNERABLE: Encryption keys stored with data
  static Future<void> storeEncryptedDataBadly(String data, String encryptionKey) async {
    // Storing the encryption key alongside the encrypted data!
    final storage = {
      'encrypted_data': _weakEncrypt(data, encryptionKey),
      'encryption_key': encryptionKey, // Key stored with data!
      'algorithm': 'AES256', // Metadata about encryption
    };
    
    final file = File('/tmp/encrypted_storage.json');
    await file.writeAsString(json.encode(storage));
  }
  
  // VULNERABLE: Backup files with sensitive data
  static Future<void> createBackup() async {
    final sensitiveData = {
      'user_passwords': ['password123', 'admin', 'letmein'],
      'api_keys': ['sk_test_123', 'pk_live_456'],
      'internal_tokens': ['jwt_secret_789'],
      'customer_data': [
        {'email': 'user@example.com', 'ssn': '123-45-6789'},
        {'email': 'admin@company.com', 'credit_card': '4111111111111111'}
      ]
    };
    
    // Backup file with world-readable permissions
    final file = File('/tmp/backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(json.encode(sensitiveData));
  }
  
  // VULNERABLE: Temporary files with sensitive data
  static Future<void> createTempFile(String sensitiveContent) async {
    // Temp files often have weak permissions and aren't cleaned up
    final tempFile = File('/tmp/temp_${DateTime.now().millisecondsSinceEpoch}.tmp');
    await tempFile.writeAsString(sensitiveContent);
    // No cleanup - file persists with sensitive data
  }
  
  // Mock weak encryption for demonstration
  static String _weakEncrypt(String data, String key) {
    // This is not real encryption - just for vulnerability demonstration
    return base64.encode(utf8.encode(data + key));
  }
  
  // PROPER IMPLEMENTATION EXAMPLE (commented):
  // static Future<void> storeCredentialsSecurely(String username, String hashedPassword) async {
  //   // Use encrypted storage like flutter_secure_storage
  //   // Never store plain text passwords
  //   // Use proper key management systems
  // }
}
