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

### P3 / Future ideas
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
- 2025-09-23: Created backlog and initial branches: `feature/optimize-screenshots`, `feature/add-contributing`, `feature/ci-workflow`.

---
*This backlog is intentionally lightweight and agent-friendly — update as you go.*
