import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/analytics/debug/analytics_debug_log.dart';

class AnalyticsDebugPage extends StatelessWidget {
  const AnalyticsDebugPage({super.key});

  static const _encoder = JsonEncoder.withIndent('  ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics events'),
        actions: [
          IconButton(
            onPressed: () =>
                AnalyticsDebugLog.log.value = <AnalyticsEventLog>[],
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear',
          ),
        ],
      ),
      body: ValueListenableBuilder<List<AnalyticsEventLog>>(
        valueListenable: AnalyticsDebugLog.log,
        builder: (context, events, _) {
          if (events.isEmpty) {
            return const Center(child: Text('No events yet.'));
          }
          return ListView.separated(
            itemCount: events.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final entry = events[index];
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
