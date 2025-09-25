# Agent Assets — Backlog

This file tracks the UX/UI modernization plan, assets, and related tasks for the Conference Agenda Tracker project. It is intended as a living backlog for agents and contributors to pick up work across sessions. Update task statuses, priorities, assignees, and branch names as you progress.

Conventions
- Priority: P0 (highest / blocking), P1 (high), P2 (medium), P3 (low/optional)
- Status: todo, in-progress, review, done, wont-do
- Branch: use the suggested branch name when creating a branch for the task
- Estimate: rough hours

## Epics / Milestones

- M1 — Material 3 theme + fonts
  - Branch: `feature/material-theme`
  - Goal: Add Material 3 ThemeData, fonts, and wire to `main.dart`.
  - Priority: P0
  - Status: done
  - Estimate: 1-2h
  - Completed: 2025-09-23 - Added `lib/theme/app_theme.dart` with Material 3 theme, integrated Google Fonts

- M2 — EventCard and list refactor
  - Branch: `feature/ui-refactor-eventcard`
  - Goal: Modernize `EventCard`, chips, spacing, and selection affordances.
  - Priority: P1
  - Status: done
  - Estimate: 1-3h
  - Completed: 2025-09-23 - Refactored `EventCard` with Material 3 design tokens, modernized typography

- M3 — Import screen hero + image assets
  - Branch: `feature/import-hero-image`
  - Goal: Add tasteful hero/background image, improve input layout, and declare assets.
  - Priority: P1
  - Status: done
  - Estimate: 1-2h (excluding sourcing)
  - Completed: 2025-09-23 - Added hero section with gradient and geometric pattern, fixed 28px overflow issue

- M4 — Icons & SVG assets
  - Branch: `feature/icons-and-assets`
  - Goal: Add `flutter_svg`, switch to SVG icons, standardize icon usage.
  - Priority: P1
  - Status: todo
  - Estimate: 1-2h

- M5 — CI Workflow
  - Branch: `feature/ci-workflow` (already created)
  - Goal: Add GitHub Actions to run `flutter analyze` and tests on PRs.
  - Priority: P1
  - Status: done
  - Estimate: 0.5-1h
  - Completed: 2025-09-23 - Added `.github/workflows/flutter.yml` with Flutter analysis and testing

- M6 — Optimize screenshots / assets
  - Branch: `feature/optimize-screenshots` (already created)
  - Goal: Compress/resize current screenshots, replace large files, and reduce repo size.
  - Priority: P2
  - Status: todo
  - Estimate: 0.5-1h

- M7 — UX Improvements Phase 1 (Smart Views)
  - Branch: `feature/ux-improvements-smart-views`
  - Goal: Improve splash screen timing, implement smart day grouping, and time-based filtering
  - Priority: P1
  - Status: done
  - Estimate: 2-3h
  - Completed: 2025-09-24 - Fixed splash screen timing, added smart day grouping with visual indicators, implemented time-based filtering for current/future/past events

- M8 — Event Insights Dashboard
  - Branch: `feature/event-insights-dashboard`
  - Goal: Create insights tab showing time per topic, frequent words in titles, event statistics
  - Priority: P2
  - Status: todo
  - Estimate: 3-4h

- M9 — AI Talk Proposal Generator
  - Branch: `feature/ai-talk-generator`
  - Goal: Fun tab for AI-generated fake event talk proposals with user name input based on event data
  - Priority: P3
  - Status: done
  - Estimate: 2-3h
  - Completed: 2025-09-24 - Created AI Talk Proposal Generator with creative title/abstract generation

- M10 — Speaker Data Integration
  - Branch: `feature/speaker-data-integration`
  - Goal: Extract and display speaker information from ICS files, add sorting by author
  - Priority: P1
  - Status: todo
  - Estimate: 2-3h

- M11 — Import Screen UI Polish
  - Branch: `feature/import-ui-polish`
  - Goal: Improve import calendar screen layout, center elements, enhance professional appearance
  - Priority: P2
  - Status: todo
  - Estimate: 1-2h

- M12 — Fun Tab Enhancements
  - Branch: `feature/fun-tab-enhancements`
  - Goal: Rebrand AI Generator as "Fun" tab, add AI product name generator
  - Priority: P3
  - Status: todo
  - Estimate: 2-3h


## Task Backlog (detailed)

### P0
- M1 — Add Material 3 theme and fonts
  - Status: todo
  - Branch: `feature/material-theme`
  - Steps:
    1. Add packages: `google_fonts`, `flutter_svg` (optional now), `material_color_utilities` (optional)
    2. Create `lib/theme/app_theme.dart` and export light/dark ThemeData using `useMaterial3: true`.
    3. Wire `main.dart` to use the new theme and disable debug banner.
    4. Sanity check on iOS simulator.
  - Notes: keep PR focused — no asset changes in this PR.

