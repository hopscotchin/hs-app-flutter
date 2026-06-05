import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../core/services/pref_manager.dart';

/// In-memory + SharedPreferences cache for the user's address list.
///
/// Single source of truth for address persistence. Blocs read from
/// [cached] and write through [setAll] / [removeById] / [clear] so the
/// raw JSON shape (`{'allAddressItems': [...]}`) lives in one place.
@lazySingleton
class AddressCacheManager {
  AddressCacheManager(this._prefManager);

  final PrefManager _prefManager;

  List<Map<String, dynamic>>? _memory;

  /// Returns the cached raw address items.
  ///
  /// Lazily hydrates from SharedPreferences on first access. Returns
  /// `null` if the cache has never been written (cold start, logged out,
  /// or after [clear]).
  List<Map<String, dynamic>>? get cached {
    if (_memory != null) return _memory;
    _memory = _readFromPrefs();
    return _memory;
  }

  Future<void> setAll(List<Map<String, dynamic>> items) async {
    final normalized = _enforceSingleDefault(items);
    _memory = normalized;
    await _prefManager.setAddressesJson(
      jsonEncode({'allAddressItems': normalized}),
    );
  }

  /// Accepts the full `/api/addresses` response payload. Extracts
  /// `allAddressItems` and delegates to [setAll]. Used by the splash
  /// prefetch path which has the raw response map in hand.
  Future<void> writeFromResponse(Map<String, dynamic> response) async {
    final items = (response['allAddressItems'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList(growable: false) ??
        const <Map<String, dynamic>>[];
    await setAll(items);
  }

  /// Marks the address with [id] as primary and clears the flag on all
  /// others. No-op if the cache is empty or [id] is not present.
  Future<void> setPrimary(int id) async {
    final current = cached;
    if (current == null) return;
    final updated = current.map((m) {
      final copy = Map<String, dynamic>.from(m);
      copy['isDefault'] = copy['id'] == id;
      return copy;
    }).toList(growable: false);
    await setAll(updated);
  }

  Future<void> removeById(int id) async {
    final current = cached;
    if (current == null) return;
    final remaining =
        current.where((m) => m['id'] != id).toList(growable: false);
    await setAll(remaining);
  }

  Future<void> clear() async {
    _memory = null;
    await _prefManager.setAddressesJson(null);
  }

  List<Map<String, dynamic>>? _readFromPrefs() {
    final raw = _prefManager.addressesJson;
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return (decoded['allAddressItems'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList(growable: false) ??
          const <Map<String, dynamic>>[];
    } catch (_) {
      return null;
    }
  }

  // Server is canonical, but guard against responses where more than one
  // item carries `isDefault: true` — keep the first, clear the rest.
  List<Map<String, dynamic>> _enforceSingleDefault(
    List<Map<String, dynamic>> items,
  ) {
    var seenPrimary = false;
    return items.map((item) {
      final copy = Map<String, dynamic>.from(item);
      final primary = copy['isDefault'] == true;
      if (primary) {
        if (seenPrimary) {
          copy['isDefault'] = false;
        } else {
          seenPrimary = true;
        }
      }
      return copy;
    }).toList(growable: false);
  }
}
