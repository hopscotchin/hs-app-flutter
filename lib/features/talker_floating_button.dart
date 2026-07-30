import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hs_app_flutter/core/config/build_config.dart';
import 'package:hs_app_flutter/core/di/injection.dart';
import 'package:hs_app_flutter/core/router/app_router.dart';
import 'package:hs_app_flutter/features/analytics/presentation/pages/analytics_debug_page.dart';
import 'package:talker_dio_logger_plus/talker_dio_logger_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerFloatingButton extends StatefulWidget {
  const TalkerFloatingButton({super.key, required this.child});

  final Widget child;

  @override
  State<TalkerFloatingButton> createState() => _TalkerFloatingButtonState();
}

class _TalkerFloatingButtonState extends State<TalkerFloatingButton> {
  Offset _position = const Offset(16, 120);
  bool _isDragging = false;

  void _copyToClipboard(
    BuildContext screenContext,
    Talker talker,
    TalkerData data,
  ) {
    final text = data.generateTextMessage(
      timeFormat: talker.settings.timeFormat,
    );
    Clipboard.setData(ClipboardData(text: text));
    final messenger = ScaffoldMessenger.maybeOf(screenContext);
    messenger?.showSnackBar(
      const SnackBar(content: Text('Log copied to clipboard')),
    );
  }

  void _clampPosition(Size screen) {
    const size = 52.0;
    _position = Offset(
      _position.dx.clamp(0, screen.width - size),
      _position.dy.clamp(0, screen.height - size),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode || kIsAutomation) return widget.child;
    final screenSize = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: _position.dx,
          top: _position.dy,
          child: RepaintBoundary(
            child: GestureDetector(
              onPanStart: (_) => setState(() => _isDragging = true),
              onPanUpdate: (d) {
                setState(() {
                  _position += d.delta;
                  _clampPosition(screenSize);
                });
              },
              onPanEnd: (_) => setState(() => _isDragging = false),
              onLongPress: () {
                AppRouter.navigatorKey.currentState?.push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AnalyticsDebugPage(),
                  ),
                );
              },
              onTap: () {
                final talker = sl<Talker>();
                const theme = TalkerScreenTheme();
                AppRouter.navigatorKey.currentState?.push(
                  MaterialPageRoute<void>(
                    builder: (_) => TalkerScreen(
                      talker: talker,
                      theme: theme,
                      itemsBuilder: (context, data) {
                        if (isAdvancedHttpLog(data)) {
                          return HttpLogCard(data: data, expanded: true);
                        }
                        return TalkerDataCard(
                          data: data,
                          backgroundColor: theme.cardColor,
                          color: data.getFlutterColor(theme),
                          onCopyTap: () => _copyToClipboard(context, talker, data),
                        );
                      },
                    ),
                  ),
                );
              },

              child: AnimatedScale(
                scale: _isDragging ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF67218C),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.bug_report_rounded, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
