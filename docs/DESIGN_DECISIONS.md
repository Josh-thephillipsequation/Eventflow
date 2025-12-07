# EventFlow - Design Decisions & Architecture

**Date:** October 2025  
**Version:** 1.0.0  
**Team:** Built with Amp AI by thephillipsequation llc

---

## Executive Summary

EventFlow evolved from a 36-hour AI-assisted prototype to a production-ready App Store application through iterative design decisions prioritizing security, user experience, and maintainability.

**Key Architectural Pillars:**
1. **Privacy-first:** Local-only data with no cloud dependencies
2. **Material 3 native:** Modern Flutter UI with platform conventions
3. **Security-hardened:** OWASP Mobile Top 10 compliance
4. **Test-driven:** 75+ automated tests with CI/CD integration
5. **Performance-optimized:** Handles 1000+ events efficiently

---

## Core Design Decisions

### 1. Local-First Architecture

**Decision:** All data stored locally with no backend required

**Rationale:**
- **Privacy:** User calendar data never leaves device
- **Simplicity:** No server infrastructure, auth, or sync complexity
- **Reliability:** Works offline by default
- **Compliance:** Avoids GDPR/privacy regulations complexity

**Implementation:**
- `SharedPreferences` for event data (JSON serialization)
- File picker for ICS import (user-controlled access)
- No network calls except optional URL import

**Trade-offs:**
- ✅ Zero backend costs
- ✅ Maximum privacy
- ❌ No cross-device sync
- ❌ No collaborative features

**Future Considerations:**
- Optional iCloud/Google Drive backup
- Export to .ics for manual sync

---

### 2. Material 3 Design System

**Decision:** Full Material 3 adoption with semantic color tokens

**Rationale:**
- **Consistency:** Familiar iOS/Android platform patterns
- **Accessibility:** Built-in contrast, sizing, semantics
- **Theming:** Easy light/dark mode + custom themes
- **Future-proof:** Google's long-term design language

**Implementation:**
- `AppTheme.dart` with Material 3 color schemes
- Semantic tokens: `primary`, `surface`, `onSurface`
- Google Fonts (Roboto) for consistency
- Typography scale: `headlineMedium`, `bodyLarge`, etc.

**Alternative Considered:**
- Custom design system → Rejected (too much maintenance)
- Cupertino (iOS-only) → Rejected (platform inconsistency)

---

### 3. Security-First Development

**Decision:** Comprehensive security hardening from day one

**Rationale:**
- **App Store requirement:** Privacy manifest compliance
- **User trust:** Handle calendar data responsibly
- **Best practices:** OWASP Mobile Top 10 compliance
- **Future-proof:** Enterprise-ready architecture

**Key Security Features:**

#### Input Validation
- ICS format enforcement (must start with "BEGIN:VCALENDAR")
- Event count limits (max 1000 per calendar)
- Field length caps (title: 500, description: 10k chars)
- File type restrictions (.ics only)

#### Network Security
- HTTPS-only enforcement (HTTP blocked with security error)
- Private IP blocking (prevents SSRF attacks)
- Content-Type validation (text/calendar or text/plain)
- 30-second request timeouts
- Post-redirect HTTPS verification

#### Platform Hardening
- **Android:** `usesCleartextTraffic="false"`, `allowBackup="false"`
- **iOS:** App Transport Security enforced (no exceptions)
- **Build:** Obfuscation available for release builds

#### Automated Scanning
- OSV-Scanner (dependency CVEs)
- Gitleaks (secret detection)
- Semgrep (static analysis)
- mobsfscan (mobile config audit)

