# Linear Migration Guide for EventFlow

This guide provides all backlog items formatted for easy import into Linear. Each issue includes title, description, priority, labels, and estimated effort.

## Setup Steps

1. **Create Linear Project:**
   - Project Name: "EventFlow"
   - Team: [Your Team]
   - Description: "Conference agenda management app with smart filtering, insights, and AI-powered features"

2. **Create Labels:**
   - `p0` - Mission Critical (red)
   - `p1` - High Priority (orange)
   - `p2` - Medium Priority (yellow)
   - `p3` - Nice to Have (gray)
   - `feature` - New feature (blue)
   - `bug` - Bug fix (red)
   - `infrastructure` - Infrastructure/DevOps (purple)
   - `ui` - UI/UX (green)
   - `ai` - AI features (pink)

3. **Link GitHub Repository:**
   - Settings → Integrations → GitHub
   - Connect repository: `Josh-thephillipsequation/Eventflow`

---

## Completed Milestones (Mark as Done)

These should be created and immediately marked as "Done" for historical reference:

### M1-M7: Core Foundation
**Title:** Core Foundation - Material 3 Theme & Event Management  
**Description:**
- Material 3 theme implementation
- EventCard refactor
- Smart views with time-based filtering
- Day grouping with visual indicators

**Labels:** `feature`, `ui`  
**Status:** Done

### M9: AI Talk Generator
**Title:** AI Talk Proposal Generator  
**Description:**
- AI-powered talk proposal generation
- Creative inspiration for conference submissions

**Labels:** `feature`, `ai`  
**Status:** Done

### M12: Fun Tab with Product Generator
**Title:** Fun Tab - Product Name Generator  
**Description:**
- Fun tab implementation
- AI-powered product name generator
- Interactive features

**Labels:** `feature`, `ai`  
**Status:** Done

### M13: Interactive Insights
**Title:** Interactive Analytics - Topic Cloud & Heatmap  
**Description:**
- Interactive topic cloud visualization
- 24-hour schedule heatmap
- Tap-to-explore insights

**Labels:** `feature`, `ui`  
**Status:** Done

---

## P0 - Mission Critical Issues

### M29: Sample Test Data System
**Title:** Sample Test Data System  
**Priority:** P0  
**Labels:** `p0`, `feature`, `ui`  
**Estimate:** 2-3 hours  
**Description:**
Pre-loaded demo conference data for easy app exploration. This will help users understand the app's capabilities without needing to import their own calendar files.

**Acceptance Criteria:**
- [ ] Realistic conference schedule with multiple days
- [ ] Include speakers for events
- [ ] Variety of topics and locations
- [ ] Mix of event types (talks, workshops, breaks)
- [ ] Accessible from Settings or first-time user flow
- [ ] Clear indication that it's sample data

**Technical Notes:**
- Use existing ICS file format
- Store in assets or generate programmatically
- Include at least 20-30 events
- Cover multiple days

**Branch:** `feature/sample-test-data`

---

### M30: First-Time User Tutorial
**Title:** First-Time User Tutorial / Onboarding  
**Priority:** P0  
**Labels:** `p0`, `feature`, `ui`  
**Estimate:** 3-4 hours  
**Description:**
Interactive walkthrough when app opens for first time. Guide users through key features and how to use the app effectively.

**Acceptance Criteria:**
- [ ] Shows on first app launch only
- [ ] Highlights key features:
  - How to import calendar
  - How to filter events
  - How to use AI tools
  - How to build personal agenda
- [ ] Skip option available
- [ ] Can be accessed again from Settings
- [ ] Smooth animations and transitions

**Technical Notes:**
- Use overlay/tooltip system
- Track first launch in SharedPreferences
- Material 3 design consistent with app

**Branch:** `feature/onboarding-tutorial`

---

## P1 - High Priority Features

### M28: Fun Theme System
**Title:** Neon Dreams 2077 Cyberpunk Theme  
**Priority:** P1  
**Labels:** `p1`, `feature`, `ui`  
**Estimate:** 4-6 hours  
**Status:** In Progress  
**Description:**
Add Neon Dreams 2077 cyberpunk theme with animations. This will give users a fun, alternative visual experience.

**Acceptance Criteria:**
- [ ] Neon color scheme (cyberpunk aesthetic)
- [ ] Pulse animations on key elements
- [ ] Glitch effects on transitions
- [ ] Grid scan background effects
- [ ] Accessible from Settings
- [ ] Maintains readability and usability

**Technical Notes:**
- Extend existing theme system
- Use Material 3 theming
- Performance considerations for animations
- Test on various devices

**Branch:** `feature/fun-themes`

---

### M10: Speaker Data Integration
**Title:** Speaker Data Integration & Search  
**Priority:** P1  
**Labels:** `p1`, `feature`  
**Estimate:** 2-3 hours  
**Description:**
Extract and display speakers from ICS files, add speaker-based search functionality.

**Acceptance Criteria:**
- [ ] Extract speaker information from ICS ORGANIZER/ATTENDEE fields
- [ ] Display speakers in event cards
- [ ] Add speaker filter to search
- [ ] Show speaker count in insights
- [ ] Handle missing speaker data gracefully

**Technical Notes:**
- Extend existing ICS parser
- Update EventCard widget
- Add to search functionality
- Update analytics to include speakers

**Branch:** `feature/speaker-data-integration`

---

### M14: Calendar Export
**Title:** Calendar Export to Google/Apple Calendar  
**Priority:** P1  
**Labels:** `p1`, `feature`  
**Estimate:** 4-5 hours  
**Description:**
Allow users to export their selected agenda to Google Calendar or Apple Calendar.

