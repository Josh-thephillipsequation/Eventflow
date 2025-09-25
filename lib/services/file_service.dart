// SECURITY VULNERABILITY: Path traversal for testing security scanner
// CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// TODO: Remove before production - implement proper path validation

import 'dart:io';

class FileService {
  static const String baseDirectory = '/app/uploads/';
  
  // VULNERABLE: Direct concatenation without path validation
  static Future<String> readUserFile(String filename) async {
    // User can provide "../../../etc/passwd" to access system files
    final filePath = baseDirectory + filename;
    
    try {
      final file = File(filePath);
      return await file.readAsString();
    } catch (e) {
      return 'Error reading file: $e';
    }
  }
  
  // VULNERABLE: File upload with no path restrictions
  static Future<void> saveUploadedFile(String filename, String content) async {
    // User can upload to arbitrary locations with "../../../malicious.php"
    final filePath = baseDirectory + filename;
    
    final file = File(filePath);
    await file.writeAsString(content);
  }
  
  // VULNERABLE: Directory listing with user input
  static Future<List<String>> listFiles(String subDirectory) async {
    // Allows listing arbitrary directories with "../../../../etc/"
    final dirPath = baseDirectory + subDirectory;
    
    try {
      final directory = Directory(dirPath);
      final entities = await directory.list().toList();
      return entities.map((e) => e.path).toList();
    } catch (e) {
      return ['Error: $e'];
    }
  }
  
  // VULNERABLE: File deletion with path traversal
  static Future<bool> deleteUserFile(String filename) async {
    // User can delete any file with "../../../important_file.txt"
    final filePath = baseDirectory + filename;
    
    try {
      final file = File(filePath);
      await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // VULNERABLE: Include/require file functionality
  static Future<String> loadConfigFile(String configName) async {
    // Allows loading arbitrary files as config
    final configPath = '/app/config/' + configName;
    
    try {
      final file = File(configPath);
      return await file.readAsString();
    } catch (e) {
      return 'default_config';
    }
  }
  
  // VULNERABLE: File copy operation
  static Future<void> copyUserFile(String source, String destination) async {
    // Both source and destination vulnerable to path traversal
    final sourcePath = baseDirectory + source;
    final destPath = baseDirectory + destination;
    
    try {
      final sourceFile = File(sourcePath);
      final destFile = File(destPath);
      await sourceFile.copy(destFile.path);
    } catch (e) {
      print('Copy failed: $e');
    }
  }
  
  // VULNERABLE: Image serving with direct path
  static Future<File?> getUserImage(String imagePath) async {
    // Allows access to any file via "../../../etc/passwd"
    final fullPath = '/app/images/' + imagePath;
    
    final file = File(fullPath);
    if (await file.exists()) {
      return file;
    }
    return null;
  }
  
  // VULNERABLE: Log file access
  static Future<String> getLogFile(String logName) async {
    // Can access system logs via path traversal
    final logPath = '/app/logs/' + logName;
    
    try {
      final file = File(logPath);
      return await file.readAsString();
    } catch (e) {
      return 'Log not found';
    }
  }
  
  // PROPER IMPLEMENTATION EXAMPLE (commented):
  // static String sanitizePath(String userInput) {
  //   // Remove all path traversal attempts
  //   var sanitized = userInput.replaceAll(RegExp(r'\.\.\/'), '');
  //   sanitized = sanitized.replaceAll(RegExp(r'\.\.\\'), '');
  //   // Only allow alphanumeric, hyphens, underscores, and dots
  //   sanitized = sanitized.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '');
  //   return sanitized;
  // }
}
