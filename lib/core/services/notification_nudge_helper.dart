import 'package:injectable/injectable.dart';

import '../../features/splash/data/models/app_config_response.dart';

/// In-memory cache of the `notificationNudges` list from `/v1/app-config`,
/// keyed by screen. Mirrors Android's `NotificationNudgeHelper` — populated
/// once per cold start (see `SplashRepositoryImpl`) and, like the Android
/// original, deliberately **not** persisted to disk: it's refetched fresh on
/// every launch and lost on process death.
@lazySingleton
class NotificationNudgeHelper {
  List<NotificationNudge> _nudges = const [];

  void setNudges(List<NotificationNudge>? nudges) {
    _nudges = nudges ?? const [];
  }

  NotificationNudge? getNudge(String screen) {
    for (final nudge in _nudges) {
      if (nudge.screen == screen) return nudge;
    }
    return null;
  }
}
