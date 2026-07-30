import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

/// Loads the single captured `homepage_v13` response (`home_page_all.json`)
/// and exposes it as raw `PageComponent`s. Tests look up components by
/// `component.type` — no position hardcoding — so a single fixture drives
/// every per-component test file.
class HomeFixture {
  HomeFixture._(this._raw, this._components);

  final Map<String, dynamic> _raw;
  final List<PageComponent> _components;

  static HomeFixture load() =>
      _load('test/analytics/fixtures/home_page_all.json');

  static HomeFixture _load(String path) {
    final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    final components = (raw['pageComponents'] as List)
        .cast<Map<String, dynamic>>()
        .map((c) => PageComponent(
              type: c['type'] as String,
              position: (c['position'] as num?)?.toInt() ?? 0,
              data: c['data'] as Map<String, dynamic>?,
            ))
        .toList(growable: false);
    return HomeFixture._(raw, components);
  }

  Map<String, dynamic> get raw => _raw;
  List<PageComponent> get components => _components;

  /// All components matching [type], in fixture order. Empty if none.
  List<PageComponent> allOfType(String type) =>
      _components.where((c) => c.type == type).toList(growable: false);

  /// First component of [type], or `null` if none exist. Prefer this over
  /// `atPosition` — tests must not care about which slot the backend puts
  /// a component in, only that it exists.
  PageComponent? firstOfType(String type) {
    for (final c in _components) {
      if (c.type == type) return c;
    }
    return null;
  }

  /// Index of the first component of [type] in [components], or -1.
  int firstIndexOfType(String type) {
    for (var i = 0; i < _components.length; i++) {
      if (_components[i].type == type) return i;
    }
    return -1;
  }

  /// Indices of every component of [type] in [components].
  List<int> allIndicesOfType(String type) {
    final indices = <int>[];
    for (var i = 0; i < _components.length; i++) {
      if (_components[i].type == type) indices.add(i);
    }
    return indices;
  }

  /// Picks a random index for a component of [type]. Returns -1 when none.
  /// Uses an unseeded [Random] by default so different test runs exercise
  /// different component instances — catches per-instance backend drift.
  /// Pass [random] with a fixed seed to reproduce a specific pick.
  int randomIndexOfType(String type, {Random? random}) {
    final indices = allIndicesOfType(type);
    if (indices.isEmpty) return -1;
    final rng = random ?? Random();
    return indices[rng.nextInt(indices.length)];
  }

  /// Picks a random component of [type]. Returns `null` when none.
  PageComponent? randomOfType(String type, {Random? random}) {
    final idx = randomIndexOfType(type, random: random);
    return idx == -1 ? null : _components[idx];
  }

  /// Root trackingMeta at [componentIndex], or empty map if the component
  /// has no root trackingMeta.
  Map<String, dynamic> rootTrackingMetaAt(int componentIndex) {
    final data = _components[componentIndex].data;
    final v = data?['trackingMeta'];
    return v is Map<String, dynamic> ? v : const <String, dynamic>{};
  }
}
