---
ai.include_by_default: false
ai.weight: 0.1
---

# AGENTS.md - Development Guide for EventFlow

> **⚠️ DEPRECATION NOTICE**: This file has been restructured for better agent context management.  
> **Use AGENTS_TLDR.md instead** for agent handoffs and current context.  
> **See agents/README.md** for the new documentation structure.  
> This file is kept for reference only.

---

This file provides comprehensive guidance for AI agents working on EventFlow. **CRITICAL**: We are currently building a mission-critical automated CI/CD pipeline from agent interaction to App Store publication.

## Project Overview

**App Name:** EventFlow  
**Company:** thephillipsequation llc  
**Platform:** Flutter (iOS/Android)  
**Purpose:** Conference agenda management with smart filtering, insights, AI-powered features, and modern Material 3 UI
**Development Story:** Built in 36 hours using Amp AI - now expanding to full production automation

## 🚨 **CURRENT MISSION-CRITICAL FOCUS**

**Target State**: Complete automation pipeline from agent changes to App Store publication while waiting for Apple Developer Account approval.

**Current Priority**: **M21-M24** - Automated CI/CD pipeline (see backlog.md)

**Pipeline Vision**:
```
Agent Changes → Local Testing → GitHub Actions → iOS Build → TestFlight → App Store
```

**Current Status**: 
- ✅ Basic CI/testing foundation implemented
- ⚠️ CI feedback loop needs full automation (M21)
- ⚠️ Test failures must be resolved (M22) 
- 🚧 iOS build automation needed (M23)
- 🚧 App Store Connect integration needed (M24)

## Backlog Management

### Process
1. **Always update the backlog first** when adding new features or improvements
2. **Check [`agent_assets/backlog.md`](agent_assets/backlog.md)** before starting any work
3. **Create separate branches** for each milestone/feature using suggested branch names
4. **Update task status** as you progress: `todo` → `in-progress` → `review` → `done`
5. **Human-in-the-loop testing**: Deploy each completed feature to iPhone for testing before moving to next feature using `flutter run --release -d "00008140-0002248A0E12801C"`
6. **CRITICAL: No feature is complete unless CI tests pass** - Run GitHub Actions locally before pushing
7. **Add completion notes** with date and key changes when marking items `done`

### Priority Levels
- **P0:** Blocking/critical issues
- **P1:** High priority features 
- **P2:** Medium priority improvements
- **P3:** Low priority/future ideas

### Branch Naming Convention
Use the branch names suggested in backlog.md, e.g.:
- `feature/event-insights-dashboard`
- `feature/ai-talk-generator` 
- `fix/splash-screen-timing`

## Design Principles

### Material 3 First
- **Always use Material 3** design tokens and components (`useMaterial3: true`)
- **Leverage theme colors** from `lib/theme/app_theme.dart`
- **Use semantic color roles:** `primary`, `secondary`, `surface`, `onSurface`, etc.
- **Prefer Cards over Containers** for elevated surfaces
- **Use proper elevation** and surface tints

### Typography & Spacing
- **Google Fonts** (Roboto) for consistency
- **Material 3 typography** scale: `headlineMedium`, `bodyLarge`, `labelSmall`, etc.
- **Consistent spacing** using multiples of 8px: `8, 16, 24, 32`
- **Proper text contrast** using theme's `onSurface`, `onPrimary` colors

### User Experience Patterns
- **Smart defaults:** Show upcoming events by default, collapse past events
- **Visual hierarchy:** Use color-coded day headers (today/past/future)
- **Time-aware filtering:** Filter by upcoming/all/past events with device timezone
- **Day-grouped views:** Group events by day with clear visual separation
- **Contextual information:** Show event counts, time indicators, priority chips
- **Interactive analytics:** Tap-to-explore topic clouds and schedule heatmaps
- **Expandable content:** "More" buttons for long descriptions with popup details
- **Speaker integration:** Display speakers with person icons when available
- **AI-powered engagement:** Context-aware generators using actual event data

### Component Design
- **Consistent EventCard** design across all screens
- **Chips for metadata:** Priority, duration, selection status
- **Responsive layouts:** Handle text overflow, different screen sizes  
- **Accessibility:** Proper semantic labels, color contrast
- **Loading states:** Graceful empty states with helpful messaging

## Code Style & Architecture

