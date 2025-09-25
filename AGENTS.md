# AGENTS.md - Development Guide for EventFlow

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
5. **Human-in-the-loop testing**: Deploy each completed feature to iPhone for testing before moving to next feature
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
- **Human-in-the-loop testing**: Deploy each feature to iPhone for real-world validation
- **CRITICAL: No feature is complete unless CI tests pass** - Run GitHub Actions locally before pushing
- **GitHub Actions locally**: Use `act` or run test commands before pushing
- Run tests with: `flutter test`

## Development Commands

### Build & Run
```bash
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
- **Verify Readiness:** `./scripts/validate_handoff.sh`
- **Quick Wins:** `agent_assets/quick-wins.md` (momentum building)
- **Current Issues:** `AGENT_FEEDBACK.md` (specific failures to fix)

---

*This file should be updated as the project evolves. When adding major features or changing architecture, update this guide accordingly.*