**Acceptance Criteria:**
- [ ] Export selected events to ICS format
- [ ] Share via system share sheet
- [ ] Support Google Calendar import
- [ ] Support Apple Calendar import
- [ ] Include all event details (title, time, location, description)
- [ ] Handle timezone correctly

**Technical Notes:**
- Use existing ICS generation (reverse of import)
- Flutter share_plus package
- Test with both calendar systems
- Handle permissions if needed

**Branch:** `feature/calendar-export`

---

## P2 - Medium Priority

### M11: Import Screen UI Polish
**Title:** Import Screen UI Polish  
**Priority:** P2  
**Labels:** `p2`, `ui`  
**Estimate:** 1-2 hours  
**Description:**
Center elements, improve visual hierarchy, and polish the import screen design.

**Acceptance Criteria:**
- [ ] Centered layout
- [ ] Improved visual hierarchy
- [ ] Better spacing and alignment
- [ ] Consistent with Material 3 design
- [ ] Improved empty state messaging

**Branch:** `feature/import-ui-polish`

---

### M26: GitHub Page Modernization
**Title:** GitHub Page Modernization  
**Priority:** P2  
**Labels:** `p2`, `ui`, `infrastructure`  
**Estimate:** 2-3 hours  
**Description:**
Add branding, reduce whitespace, modernize design of GitHub Pages landing page.

**Acceptance Criteria:**
- [ ] Add EventFlow branding
- [ ] Reduce excessive whitespace
- [ ] Modern, clean design
- [ ] Better mobile responsiveness
- [ ] Updated screenshots/graphics

**Branch:** `feature/github-page-modernization`

---

### M27: User Onboarding Tutorial
**Title:** User Onboarding Tutorial (Duplicate of M30?)  
**Priority:** P2  
**Labels:** `p2`, `feature`, `ui`  
**Estimate:** 4-6 hours  
**Description:**
First-time user guided tour. Note: This may be duplicate of M30 - verify and consolidate if needed.

**Acceptance Criteria:**
- [ ] Guided tour of key features
- [ ] Interactive walkthrough
- [ ] Can be skipped
- [ ] Accessible from Settings

**Branch:** `feature/user-onboarding-tutorial`

**Note:** Verify if this is duplicate of M30 and consolidate if needed.

---

## P3 - Nice to Have / Future

### M21-M24: Advanced CI/CD Pipeline
**Title:** Advanced CI/CD Pipeline Automation  
**Priority:** P3  
**Labels:** `p3`, `infrastructure`  
**Estimate:** 8-12 hours (deferred)  
**Description:**
Automated CI feedback, stable test suite, iOS build automation, App Store Connect integration.

**Status:** Deferred - Pre-commit hooks are sufficient for now. Manual CI review works.

**Future Considerations:**
- Automated CI feedback loop
- Stable test suite (100% pass rate)
- iOS build automation with code signing
- App Store Connect integration
- TestFlight automation

**Note:** Current pre-commit hooks catch issues locally. This can be revisited after v1.0 launch.

---

### Dark Mode Polish
**Title:** Dark Mode Polish & Material You Dynamic Colors  
**Priority:** P3  
**Labels:** `p3`, `ui`  
**Estimate:** 4-6 hours  
**Description:**
Enhance dark mode support and add Material You dynamic color theming.

---

### Sticky Day Headers
**Title:** Sticky Day Headers & Timeline View  
**Priority:** P3  
**Labels:** `p3`, `ui`, `feature`  
**Estimate:** 3-4 hours  
**Description:**
Add sticky day headers in event lists and optional timeline view.

---

### Virtual Scrolling
**Title:** Virtual Scrolling for Large Calendars  
**Priority:** P3  
**Labels:** `p3`, `infrastructure`, `feature`  
**Estimate:** 4-6 hours  
**Description:**
Implement virtual scrolling for better performance with large event lists (1000+ events).

---

### PDF Export
**Title:** Export to PDF Reports  
**Priority:** P3  
**Labels:** `p3`, `feature`  
**Estimate:** 4-5 hours  
**Description:**
Allow users to export their agenda as a PDF report.

---

## Roadmap Organization

### v1.1 (Next Release)
- M29: Sample Test Data System
- M30: First-Time User Tutorial

### v1.2 (Future)
- M28: Fun Theme System
- M10: Speaker Data Integration

### v1.3 (Future)
- M14: Calendar Export
- M11: Import Screen UI Polish

### v2.0 (Future)
- Advanced CI/CD Pipeline
- Dark Mode Polish
- Virtual Scrolling
- PDF Export

---

## Import Instructions

1. **Create Issues:**
   - Copy each issue title and description
   - Set appropriate priority (P0, P1, P2, P3)
   - Add labels
   - Set estimate
   - Link to GitHub repository

2. **Set Dependencies:**
   - M30 should block M27 (if not duplicate)
   - v1.1 issues should be prioritized first

3. **Create Roadmap:**
   - Organize issues into releases (v1.1, v1.2, v1.3, v2.0)
   - Set target dates
   - Add dependencies between related issues

4. **Link to GitHub:**
   - Connect Linear issues to GitHub branches
   - Use branch names from descriptions
   - Link PRs when created

---

## Next Steps After Migration

1. **Archive this backlog.md** (keep for reference)
2. **Update current-status.md** to reference Linear
3. **Set up Linear webhooks** (if available) for automation
4. **Create Linear templates** for common issue types
5. **Train team** on Linear workflow

---

**Migration Date:** 2025-01-XX  
**Total Issues:** 15+ (including completed for history)  
**Status:** Ready for Linear import