### File Organization
```
lib/
├── models/          # Data models (CalendarEvent, etc.)
├── providers/       # State management (EventProvider)
├── screens/         # Full-screen UI components
├── services/        # External integrations (calendar import)
├── theme/           # App theme and styling
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

### State Management
- **Provider pattern** for global state
- **StatefulWidget** for local state
- **Consumer<EventProvider>** for reactive UI updates

### Error Handling
- **Graceful fallbacks** for missing assets/data
- **User-friendly error messages**
- **errorBuilder** for image loading failures

### Testing Strategy
- **Widget tests** for UI components
- **Unit tests** for business logic
- **Integration tests** for key user flows
- **Human-in-the-loop testing**: Deploy each feature to iPhone for real-world validation using `flutter run --release -d "00008140-0002248A0E12801C"`
- **CRITICAL: No feature is complete unless CI tests pass** - Run GitHub Actions locally before pushing
- **GitHub Actions locally**: Use `act` or run test commands before pushing
- Run tests with: `flutter test`

### Version Management
- **Always update version** when completing features or fixes in `pubspec.yaml`
- **Semantic Versioning** (MAJOR.MINOR.PATCH+BUILD):
  - **MAJOR** (2.0.0): Breaking changes or major UI/architecture overhaul
  - **MINOR** (x.1.0): New features, backward compatible additions
  - **PATCH** (x.x.1): Bug fixes, small improvements
  - **BUILD** (+1): Increment for each build/release
- **Update as you go**: Version changes should be part of the feature PR/commit
- **Current version**: See `pubspec.yaml` line 4

### Pre-Commit Hooks & CI/CD Practices

**🚨 CRITICAL: Pre-commit hooks are MANDATORY quality gates**

- **NEVER bypass pre-commit hooks without asking first** (`--no-verify` is forbidden unless explicitly approved)
- **Always fix the actual errors** instead of bypassing validation
- **Agents MUST verify all checks pass** before confirming code changes work

#### Pre-Commit Hook Steps (`.git/hooks/pre-commit`)
1. **Code Formatting** (`dart format lib test`)
   - Auto-formats and stages changes
   - Ensures consistent style across codebase

2. **Static Analysis** (`flutter analyze --fatal-infos`)
   - Catches errors, warnings, deprecations
   - Enforces code quality standards

3. **Security Checks**
   - Blocks .env file commits (hard fail)
   - Warns on potential secrets in code (excluding docs)
   - Warns on debug print statements in production code
   - Reviews required for security-sensitive changes

4. **Test Suite** (`flutter test`)
   - Runs 75+ tests covering unit, integration, security
   - Must pass 100% before commit allowed
   - Includes error handling, edge cases, performance

5. **Build Verification** (`flutter build ios --debug --no-codesign`)
   - Non-blocking quick build check
   - Catches build-time issues early

#### If Pre-Commit Checks Fail
1. **Read error messages carefully** - they tell you exactly what's wrong
2. **Fix the actual issues** in the code - don't bypass
3. **Commit again** - hooks re-run automatically
4. **Agents:** Run checks manually if working on changes

#### Common Issues & Fixes
- **Format errors:** Run `dart format .`
- **Deprecation warnings:** Update to recommended API
- **Test failures:** Fix broken tests, add missing test coverage
- **Security warnings:** Remove debug code, check for secrets
- **Build failures:** Run `flutter clean && flutter pub get`

#### Why This Matters
- ✅ **Quality:** Maintains code quality across all commits
- 🚫 **Prevention:** Blocks broken code from repository
- 🔒 **Security:** Prevents secret leaks and vulnerabilities
- 🧪 **Testing:** Ensures all tests pass before deployment
- 📈 **Confidence:** Builds trust in automated deployments
- ⚡ **Speed:** Catches issues early when they're easiest to fix

#### For AI Agents Working on EventFlow
**Before saying "code change is complete" you MUST:**
1. Run `flutter analyze --fatal-infos` (zero errors/warnings)
2. Run `flutter test` (100% pass rate)
3. Run `flutter build ios --debug --no-codesign` (successful build)
4. Verify no secrets in changed files
5. Verify no debug print statements in production code

**Use this verification command:**
```bash
dart format . && \
flutter analyze --fatal-infos && \
flutter test && \
flutter build ios --debug --no-codesign
```

If ANY step fails, the code change is NOT complete.

## Development Commands

### Build & Run
```bash
# PREFERRED: Deploy to iPhone for wireless usage (human-in-the-loop testing)
flutter run --release -d "00008140-0002248A0E12801C"

# Run on device/simulator
flutter run

# Run on specific device
flutter run -d "device-id"

# Release build
flutter build ios --release
flutter build apk --release
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
dart format lib/ test/

# Get dependencies
flutter pub get

# Clean build
flutter clean
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart

# Generate coverage
flutter test --coverage

# CRITICAL: Run GitHub Actions locally before pushing
./scripts/run_ci_locally.sh

# Or run individual CI steps manually:
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
flutter test --coverage
flutter build ios --no-codesign --debug
flutter build apk --debug
```

### Asset Management
```bash
# Generate app icons
flutter pub run flutter_launcher_icons

