# EventFlow Security Documentation

## Security Posture

EventFlow implements defense-in-depth security for a mobile calendar app:
- ✅ **Input validation** on all external data
- ✅ **Network security** with HTTPS-only and private IP blocking
- ✅ **Automated scanning** via CI/CD pipeline
- ✅ **Privacy-first** design with local-only data storage
- ✅ **Secure defaults** across iOS and Android

---

## OWASP Mobile Top 10 Coverage

### M1: Improper Platform Usage ✅
- **iOS:** Minimal permissions (photo library only for ICS import)
- **Android:** No dangerous permissions requested
- **File access:** Scoped storage via file_picker plugin
- **Compliance:** Privacy manifests for all SDKs

### M2: Insecure Data Storage ✅
- **Local only:** SharedPreferences for non-sensitive event data
- **No cloud sync:** All data stays on device
- **Android:** Backup disabled (`allowBackup="false"`)
- **iOS:** Encrypted by default via iOS file system
- **Future:** Optional encryption for sensitive calendars

### M3: Insecure Communication ✅
- **HTTPS enforced:** HTTP URLs rejected with security error
- **webcal:// converted** to https://
- **Content-Type validation:** Only text/calendar or text/plain accepted
- **Cleartext disabled:** Android `usesCleartextTraffic="false"`
- **No ATS exceptions:** iOS App Transport Security fully enforced

### M4: Insecure Authentication N/A
- No user authentication required
- No API keys or tokens stored

### M5: Insufficient Cryptography ✅
- Platform-provided encryption (iOS file system, Android app sandbox)
- No custom crypto implementations

### M6: Insecure Authorization N/A
- Single-user app with no authorization model

### M7: Client Code Quality ✅
- **Static analysis:** `flutter analyze` with strict linting
- **Input validation:** All user inputs sanitized
- **Error handling:** Comprehensive error tests
- **Memory safety:** Dart's garbage collection

### M8: Code Tampering ⚠️
- **iOS:** App Store signature verification
- **Android:** APK signing required
- **Future consideration:** Root/jailbreak detection if needed

### M9: Reverse Engineering ⚠️
- **Obfuscation:** Available for release builds
- **Split debug info:** Symbols separated from release
- **No hardcoded secrets:** Environment-based configuration

### M10: Extraneous Functionality ✅
- No debug features in production
- No backdoors or test accounts
- Minimal permissions requested

---

## Security Controls Implemented

### Input Validation

#### ICS File Parsing
```dart
// Format validation
- Must start with "BEGIN:VCALENDAR"
- Maximum 1000 events per calendar
- Title length: max 500 characters
- Description length: max 10,000 characters
```

#### URL Import Security
```dart
// Blocked hosts/IPs
- localhost, 127.0.0.1, ::1
- Private IPv4: 10.x.x.x, 172.16-31.x.x, 192.168.x.x
- Link-local IPv6: fe80::, fc00::/7, fd00::/8

// Protocol enforcement
- Only HTTPS allowed
- HTTP returns security error
- webcal:// auto-converted to https://

// Request hardening
- Accept: text/calendar header
- 30-second timeout
- Post-redirect HTTPS verification
- Content-Type validation
```

#### File Picker
```dart
// Restrictions
- FileType.custom with allowedExtensions: ['ics']
- No photo library access for ICS imports
- Single file selection only
```

### Network Security

#### iOS (Info.plist)
- App Transport Security (ATS) fully enforced
- No NSAllowsArbitraryLoads exceptions
- HTTPS-only by default

#### Android (AndroidManifest.xml)
```xml
<application
    android:usesCleartextTraffic="false"
    android:allowBackup="false"
    ...>
```

### Data Protection

#### Storage
- **Location:** Device local only (SharedPreferences)
- **Android:** No ADB backup (`allowBackup="false"`)
- **iOS:** iOS file encryption by default
- **Scope:** Event metadata only (no raw ICS persistence)

#### Privacy
- No external data transmission
- No analytics or tracking
- No user accounts or PII collection
- Privacy manifests for all third-party SDKs

---