### P1
- M10 — Speaker Data Integration  
  - Status: todo
  - Branch: `feature/speaker-data-integration`
  - Steps:
    1. Update calendar_service.dart to extract speaker/organizer data from ICS files
    2. Add speaker field to CalendarEvent model 
    3. Update EventCard to display speaker information when available
    4. Add "Sort by Author/Speaker" option to events list dropdown
    5. Update filtering logic to include speaker data in search
  - Notes: Look for ORGANIZER and ATTENDEE fields in ICS parsing, handle multiple speakers gracefully

- M2 — Modernize `EventCard` and event list
  - Status: todo
  - Branch: `feature/ui-refactor-eventcard`
  - Steps:
    1. Convert current event row to a Material Card with consistent padding and typography.
    2. Use `Wrap` for chips, `Expanded` for long text, and tonal colors from theme.
    3. Add small unit/widget test(s) for rendering.

- M3 — Import screen hero and layout polish
  - Status: todo
  - Branch: `feature/import-hero-image`
  - Steps:
    1. Source 1-2 permissively-licensed hero images (Unsplash/Pexels) and add to `assets/images/`.
    2. Update `pubspec.yaml` to include assets.
    3. Replace import screen top area with a banner + subtle overlay and better form spacing.
    4. Add `ASSETS_LICENSES.md` documenting attribution and license URLs.

- M4 — Add/standardize icons (SVG)
  - Status: todo
  - Branch: `feature/icons-and-assets`
  - Steps:
    1. Add `flutter_svg` to `pubspec.yaml`.
    2. Replace custom image icons with SVG where applicable (e.g., import, search, chips).
    3. Ensure fallback to `Icons.*` or a simple asset for devices that can't load SVG.

- M5 — CI workflow (PR checks)
  - Status: todo
  - Branch: `feature/ci-workflow` (exists)
  - Steps:
    1. Add `.github/workflows/flutter.yml` to run `flutter analyze` and `flutter test` on PRs.
    2. Ensure environment uses a matching Flutter SDK or uses `subosito/flutter-action` pinned version.

### P2
- M6 — Optimize/compress screenshots
  - Status: todo
  - Branch: `feature/optimize-screenshots` (exists)
  - Steps:
    1. Create optimized versions (WebP or compressed JPEG) and replace files.
    2. Optionally keep originals in a separate offline archive if desired.

- Add CONTRIBUTING.md
  - Status: todo
  - Branch: `feature/add-contributing` (exists)
  - Steps:
    1. Add `CONTRIBUTING.md` with setup, coding style, and PR process.

### P0 (Critical)
- M18 — Core CI/Testing Foundation
  - Status: todo
  - Branch: `feature/core-ci-testing`
  - Steps:
    1. Enhanced GitHub Actions workflow with comprehensive Flutter testing
    2. Unit tests for CalendarEvent, EventProvider, CalendarService
    3. Widget tests for EventCard, all screen components  
    4. Code coverage reporting with lcov output
    5. Test report generation in `test_reports/` directory with agent-readable format
    6. Failed test instructions in `AGENT_FEEDBACK.md` for human-to-agent communication
    7. Build verification for iOS/Android on multiple Flutter versions
  - Notes: Test reports must be parseable by agents for automated fixes

### P1 (High Priority)  
- M19 — UI/UX Testing Suite
  - Status: todo
  - Branch: `feature/ui-ux-testing`
  - Steps:
    1. Golden tests for all screens to detect UI regressions
    2. Integration tests for complete user flows (import → filter → select → generate)
    3. Accessibility testing with semantic labels and screen reader compatibility
    4. Cross-screen navigation tests ensuring tab functionality
    5. Performance tests for large calendar imports (1000+ events)
    6. Error state testing for network failures and invalid files
  - Notes: Generate visual diff reports when golden tests fail

### P2
- M20 — Advanced Testing & Automation
  - Status: todo
  - Branch: `feature/advanced-testing`
  - Steps:
    1. Automated iOS/Android build verification on multiple devices
    2. Memory leak detection and performance profiling
    3. TestFlight automation for beta distribution
    4. App Store compliance validation (metadata, icons, privacy)
    5. Load testing with various calendar sizes and formats
    6. Security testing automation for injected vulnerabilities
  - Notes: Full deployment pipeline with rollback capabilities

- M11 — Import Screen UI Polish
  - Status: todo
  - Branch: `feature/import-ui-polish`
  - Steps:
    1. Redesign import_calendar_screen.dart layout for better visual hierarchy
    2. Center the calendar icon and "Import Calendar" text properly  
    3. Improve spacing and alignment of all UI elements
    4. Add subtle animations or micro-interactions for professional feel
    5. Consider replacing hero section with cleaner, more focused design
  - Notes: Focus on professional appearance while maintaining Material 3 consistency

- M8 — Event Insights Dashboard
  - Status: todo
  - Branch: `feature/event-insights-dashboard`
  - Steps:
    1. Create new insights screen/tab showing event statistics
    2. Implement time per topic analysis (duration calculations)
    3. Add frequent words analysis from event titles/descriptions
    4. Create visualizations (charts/graphs) using Flutter charts library
    5. Add export functionality for insights data
  - Notes: Consider using fl_chart package for visualizations

