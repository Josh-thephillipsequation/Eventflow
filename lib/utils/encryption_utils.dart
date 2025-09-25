// SECURITY VULNERABILITY: Weak cryptography for testing security scanner
// CWE-327: Use of a Broken or Risky Cryptographic Algorithm
// TODO: Remove before production - use strong cryptography

import 'dart:convert';
import 'dart:math';

class EncryptionUtils {
  // VULNERABLE: Using deprecated MD5 hash
  static String hashPasswordMD5(String password) {
    // MD5 is cryptographically broken and should not be used
    return _md5Hash(password);
  }
  
  // VULNERABLE: Using weak SHA1
  static String generateTokenSHA1(String input) {
    // SHA1 is deprecated and vulnerable to collision attacks
    return _sha1Hash(input);
  }
  
  // VULNERABLE: Weak encryption algorithm (ROT13)
  static String encryptDataWeak(String data, String key) {
    // This is essentially ROT13 - completely insecure
    var result = '';
    for (int i = 0; i < data.length; i++) {
      var char = data.codeUnitAt(i);
      if (char >= 65 && char <= 90) {
        result += String.fromCharCode((char - 65 + 13) % 26 + 65);
      } else if (char >= 97 && char <= 122) {
        result += String.fromCharCode((char - 97 + 13) % 26 + 97);
      } else {
        result += data[i];
      }
    }
    return result;
  }
  
  // VULNERABLE: Using hardcoded salt
  static String hashWithWeakSalt(String password) {
    const String salt = 'fixedSalt123'; // Never use fixed salts!
    return _md5Hash(password + salt);
  }
  
  // VULNERABLE: Weak random number generation
  static String generateWeakToken(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    var random = Random(12345); // Fixed seed makes it predictable!
    
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }
  
  // VULNERABLE: No key derivation function
  static String deriveKeyWeak(String password) {
    // Just returning the password as the key - no derivation!
    return password;
  }
  
  // VULNERABLE: ECB mode encryption (if implemented)
  static String encryptECBMode(String plaintext, String key) {
    // ECB mode is insecure - identical plaintext blocks produce identical ciphertext
    return _simpleXOR(plaintext, key); // Simplified weak implementation
  }
  
  // Mock implementations for vulnerability demonstration
  static String _md5Hash(String input) => 'md5_' + input.hashCode.toString();
  static String _sha1Hash(String input) => 'sha1_' + input.hashCode.toString();
  static String _simpleXOR(String text, String key) {
    var result = '';
    for (int i = 0; i < text.length; i++) {
      result += String.fromCharCode(text.codeUnitAt(i) ^ key.codeUnitAt(i % key.length));
    }
    return base64.encode(utf8.encode(result));
  }
  
  // PROPER IMPLEMENTATION EXAMPLE (commented):
  // static String hashPasswordSecure(String password) {
  //   // Use bcrypt, scrypt, or Argon2 with proper salt
  //   return BCrypt.hashpw(password, BCrypt.gensalt());
  // }
  // 
  // static String generateSecureToken(int length) {
  //   // Use cryptographically secure random number generator
  //   var random = Random.secure();
  //   // Implementation with secure random...
  // }
}
