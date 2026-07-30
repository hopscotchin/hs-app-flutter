import 'package:injectable/injectable.dart';

import '../../services/pref_manager.dart';

/// UTM attribution cache. In-memory fields are the source-of-truth during
/// a session; disk mirror survives cold-start replays.
@lazySingleton
class UtmHeaderUtil {
  UtmHeaderUtil(this._prefs);

  final PrefManager _prefs;

  String? _utmSource;
  String? _utmCampaign;
  String? _utmMedium;
  String? _utmContent;
  String? _utmTerm;
  String? _utmGender;
  String? _deeplink;

  // In-memory only — never persisted.
  String? utmSection;
  String? utmProduct;
  String? utmPromo;

  bool isLaunch = false;
  bool isUtmChanged = false;

  /// Hydrate in-memory fields from disk. Sync — PrefManager reads are already
  /// in-memory caches so awaiting adds nothing.
  void hydrateFromDisk() {
    _utmSource = _prefs.utmSource;
    _utmCampaign = _prefs.utmCampaign;
    _utmMedium = _prefs.utmMedium;
    _utmContent = _prefs.utmContent;
    _utmTerm = _prefs.utmTerm;
    _utmGender = _prefs.utmGender;
    _deeplink = _prefs.utmDeeplink;
  }

  String? get utmSource => _utmSource;
  String? get utmCampaign => _utmCampaign;
  String? get utmMedium => _utmMedium;
  String? get utmContent => _utmContent;
  String? get utmTerm => _utmTerm;
  String? get utmGender => _utmGender;
  String? get deeplink => _deeplink;

  Future<void> setUtmSource(String? value) async {
    _markChangedIfNonEmpty(value);
    _utmSource = value;
    await _prefs.setUtmSource(value);
  }

  Future<void> setUtmCampaign(String? value) async {
    _markChangedIfNonEmpty(value);
    _utmCampaign = value;
    await _prefs.setUtmCampaign(value);
  }

  Future<void> setUtmMedium(String? value) async {
    _markChangedIfNonEmpty(value);
    _utmMedium = value;
    await _prefs.setUtmMedium(value);
  }

  Future<void> setUtmContent(String? value) async {
    _markChangedIfNonEmpty(value);
    _utmContent = value;
    await _prefs.setUtmContent(value);
  }

  Future<void> setUtmTerm(String? value) async {
    _markChangedIfNonEmpty(value);
    _utmTerm = value;
    await _prefs.setUtmTerm(value);
  }

  Future<void> setUtmGender(String? value) async {
    _markChangedIfNonEmpty(value);
    _utmGender = value;
    await _prefs.setUtmGender(value);
  }

  Future<void> setDeeplink(String? value) async {
    _markChangedIfNonEmpty(value);
    _deeplink = value;
    await _prefs.setUtmDeeplink(value);
  }

  /// Wipe every UTM field. Always flips `isUtmChanged = true`, even if the
  /// pre-existing state was already empty (matches Android).
  Future<void> clearUtmParams() async {
    _utmSource = null;
    _utmCampaign = null;
    _utmMedium = null;
    _utmContent = null;
    utmSection = null;
    _deeplink = null;
    utmProduct = null;
    utmPromo = null;
    _utmTerm = null;
    _utmGender = null;
    isUtmChanged = true;
    await Future.wait(<Future<void>>[
      _prefs.setUtmSource(null),
      _prefs.setUtmCampaign(null),
      _prefs.setUtmMedium(null),
      _prefs.setUtmContent(null),
      _prefs.setUtmTerm(null),
      _prefs.setUtmDeeplink(null),
      _prefs.setUtmGender(null),
    ]);
  }

  void _markChangedIfNonEmpty(String? value) {
    if (!isUtmChanged && value != null && value.isNotEmpty) {
      isUtmChanged = true;
    }
  }
}
