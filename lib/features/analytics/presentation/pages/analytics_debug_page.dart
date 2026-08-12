import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/analytics/debug/analytics_debug_log.dart';

class AnalyticsDebugPage extends StatefulWidget {
  const AnalyticsDebugPage({super.key});

  @override
  State<AnalyticsDebugPage> createState() => _AnalyticsDebugPageState();
}

class _AnalyticsDebugPageState extends State<AnalyticsDebugPage> {
  static const _encoder = JsonEncoder.withIndent('  ');
  late final StreamSubscription<void> _sub;

  @override
  void initState() {
    super.initState();
    _sub = AnalyticsDebugLog.changes.listen(_onLogChanged);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _onLogChanged(void _) {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final count = AnalyticsDebugLog.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics events'),
        actions: [
          const IconButton(
            onPressed: AnalyticsDebugLog.clear,
            icon: Icon(Icons.delete_outline),
            tooltip: 'Clear',
          ),
        ],
      ),
      body: count == 0
          ? const Center(child: Text('No events yet.'))
          : ListView.separated(
              itemCount: count,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entry = AnalyticsDebugLog.eventAt(index);
                final json = _stringify(entry.payload);
                return ExpansionTile(
                  title: Text(entry.event),
                  subtitle: Text(_formatTime(entry.timestamp)),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SelectableText(
                        json,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: json));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied to clipboard'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy JSON'),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  static String _stringify(Map<String, Object?> map) {
    try {
      return _encoder.convert(map);
    } catch (_) {
      return _encoder.convert(
        map.map((k, v) => MapEntry(k, v?.toString())),
      );
    }
  }

  static String _formatTime(DateTime t) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}.'
        '${t.millisecond.toString().padLeft(3, '0')}';
  }
}
