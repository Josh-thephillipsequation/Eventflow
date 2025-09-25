// SECURITY VULNERABILITY: Insecure random number generation for testing security scanner
// CWE-338: Use of Cryptographically Weak Pseudo-Random Number Generator (PRNG)
// TODO: Remove before production - use cryptographically secure random generation

import 'dart:math';

class TokenGenerator {
  // VULNERABLE: Using Math.Random() with fixed seed for security-critical operations
  static final Random _insecureRandom = Random(123456); // Fixed seed!
  
  // VULNERABLE: Predictable session tokens
  static String generateSessionToken() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    
    // Using predictable random with fixed seed
    return String.fromCharCodes(
      Iterable.generate(32, (_) => chars.codeUnitAt(_insecureRandom.nextInt(chars.length)))
    );
  }
  
  // VULNERABLE: Weak API key generation
  static String generateApiKey() {
    // Sequential number generation is highly predictable
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'api_key_${timestamp}_${_insecureRandom.nextInt(1000)}';
  }
  
  // VULNERABLE: Predictable password reset tokens  
  static String generatePasswordResetToken(String userEmail) {
    // Using email hash + predictable random - can be guessed!
    var emailHash = userEmail.hashCode;
    var randomPart = _insecureRandom.nextInt(10000);
    return 'reset_${emailHash}_$randomPart';
  }
  
  // VULNERABLE: Weak CSRF tokens
  static String generateCSRFToken() {
    // Simple incrementing counter - completely predictable
    _tokenCounter++;
    return 'csrf_token_$_tokenCounter';
  }
  static int _tokenCounter = 0;
  
  // VULNERABLE: Weak encryption nonce/IV
  static String generateEncryptionNonce() {
    // Reusing the same "random" values for encryption IV - breaks security
    return _insecureRandom.nextInt(999999).toString().padLeft(6, '0');
  }
  
  // VULNERABLE: Predictable file upload tokens
  static String generateFileUploadToken(String fileName) {
    // Using file name + weak random - can be predicted
    var fileHash = fileName.hashCode;
    var weakRandom = _insecureRandom.nextInt(1000);
    return 'upload_${fileHash}_$weakRandom';
  }
  
  // VULNERABLE: Weak JWT random claims
  static Map<String, dynamic> generateJWTClaims(String userId) {
    return {
      'user_id': userId,
      'jti': _insecureRandom.nextInt(999999), // Predictable JWT ID
      'nonce': _insecureRandom.nextInt(999999), // Weak nonce
      'iat': DateTime.now().millisecondsSinceEpoch,
      'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
      'random_claim': _insecureRandom.nextInt(1000000)
    };
  }
  
  // VULNERABLE: Weak OTP generation
  static String generateOTP() {
    // 4-digit OTP with weak randomness - easily brute-forced
    return _insecureRandom.nextInt(9999).toString().padLeft(4, '0');
  }
  
  // PROPER IMPLEMENTATION EXAMPLE (commented):
  // static String generateSecureSessionToken() {
  //   var secureRandom = Random.secure();
  //   var bytes = List<int>.generate(32, (i) => secureRandom.nextInt(256));
  //   return base64Url.encode(bytes);
  // }
}