# Generate splash screens  
flutter pub run flutter_native_splash:create
```

## App-Specific Context

### Current Features (Complete)
1. **Calendar Import:** ICS file import with validation, speaker extraction, timezone handling
2. **Event Management:** Selection, priority setting, advanced filtering, search with speakers
3. **Smart Views:** Time-based filtering (upcoming/past), visual day grouping with today/future indicators
4. **My Agenda:** Curated personal schedule view with time-aware filtering
5. **Interactive Analytics:** Topic clouds, 24-hour heatmaps, tap-to-explore insights
6. **AI-Powered Fun:** Talk proposal generator, product name generator, interactive conference bingo
7. **Professional UI:** Material 3 design, expandable cards, AM/PM timezone display

### Recent Major Additions
- **Speaker Data Integration:** Automatic extraction from ICS ORGANIZER/ATTENDEE fields
- **Interactive Insights:** Topic cloud with tap-to-explore, 24-hour schedule heatmap
- **Fun Tab:** Talk generator, product generator, interactive bingo with win detection
- **Enhanced UX:** Smart day grouping, time-based filtering, proper timezone handling
- **CI/Testing Foundation:** 17+ tests, GitHub Actions, agent feedback loops

### Data Model
- **CalendarEvent:** Core event data structure
- **Priority levels:** 1 (high), 2 (medium), 3 (low)
- **Time zones:** Handle local time conversion properly
- **Filtering:** By time (past/current/future), search terms, priority

### Navigation Structure
- **Tab-based navigation:** All Events, My Agenda, Import, (future: Insights)
- **Material 3 navigation bar**
- **Contextual actions:** Search, filter, sort

## Security & Privacy

### Data Handling
- **Local storage only** - no external data transmission
- **User consent** for calendar access
- **Privacy-first** approach - see `agent_assets/privacy-policy.md`

### Vulnerability Testing
- **Test vulnerabilities** are injected in separate files for security scanning
- **Never commit real secrets** or API keys
- **Use environment variables** for any external API integration

## Asset Guidelines

### Images & Icons
- **Optimize file sizes** - prefer WebP, compress images
- **Proper attribution** - document licenses in `ASSETS_LICENSES.md`
- **Consistent icon style** - Material Design icons preferred
- **App icon:** EventFlow branding with company logo

### Company Branding
- **thephillipsequation llc** for company attribution
- **EventFlow** as the app name
- **Logo:** `assets/images/tpe-logo.png`
- **Colors:** Follow Material 3 theme with brand integration

## Common Pitfalls & Solutions

### Flutter Specific
- **Hot reload limitations:** Restart app after theme/provider changes
- **Asset loading:** Always provide errorBuilder for images
- **State management:** Avoid calling Provider in initState
- **Screen overflow:** Use Expanded, Flexible for responsive layouts

### iOS Development
- **Code signing:** Use development certificates for testing
- **Bundle ID:** `com.joshua.eventflow` (test) or `com.thephillipsequation.eventflow` (production)
- **Provisioning:** Free accounts require weekly re-installation
- **Splash screen:** Native + Flutter splash coordination

### Material 3 Migration
- **Color scheme:** Use colorScheme properties, not deprecated colors
- **Components:** Prefer Material 3 components over custom implementations
- **Theming:** Apply theme consistently across all screens

## Future Roadmap

### Planned Features (See backlog.md)
- **Event Insights Dashboard:** Time analysis, frequent words, statistics
- **AI Talk Proposal Generator:** Fun AI-powered proposal creation
- **Advanced Filtering:** Category-based, speaker-based filters
- **Export Functionality:** ICS export, PDF reports

### Technical Debt
- **Performance:** Virtual scrolling for large calendars
- **Accessibility:** Screen reader optimization
- **Localization:** Multi-language support
- **Offline:** Improve offline experience

---

## Quick Reference

**🚨 MISSION CRITICAL FILES:**
- **Backlog:** `agent_assets/backlog.md` (M21-M24 priorities)
- **Current Status:** `agent_assets/current-status.md` (handoff info)
- **CI Feedback:** `AGENT_FEEDBACK.md` (current test failures)
- **Local CI:** `./scripts/run_ci_locally.sh` (run before pushing)

**🏗️ KEY APP FILES:**
- **Theme:** `lib/theme/app_theme.dart`  
- **Main Provider:** `lib/providers/event_provider.dart`  
- **Entry Point:** `lib/main.dart`
- **Screens:** `lib/screens/` (5 tabs all working)

**📱 DEPLOYMENT:**
- **Test Device:** `flutter run -d "00008140-0002248A0E12801C"`  
- **Build iOS:** `flutter build ios --release`  
- **Analyze:** `flutter analyze`
- **Test All:** `flutter test --coverage`

**🤖 CI/CD PIPELINE:**
- **GitHub Actions:** `.github/workflows/flutter.yml`
- **Webhook Server:** VS Code → Command Palette → "Start Webhook Server for Amp"
- **Auto Feedback:** `python3 scripts/auto_ci_feedback.py`

**🔍 HANDOFF VALIDATION:**
- **Verify Readiness:** `./scripts/validate_handoff.sh` (must show 99%+ before starting)
- **Quick Wins:** `agent_assets/quick-wins.md` (momentum building)
- **Current Issues:** `AGENT_FEEDBACK.md` (specific failures to fix)

**⚠️ CRITICAL**: Next agent must run `./scripts/validate_handoff.sh` FIRST - if it doesn't show 99%+ confidence, fix issues before starting work.

---

*This file should be updated as the project evolves. When adding major features or changing architecture, update this guide accordingly.*