## Automated Security Scanning

### CI/CD Pipeline (`.github/workflows/security.yml`)

#### Dependency Scanning
- **OSV-Scanner:** Checks pubspec.lock for known CVEs
- **Runs:** On every push, PR, and weekly
- **Action:** Fails build on critical vulnerabilities

#### Secret Detection
- **Gitleaks:** Scans for accidentally committed secrets
- **Runs:** On every push
- **Prevents:** API keys, passwords, tokens in commits

#### Static Analysis
- **Semgrep:** Dart and mobile security rules
- **mobsfscan:** Android/iOS config security checks
- **Runs:** On every push/PR
- **Detects:** Code patterns, misconfigurations

#### Manual Testing
See `TEST_SUMMARY.md` for:
- Input fuzzing tests
- Error handling validation
- Edge case coverage

---

## Development Security Practices

### Secrets Management
```bash
# .env file (gitignored)
APPLE_ID=user@example.com
APPLE_APP_SPECIFIC_PASSWORD=xxxx-xxxx-xxxx-xxxx

# Never commit secrets
# .gitignore includes: .env, .env.*, *.keystore, *.p12
```

### Secure Build Process
```bash
# Development (debug)
flutter build ios

# Production (release with obfuscation)
flutter build ios --release \
  --obfuscate \
  --split-debug-info=build/symbols

# Keep symbols for crash reporting
tar -czf symbols-v1.0.0-build6.tar.gz build/symbols/
```

### Dependency Updates
- Review release notes before updating
- Test thoroughly after major version bumps
- Use `flutter pub outdated` to check for updates
- **Recommended:** Enable Renovate bot for automated PRs

---

## Security Testing

### Test Categories
1. **Error Handling** - Malformed ICS, invalid URLs, network failures
2. **Input Validation** - Special characters, oversized fields, format issues
3. **Edge Cases** - Timezones, DST, duplicates, boundaries
4. **Performance** - 1000+ events, DoS resistance

### Running Security Tests
```bash
# All tests
flutter test

# Security-specific
flutter test test/unit/calendar_service_error_handling_test.dart
flutter test test/unit/edge_cases_test.dart

# With coverage
flutter test --coverage
```

---

## Incident Response

### Vulnerability Disclosure
- **Contact:** [Your security email]
- **Response time:** 48-72 hours
- **Process:** Acknowledge → Assess → Patch → Disclose

### Update Process
1. Security patch developed in private branch
2. Tests added for vulnerability
3. Emergency release with incremented build number
4. Expedited App Store review requested
5. User notification via App Store update notes

---

## Future Security Enhancements

### If Handling Sensitive Data
- Implement flutter_secure_storage for encryption
- Add biometric lock option
- Implement data-at-rest encryption
- Add app-level PIN/password

### Enterprise Considerations
- Certificate pinning for known calendar hosts
- Domain allowlist configuration
- MDM integration for enterprise deployment
- Advanced threat detection (jailbreak/root)

### Advanced Testing
- Dynamic analysis with MobSF
- Penetration testing
- OWASP MASVS-L1 compliance validation
- Fuzz testing with malformed ICS corpus

---

## Security Checklist for Releases

- [ ] All dependencies up-to-date
- [ ] No secrets in code/commits (Gitleaks passed)
- [ ] Security scans passed (OSV, mobsfscan, Semgrep)
- [ ] All tests passing (including error handling)
- [ ] Release build uses obfuscation
- [ ] Privacy manifests present for all SDKs
- [ ] App Store privacy labels accurate
- [ ] Symbols archived for crash reporting

---

## Contact & Resources

**Security Contact:** [Your email]  
**Privacy Policy:** See `agent_assets/privacy-policy.md`  
**Bug Bounty:** Not currently offered  

**External Resources:**
- [OWASP Mobile Security Testing Guide](https://mas.owasp.org/MASTG/)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)
- [Apple Security Guide](https://support.apple.com/guide/security/welcome/web)
- [Android Security](https://source.android.com/docs/security)

---

*Last Updated: October 18, 2025*  
*Version: 1.0.0+6*
