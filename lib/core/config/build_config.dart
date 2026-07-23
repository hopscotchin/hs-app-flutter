/// True when the app is built for automation/integration testing.
///
/// Enabled by passing `--dart-define=AUTOMATION=true` at build time, e.g.
///   flutter build apk --debug --dart-define=AUTOMATION=true
///
/// Manual QA (`flutter build apk --debug`) and release builds leave this false.
const bool kIsAutomation = bool.fromEnvironment('AUTOMATION');
