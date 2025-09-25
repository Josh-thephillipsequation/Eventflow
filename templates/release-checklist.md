---
ai:
  include_by_default: false
  weight: 0.1
---

# Release Checklist — Conference Agenda Tracker

This file is a step-by-step checklist to prepare and publish a release of the Conference Agenda Tracker iOS app (TestFlight and App Store). It is written to be followed from a development machine with Xcode and Flutter installed.

Use this as the canonical per-release guide. Copy this into a release PR description when you prepare a release.

---

## Quick checklist (happy path)
- [ ] Update `pubspec.yaml` version (e.g. `1.2.0+3`) and commit
- [ ] Run `flutter pub get` and `flutter analyze` locally
- [ ] Run `flutter build ios --release` and test the app on a device
- [ ] Open `ios/Runner.xcworkspace` in Xcode, set signing/team, and archive
- [ ] Upload archive to App Store Connect (via Xcode Organizer or Transporter)
- [ ] Confirm build processed in App Store Connect
- [ ] Create TestFlight build and test with internal testers
- [ ] Complete App Store metadata, screenshots, and privacy form
- [ ] Submit for App Review and monitor status

---

## Detailed step-by-step release flow

PREP: ensure you are on a clean branch and your working tree is committed/pushed.

1) Prep repository and versioning
- Switch to the branch for the release (or create `release/x.y.z` from `main`):
  ```bash
  git checkout -b release/1.2.0
  ```
- Update `pubspec.yaml` version. Use semantic versioning `MAJOR.MINOR.PATCH+BUILD`.
  - Example: `version: 1.2.0+3` (the `+3` is the iOS build number)
- Commit version change with message `chore(release): 1.2.0`.
- Push branch and open a PR so the release changes are reviewable.

2) Code hygiene and checks
- Run static analysis and tests:
  ```bash
  flutter pub get
  flutter analyze
  flutter test
  ```
- Remove/disable any debug-only flags, test hosts, or dev-only logging.
- Verify all assets referenced in code are declared in `pubspec.yaml`.

3) Info.plist & privacy strings
- Ensure `ios/Runner/Info.plist` contains required NS* usage description keys for any APIs you access:
  - NSCalendarsUsageDescription — if importing calendars
  - NSPhotoLibraryUsageDescription — if photos are used
  - NSCameraUsageDescription — if camera used
  - NSMicrophoneUsageDescription — if audio used
- Add clear human-readable reasons, e.g. "This app imports events from your calendars so you can add them to your agenda.".

4) iOS signing, capabilities & provisioning
- Open `ios/Runner.xcworkspace` in Xcode:
  ```bash
  open ios/Runner.xcworkspace
  ```
- In Runner target → General → Identity: set the app's Bundle Identifier (match App Store Connect).
- Signing & Capabilities:
  - Select your Team.
  - Use "Automatically manage signing" to let Xcode provision profiles automatically, or use manual profiles if you have a signing workflow (fastlane match).
  - Add any required capabilities here (Push Notifications, Background Modes, etc.). If you add them, ensure provisioning profiles include those capabilities.

5) Asset checks
- App icon: add a 1024×1024 App Store icon (no alpha) to `ios/Runner/Assets.xcassets/AppIcon.appiconset`.
- Screenshots: prepare high-quality screenshots (for iPhone 6.7" at least). Compress them to reduce upload time.
- Ensure `pubspec.yaml` lists any images the app loads from assets.

6) Build & archive
- Clean and build locally first:
  ```bash
  flutter clean
  flutter pub get
  flutter build ios --release
  ```
- Test the release build on a physical device:
  ```bash
  flutter install --release -d <device-id>
  ```
  or run the generated app from Xcode after opening workspace.
- Archive in Xcode (recommended for first releases):
  - In Xcode choose Generic iOS Device, then Product → Archive
  - When the archive is created, Xcode Organizer opens → Distribute App → App Store Connect → Upload

7) Upload via Transporter (optional)
- If you built an IPA and want to use Transporter app:
  - `flutter build ipa` creates an .ipa in `build/`.
  - Open Apple Transporter and upload the .ipa file.

8) App Store Connect — processing & TestFlight
- Wait for Apple to process the binary (can take 10–30 minutes).
- When processing completes, the build will show in App Store Connect → TestFlight.
- Add internal testers and run smoke tests. Invite external testers if needed (external requires Beta App Review first time).

9) Metadata & submission
- In App Store Connect, open your App record (My Apps → [App]):
  - Enter app description, keywords, support URL, marketing URL.
  - Upload screenshots for each device type (iPhone 6.7" recommended, 5.5" fallback).
  - Set the release notes for the build.
  - Complete the Privacy questionnaire and link to your privacy policy.
- Submit for App Review. Provide clear notes for the reviewer if your app requires special credentials or steps to reproduce features.

10) Post-submission
- Monitor the review status. If reviewer requests information or changes, respond in App Store Connect.
- Once approved, either automatically release on approval or manually release the app.

11) Post-release validation
- Verify the app listing shows correctly on the App Store.
- Download the released app from the App Store and run basic smoke tests.
- Monitor crash reports and analytics.

---

## Release PR checklist (short template)
- [ ] Version bumped in `pubspec.yaml` and `CHANGELOG.md` updated
- [ ] All tests pass and `flutter analyze` is clean
- [ ] Info.plist privacy keys present and accurate
- [ ] App icons and screenshots added or referenced
- [ ] Signing/team set in Xcode (documented in PR description)
- [ ] Release notes added to PR and to App Store Connect when uploading
- [ ] PR approved and merged to `main` (or release branch)

---

## Commands cheat-sheet
- Local prep and build
  ```bash
  git checkout -b release/1.2.0
  # edit pubspec.yaml version
  flutter pub get
  flutter analyze
  flutter test
  flutter build ios --release
  ```
- Build IPA (optional)
  ```bash
  flutter build ipa
  ```
- Open workspace in Xcode
  ```bash
  open ios/Runner.xcworkspace
  ```

---

## Common problems & fixes
- Signing errors: re-open Xcode, set Team, toggle "Automatically manage signing". If using manual signing, ensure the provisioning profile matches the bundle identifier and capabilities.
- Missing Info.plist keys: add NS* keys with clear descriptions.
- Build processing stuck: re-upload IPA or check App Store Connect processing logs; sometimes verbose errors appear in the build details.
- Large assets: compress screenshots and app images (WebP/JPEG). Optionally move very large media out of repo or use Git LFS.

---

## Optional: fastlane automation (recommended for repeatable releases)
- Install fastlane and configure App Store Connect API key or use `fastlane match` for certificates.
- Example lanes:
  - `fastlane beta` — increment build number, build ipa, upload to TestFlight
  - `fastlane release` — increment build number, build ipa, upload to App Store
- Important: never commit private API keys or certificates. Store them in CI secrets or use fastlane match with a secure repo.

---

## Release notes template (copy into App Store Connect)
Version: x.y.z (build +n)

Short summary (one line):
- What’s new: bug fixes, improved import, UI polish, etc.

Detailed changes:
- Bullet list of user-visible changes.

Known issues:
- Any important caveats or platform notes.

---

If you want, I can:
- Create `agent_assets/release-checklist.md` (done), and optionally add a `fastlane` scaffold (no secrets) on `feature/ci-workflow`.
- Pre-fill `Info.plist` privacy keys with suggested copy (I will use placeholder text you can edit).
- Add a `release` PR template or GitHub Action to help automate the process.

Tell me which of the above you'd like me to implement next.
