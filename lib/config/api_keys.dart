// SECURITY VULNERABILITY: Hardcoded secrets for testing security scanner
// CWE-798: Use of Hard-coded Credentials
// TODO: Remove before production - use environment variables or secure key management

class ApiKeys {
  // VULNERABLE: Hardcoded API keys
  static const String googleApiKey = 'AIzaSyBxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';  
  static const String firebaseApiKey = 'AAAAxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxX';
  
  // VULNERABLE: Hardcoded database credentials
  static const String dbPassword = 'admin123password';
  static const String dbConnectionString = 'postgresql://admin:admin123password@db.example.com:5432/eventflow';
  
  // VULNERABLE: Hardcoded JWT secret
  static const String jwtSecret = 'super_secret_jwt_key_12345';
  
  // VULNERABLE: Hardcoded encryption key  
  static const String encryptionKey = 'MySecretEncryptionKey123456789';
  
  // VULNERABLE: Third-party service credentials
  static const String stripeSecretKey = 'sk_test_xXxXxXxXxXxXxXxXxXxXxXxXxXxX';
  static const String awsAccessKey = 'AKIAIOSFODNN7EXAMPLE';
  static const String awsSecretKey = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY';
  
  // PROPER IMPLEMENTATION EXAMPLE (commented):
  // static String get googleApiKey => Platform.environment['GOOGLE_API_KEY'] ?? '';
  // static String get dbPassword => Platform.environment['DB_PASSWORD'] ?? '';
}
