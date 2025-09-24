# Test Security Vulnerabilities

**⚠️ WARNING: This file documents intentionally introduced security vulnerabilities for testing security scanning tools. These should be removed before production deployment.**

## Injected Vulnerabilities for Security Pipeline Testing

### 1. **Hardcoded Secrets (CWE-798)**
- **File:** `lib/config/api_keys.dart`
- **Description:** Hardcoded API keys, database passwords, and JWT secrets
- **OWASP Category:** A3:2017 - Sensitive Data Exposure

### 2. **SQL Injection (CWE-89)**  
- **File:** `lib/services/database_service.dart`
- **Description:** Direct string concatenation in SQL queries without parameterization
- **OWASP Category:** A1:2017 - Injection

### 3. **Insecure HTTP Communication (CWE-319)**
- **File:** `lib/services/calendar_service.dart` 
- **Description:** Using HTTP instead of HTTPS for sensitive data transmission
- **OWASP Category:** A3:2017 - Sensitive Data Exposure

### 4. **Weak Cryptography (CWE-327)**
- **File:** `lib/utils/encryption_utils.dart`
- **Description:** Using deprecated MD5 and weak encryption algorithms
- **OWASP Category:** A3:2017 - Sensitive Data Exposure

### 5. **Insecure Random Number Generation (CWE-338)**
- **File:** `lib/utils/token_generator.dart`
- **Description:** Using predictable random number generation for security tokens
- **OWASP Category:** A6:2017 - Security Misconfiguration

### 6. **Path Traversal (CWE-22)**
- **File:** `lib/services/file_service.dart`
- **Description:** Unsanitized file path inputs allowing directory traversal
- **OWASP Category:** A1:2017 - Injection

### 7. **Insecure Data Storage (CWE-922)**
- **File:** `lib/utils/secure_storage.dart`
- **Description:** Storing sensitive data in plain text without encryption
- **OWASP Category:** A3:2017 - Sensitive Data Exposure

### 8. **XML External Entity (XXE) (CWE-611)**
- **File:** `lib/parsers/xml_parser.dart`
- **Description:** XML parser allowing external entity references
- **OWASP Category:** A4:2017 - XML External Entities (XXE)

### 9. **Improper Input Validation (CWE-20)**
- **File:** `lib/validators/input_validator.dart`
- **Description:** Missing input validation leading to injection attacks
- **OWASP Category:** A1:2017 - Injection

### 10. **Insecure Deserialization (CWE-502)**
- **File:** `lib/utils/serialization_utils.dart`
- **Description:** Unsafe deserialization of user-controlled data
- **OWASP Category:** A8:2017 - Insecure Deserialization

---

## Testing Instructions

1. **Run Security Scanner** on this repository
2. **Expected Results:** Scanner should detect and flag all 10 vulnerabilities above  
3. **Validation:** Each vulnerability should be reported with appropriate severity
4. **Cleanup:** Remove all vulnerable files before production deployment

## Remediation Notes

Each vulnerability includes comments explaining the proper secure implementation to replace the vulnerable code.

---
*Created for security pipeline testing - Remove before production*
