# Dev Commands

Common commands for this repo, what they do, and when to run them. Run all from
the project root.

---

## Automation / testing

### Build an automation APK
```
flutter build apk --debug --dart-define=AUTOMATION=true
```
Builds a debug APK with the **automation flag** on. Sets `kIsAutomation = true`
(`lib/core/config/build_config.dart`), which enables the integration-test driver
extension and disables the Talker floating debug button. Hand this build to QA /
the automation suite. Without `--dart-define=AUTOMATION=true` it's an ordinary
debug build and the driver extension is off.

### Regenerate the automation-keys QA doc
```
dart run tool/generate_automation_keys.dart
```
Regenerates [`lib/core/constants/strings/AUTOMATION_KEYS.md`](lib/core/constants/strings/AUTOMATION_KEYS.md)
— the QA-facing list of every `ValueKey` (type, key, examples, widget file) — from
`auto_test_strings.dart`. **Run this whenever you add / rename / remove a test
key.** The doc is generated; never hand-edit it.

### Check the QA doc is up to date (CI)
```
dart run tool/generate_automation_keys.dart --check
```
Exits non-zero if `AUTOMATION_KEYS.md` is stale (source changed but doc wasn't
regenerated). Meant for CI so a stale doc can't merge; safe to run locally too.

---

## Everyday Flutter

### Install dependencies
```
flutter pub get
```
Fetches/updates packages after cloning or editing `pubspec.yaml`.

### Run the app
```
flutter run
```
Launches on the connected device/emulator with hot reload.

### Code generation (freezed / json_serializable, etc.)
```
dart run build_runner build --delete-conflicting-outputs
```
Regenerates `*.g.dart` / `*.freezed.dart` files. Run after changing any class that
uses code-gen annotations. `--delete-conflicting-outputs` clears stale generated
files.

### Static analysis
```
flutter analyze
```
Lints/type-checks the project. Must be clean before pushing.

### Format
```
dart format .
```
Applies Dart formatting across the repo.

### Tests
```
flutter test
```
Runs unit + widget tests.

---

## Adding a new command here

When you add a script under `tool/` or a build variant, add a section above with:
the exact command, one line on **what** it does, and **when** to run it. Keep this
file the single place a dev looks to know how to build/generate/test.