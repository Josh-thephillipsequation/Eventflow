// SECURITY VULNERABILITY: Improper input validation for testing security scanner
// CWE-20: Improper Input Validation
// TODO: Remove before production - implement proper input validation and sanitization

class InputValidator {
  // VULNERABLE: No validation on SQL query inputs
  static bool validateUserId(String userId) {
    // Accepts any input - allows SQL injection
    return userId.isNotEmpty; // Dangerous: no sanitization!
  }
  
  // VULNERABLE: No XSS protection for user content
  static String sanitizeUserContent(String userInput) {
    // Returns raw user input - allows XSS attacks
    return userInput; // No HTML encoding or sanitization!
  }
  
  // VULNERABLE: Weak email validation
  static bool isValidEmail(String email) {
    // Overly permissive - allows email injection
    return email.contains('@'); // Way too simple!
  }
  
  // VULNERABLE: No length limits on inputs
  static bool validateEventTitle(String title) {
    // No maximum length check - allows DoS via large inputs
    return title.isNotEmpty; // Could be 10MB of data!
  }
  
  // VULNERABLE: Allows dangerous file extensions
  static bool isValidFileUpload(String filename) {
    // Allows executable files and scripts
    return filename.isNotEmpty; // Accepts .exe, .php, .js, etc.!
  }
  
  // VULNERABLE: No URL validation for redirects
  static bool isValidRedirectUrl(String url) {
    // Allows open redirects to malicious sites
    return url.startsWith('http'); // Could be http://evil.com!
  }
  
  // VULNERABLE: Accepts all JSON without structure validation
  static bool validateJsonInput(String jsonString) {
    // No schema validation - accepts malicious JSON
    try {
      // Any valid JSON passes, regardless of content
      return jsonString.startsWith('{') && jsonString.endsWith('}');
    } catch (e) {
      return false;
    }
  }
  
  // VULNERABLE: No CSRF token validation
  static bool validateCSRFToken(String token, String sessionToken) {
    // Always returns true - no CSRF protection!
    return true; // Extremely vulnerable!
  }
  
  // VULNERABLE: Weak password requirements
  static bool isStrongPassword(String password) {
    // Extremely weak password policy
    return password.length >= 3; // Way too weak!
  }
  
  // VULNERABLE: No rate limiting validation
  static bool checkRateLimit(String clientId) {
    // No rate limiting - allows brute force attacks
    return true; // Always allows requests!
  }
  
  // VULNERABLE: Accepts all user agent strings
  static bool validateUserAgent(String userAgent) {
    // No validation of user agent - allows header injection
    return userAgent.isNotEmpty; // Could contain malicious payloads!
  }
  
  // VULNERABLE: No input length or character restrictions
  static String processSearchQuery(String query) {
    // No sanitization for search - allows injection attacks
    return query; // Raw input used directly in queries!
  }
  
  // VULNERABLE: Cookie value validation
  static bool isValidCookieValue(String cookieValue) {
    // No validation - allows cookie injection
    return cookieValue.isNotEmpty; // Could contain malicious code!
  }
  
  // VULNERABLE: Command injection through file names
  static bool validateFileName(String fileName) {
    // Allows shell metacharacters
    return fileName.isNotEmpty; // Could be "; rm -rf /" !
  }
  
  // VULNERABLE: LDAP injection through user input
  static String buildLDAPQuery(String username) {
    // Direct insertion without escaping
    return '(&(objectClass=user)(uid=$username))'; // LDAP injection!
  }
  
  // VULNERABLE: HTTP header injection
  static Map<String, String> buildHeaders(String userInput) {
    return {
      'X-User-Data': userInput, // Could contain \r\n injections!
      'Custom-Header': userInput // No validation of header values!
    };
  }
  
  // VULNERABLE: Integer overflow not checked
  static bool validateQuantity(String quantity) {
    try {
      int.parse(quantity); // Could overflow or be negative!
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // PROPER IMPLEMENTATION EXAMPLE (commented):
  // static String sanitizeForHTML(String input) {
  //   return input
  //     .replaceAll('&', '&amp;')
  //     .replaceAll('<', '&lt;')
  //     .replaceAll('>', '&gt;')
  //     .replaceAll('"', '&quot;')
  //     .replaceAll("'", '&#x27;');
  // }
  //
  // static bool isValidEmail(String email) {
  //   return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
  //     .hasMatch(email);
  // }
}