- M13 — Enhanced Insights & Visualizations
  - Branch: `feature/enhanced-insights`
  - Goal: Improve data visualization with word heatmaps, better charts, and more explorable analytics
  - Priority: P1
  - Status: done
  - Estimate: 3-4h
  - Completed: 2025-09-24 - Added interactive topic cloud with tap-to-explore, 24-hour schedule heatmap

- M14 — Calendar Export Integration
  - Branch: `feature/calendar-export`
  - Goal: Export selected events to Google Calendar and Apple Calendar
  - Priority: P1  
  - Status: todo
  - Estimate: 4-5h
  - Steps:
    1. Add calendar export packages (google_calendar_api, add_2_calendar)
    2. Create export service for generating ICS files from selected events
    3. Add "Export to Calendar" button in My Agenda screen
    4. Implement Google Calendar API integration for direct export
    5. Add iOS calendar integration using EventKit
    6. Handle authentication and permissions gracefully

- M15 — App Bar & Branding Polish
  - Branch: `feature/appbar-branding`
  - Goal: Add TPE logo to app bar, improve title styling, enhance overall branding
  - Priority: P2
  - Status: todo
  - Estimate: 1-2h

- M16 — Event Card UX Enhancements
  - Branch: `feature/event-card-ux`
  - Goal: Add live event indicators, time-until-event display, swipe actions
  - Priority: P2
  - Status: todo
  - Estimate: 2-3h

- M17 — Micro-Interactions & Polish
  - Branch: `feature/micro-interactions`
  - Goal: Add pull-to-refresh, loading skeletons, button animations, haptic feedback
  - Priority: P3
  - Status: todo
  - Estimate: 2-3h

- M18 — Core CI/Testing Foundation
  - Branch: `feature/core-ci-testing`
  - Goal: Implement regression testing fundamentals with agent-readable reports
  - Priority: P0
  - Status: todo
  - Estimate: 3-4h

- M19 — UI/UX Testing Suite
  - Branch: `feature/ui-ux-testing`
  - Goal: Golden tests, integration tests, and accessibility validation
  - Priority: P1
  - Status: todo
  - Estimate: 4-5h

- M20 — Advanced Testing & Automation
  - Branch: `feature/advanced-testing`
  - Goal: Performance testing, cross-device validation, automated deployments
  - Priority: P2
  - Status: todo
  - Estimate: 5-6h

### P3 / Future ideas
- M12 — Fun Tab Enhancements
  - Status: done
  - Branch: `feature/fun-tab-enhancements`
  - Completed: 2025-09-24 - Rebranded to Fun tab, added AI product name generator
  - Steps:
    1. Rename "AI Generator" tab to "Fun" in navigation and screen titles
    2. Update tab icon from auto_awesome to something more fun (e.g., sports_esports)
    3. Add AI Product Name Generator section to the Fun tab
    4. Analyze event descriptions to extract problem statements and topics
    5. Generate creative product names based on identified problems/solutions
    6. Include product tagline generation with the product names
    7. Add sharing/copy functionality for generated product ideas
  - Notes: Make product generator feel like a separate "tool" within the Fun tab alongside talk generator

- M9 — AI Talk Proposal Generator
  - Status: todo
  - Branch: `feature/ai-talk-generator`
  - Steps:
    1. Analyze existing event data to determine themes/topics
    2. Create AI-powered title generator based on patterns
    3. Add user input form for name and preferences
    4. Implement fun, professional-looking proposal generator UI
    5. Add sharing/export functionality for generated proposals
  - Notes: Use simple text generation algorithms or consider integrating with AI APIs

- Dark mode polish and dynamic color extraction (Material You) — P3
- Sticky day headers in event list, timeline view — P3
- Pagination/virtual list for very large calendars — P3
- Export selected agenda to ICS or shareable PDF — P3


## How to use this file (for agents)
- Pick a task, create a branch using the `Branch` name field (or a short variation), and set the `Status` to `in-progress`.
- Commit small focused changes, push the branch, and open a draft PR describing the goal and linking this backlog item.
- When the PR is ready, set the item `Status` to `review` and add the PR URL under the task.
- When the PR merges, set `Status: done` and add the merge commit or PR link.


## Recent activity
- 2025-09-24: Completed M7-M9 UX improvements. Added M10-M12 for speaker data, import UI polish, and Fun tab enhancements.
- 2025-09-24: Added UX improvements phase 1 - smart views, day grouping, and time-based filtering. Added M8 (Event Insights) and M9 (AI Talk Generator) to roadmap.
- 2025-09-23: Created backlog and initial branches: `feature/optimize-screenshots`, `feature/add-contributing`, `feature/ci-workflow`.

---
*This backlog is intentionally lightweight and agent-friendly — update as you go.*