**See:** [SECURITY.md](file:///Users/presto/Documents/conference_agenda_tracker/SECURITY.md) for complete details

---

### 4. Test-Driven Quality

**Decision:** Comprehensive test suite before App Store submission

**Rationale:**
- **Reliability:** Catch regressions before users do
- **Confidence:** Deploy without manual QA bottlenecks
- **Documentation:** Tests explain expected behavior
- **Refactoring safety:** Change code with confidence

**Test Strategy:**

#### Coverage Breakdown
- **Unit Tests:** Core logic (models, services, providers)
- **Widget Tests:** UI components (cards, screens)
- **Integration Tests:** End-to-end user flows
- **Security Tests:** Error handling, edge cases
- **Performance Tests:** 1000+ event scalability

#### Test Metrics
- 75+ tests (50% increase from baseline)
- 41% code coverage (improving toward 80% target)
- 100% critical path coverage
- Performance benchmarks: <1s for 1000 events

**See:** [TEST_SUMMARY.md](file:///Users/presto/Documents/conference_agenda_tracker/TEST_SUMMARY.md)

---

### 5. State Management with Provider

**Decision:** Use Provider pattern over alternatives

**Rationale:**
- **Simplicity:** Minimal boilerplate vs Bloc/Riverpod
- **Official:** Recommended by Flutter team
- **Sufficient:** App complexity doesn't justify heavier solutions
- **Learning curve:** Easy for contributors to understand

**Architecture:**
```
EventProvider (ChangeNotifier)
├── Event loading (file/URL/asset)
├── Selection management
├── Priority management
└── Persistence (via StorageService)
```

**Alternatives Considered:**
- Bloc → Too much boilerplate for this use case
- Riverpod → Overkill for simple state
- GetX → Non-standard, magical

---

### 6. Smart UX Defaults

**Decision:** Intelligent filtering and grouping by default

**Key Features:**
- **Time-aware filtering:** Show upcoming events first, collapse past
- **Day grouping:** Visual separation with colored headers (today/past/future)
- **Smart sorting:** Priority within time groups
- **Expandable content:** "More" buttons for long descriptions

**Rationale:**
- Conference apps deal with time-sensitive content
- Users care most about "what's next"
- Visual hierarchy reduces cognitive load
- Progressive disclosure for dense information

**Implementation:**
- `EventProvider.filteredEvents` with time logic
- Day-based grouping in list screens
- Color-coded headers (green=today, blue=future, gray=past)

---

### 7. AI Features as "Fun Tab"

**Decision:** Isolate experimental AI features in dedicated tab

**Features:**
- Talk proposal generator
- Product name generator
- Conference bingo (interactive game)

**Rationale:**
- **Delight:** Add personality beyond pure utility
- **Experimentation:** Safe space for creative features
- **Isolation:** Core app works without AI dependencies
- **Future:** Foundation for AI-powered recommendations

**Design Philosophy:**
- Use conference context (real topics/speakers)
- Keep it lighthearted and engaging
- No external API calls (privacy maintained)
- Entirely optional (doesn't gate core features)

---

### 8. iPhone-Only Initial Launch

**Decision:** Launch on iPhone only, defer iPad

**Rationale:**
- **Focus:** Perfect one form factor before scaling
- **Resources:** Smaller screenshot/testing surface area
- **Market:** Conferences are mobile-first experiences
- **Iteration speed:** Faster initial release

**Implementation:**
- `UIDeviceFamily` = [1] (iPhone only)
- Portrait-primary orientation
- Optimized for 6.5" and 6.7" iPhone displays

**Future:**
- iPad support with adapted layouts
- Landscape optimization
- Multi-column tablet views

---

### 9. Dependency Management

**Decision:** Conservative dependency strategy with security focus

**Guidelines:**
- Prefer official Flutter packages
- Verify package maintenance (last update <6 months)
- Check package popularity (pub.dev score)
- Review breaking changes before major updates
- Privacy manifest compliance for all SDKs

**Major Dependencies:**
```yaml
file_picker: ^10.3.3     # Privacy manifest compliant
icalendar_parser: ^2.1.0 # Mature ICS parsing
provider: ^6.1.1         # Official state management
google_fonts: ^6.3.1     # Typography
shared_preferences: ^2.3.4 # Local storage
```

**Update Strategy:**
- Monitor with `flutter pub outdated`
- Security updates applied immediately
- Feature updates reviewed and tested
- Consider Renovate bot for automation

---

### 10. Build & Release Pipeline

**Decision:** Automated quality gates from code to App Store

**Pipeline Stages:**

#### Local Development
```
Code Change → Pre-commit Hooks → Tests Pass → Commit
```

#### CI/CD (GitHub Actions)
```
Push → Format Check → Analysis → Tests → Security Scans → Build
```

#### Release Process
```
Version Bump → Secure Build → Test on Device → Upload → App Store
```

**Pre-Commit Hooks:**
1. Format check
2. Static analysis
3. Security validation (secrets, debug code)
4. Full test suite (75+ tests)
5. Build verification

**CI Security Scans:**
- OSV-Scanner (dependencies)
- Gitleaks (secrets)
- Semgrep (code patterns)
- mobsfscan (mobile configs)

**Release Build:**
```bash
./scripts/build_release_secure.sh
# Includes: obfuscation, split debug symbols, signing
```

---

## Technical Decisions

### Why Flutter?
- **Cross-platform:** iOS + Android from single codebase
- **Performance:** Native compilation, 60fps
- **Material 3:** Built-in design system
- **Hot reload:** Rapid iteration
- **Community:** Strong package ecosystem

### Why ICS Format?
- **Universal:** Standard calendar format
- **Interoperability:** Works with all calendar apps
- **Rich metadata:** Speakers, locations, descriptions
- **Human-readable:** Easy to debug and validate

### Why SharedPreferences?
- **Simplicity:** Key-value storage built into Flutter
- **Performance:** Fast read/write for JSON data
- **Platform-native:** Uses UserDefaults (iOS) / SharedPreferences (Android)
- **Sufficient:** Event metadata is non-sensitive

**When to upgrade:**
- Sensitive PII (attendee emails) → Use `flutter_secure_storage`
- Large data (>1MB) → Consider SQLite/Hive
- Complex queries → Use embedded database

---

## UX Design Decisions

### Color-Coded Day Headers
- **Today:** Green (emphasizes immediacy)
- **Future:** Blue (calm, informational)
- **Past:** Gray (de-emphasized)

### Priority System
- **1-3 scale:** High/Medium/Low (simple mental model)
- **Visual indicators:** Color-coded chips
- **Smart defaults:** Medium (3) for new events

### Event Card Design
- **Compact:** Show key info at a glance
- **Expandable:** "More" button for full description
- **Icons:** Clock (time), pin (location), person (speaker)
- **Chips:** Priority, duration, selection status

### Navigation
- **Bottom tabs:** 4 main sections (All Events, My Agenda, Import, Fun)
- **Material 3 nav bar:** Platform-standard interaction
- **Contextual actions:** Search/filter in app bar

---

## Performance Decisions

### List Rendering
- **Current:** Standard ListView.builder
- **Scalability:** Tested to 1000 events
- **Future:** Virtual scrolling if >5000 events needed

### State Management
- **Reactive updates:** Provider notifyListeners()
- **Efficient filtering:** In-memory operations
- **Lazy loading:** Events loaded on demand

### Asset Optimization
- **Images:** WebP with compression
- **Icons:** Material Icons (built-in)
- **Fonts:** Google Fonts with caching

---

## Development Journey Timeline

### Phase 1: MVP (36 hours)
- Core event management
- ICS import
- Basic Material UI
- Tab navigation

### Phase 2: Polish (Week 1)
- Material 3 migration
- Smart filtering
- Speaker integration
- Insights/analytics

### Phase 3: AI Features (Week 2)
- Talk generator
- Product namer
- Conference bingo
- Interactive insights

### Phase 4: Production Hardening (Week 3)
- **Security:** OWASP compliance, input validation, network hardening
- **Testing:** 75+ tests, error handling, performance benchmarks
- **CI/CD:** Automated scanning, pre-commit hooks
- **Documentation:** Security policies, test summaries, this document

### Phase 5: App Store Launch (Week 4)
- Privacy manifests
- Screenshot generation
- iPhone-only configuration
- Build automation
- **Current stage:** Awaiting App Store approval

---

## Lessons Learned

### What Worked Well
1. **AI-assisted development** accelerated everything
2. **Material 3** provided solid foundation
3. **Local-first** simplified architecture dramatically
4. **Security early** prevented last-minute scrambles
5. **Pre-commit hooks** caught issues immediately

### What We'd Do Differently
1. Add comprehensive tests **earlier** (before MVP)
2. Security scanning from **day one** (not week 3)
3. iPad planning **upfront** (caused App Store friction)
4. Widget test strategy **clearer** (Material ancestor issues)

### Technical Debt Acknowledged
- Widget test coverage needs Material wrapper fixes
- Coverage at 41% (target: 80%)
- iPad support deferred but plist still includes it
- Obfuscation not yet in standard build flow

---

## Future Roadmap

### Near-Term (v1.1)
- iPad optimization
- Export to ICS
- Calendar widget (iOS 14+)
- Improved test coverage (80%+)

### Mid-Term (v1.5)
- Optional cloud backup
- Calendar subscriptions (live updates)
- Sharing/collaboration features
- Advanced AI recommendations

### Long-Term (v2.0)
- Multi-conference management
- Social features (attendee matching)
- Offline maps integration
- AR venue navigation

---

## Contributing Guidelines

### For AI Agents
1. **Always check AGENTS.md first**
2. **Run pre-commit verification** before confirming changes
3. **Update backlog.md** for new features
4. **Follow Material 3** design patterns
5. **Write tests** for new functionality
6. **Document decisions** in this file for major changes

### For Human Developers
1. Read `AGENTS.md` for development setup
2. Check `agent_assets/backlog.md` for priorities
3. Follow existing code conventions
4. Add tests for all new features
5. Update docs when changing architecture

---

## References

- **AGENTS.md:** Developer guide and conventions
- **SECURITY.md:** Security posture and OWASP compliance
- **TEST_SUMMARY.md:** Test strategy and coverage
- **agent_assets/backlog.md:** Feature roadmap
- **agent_assets/privacy-policy.md:** User-facing privacy commitment

---

*This document should be updated when making significant architectural changes or learning important lessons during development.*
