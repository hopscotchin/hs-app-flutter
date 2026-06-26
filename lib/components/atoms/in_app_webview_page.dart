import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../appbar/hs_appbar.dart';
import '../../core/config/env_config.dart';
import '../../core/navigation/action_url_handler.dart';
import '../../core/router/app_navigator.dart';
import '../../core/theme/colors.dart';
import '../../core/utils/snackbar_utils.dart';
import 'empty_state_widget.dart';

/// Generalised in-app WebView.
///
/// Handles the full set of behaviours a WebView needs:
///   - page loading / progress / error + retry UI
///   - in-page back navigation (browser history) before popping the route
///   - URL scheme routing: `tel:` / `mailto:` / `sms:` → system handler,
///     `hopscotch://` and Hopscotch web links → in-app deep-link routing,
///     unknown schemes → external app, http(s) → load in place
///   - direct media URLs (pdf / images) → open in the system browser
///   - QA security headers injected for QA hosts
///   - a `WebViewInterface.login(url)` JS channel that triggers the app
///     login flow, then generates a web SSO ticket and reloads the page
///     authenticated on success
///   - cookie cleanup on exit (opt-in)
///
/// Ported from the Android `HSWebviewActivity`.
class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({
    super.key,
    required this.url,
    this.title,
    this.showAppBar = true,
    this.enableZoom = true,
    this.clearCacheOnLoad = true,
    this.clearCookiesOnExit = false,
    this.fromNotification = false,
    this.additionalHeaders = const {},
    this.onLoginRequested,
  });

  /// Initial URL to load.
  final String url;

  /// AppBar title. Empty/null shows a blank title.
  final String? title;

  /// Whether to render the [AppBar]. Set false to embed the WebView.
  final bool showAppBar;

  /// Allow pinch-to-zoom inside the page.
  final bool enableZoom;

  /// Clear the WebView cache + history before the first load.
  final bool clearCacheOnLoad;

  /// Clear all cookies when this page is disposed.
  final bool clearCookiesOnExit;

 
  final bool fromNotification;

  /// Extra request headers merged into every navigation to a same-origin host.
  final Map<String, String> additionalHeaders;

  /// Invoked when the page calls `WebViewInterface.login(redirectUrl)`.
  ///
  /// Should drive the app login flow and, on success, return a web SSO login
  /// ticket. The WebView then reloads the redirect URL with the ticket appended
  /// so the page opens authenticated. Return `null` (login cancelled/failed) to
  /// leave the page untouched.
  ///
  /// When omitted, the page falls back to simply opening the login screen
  /// without resuming the web session.
  final Future<String?> Function(BuildContext context, String? redirectUrl)?
  onLoginRequested;

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  static const _jsChannel = 'WebViewInterface';

  // Direct-media extensions that should open in the system browser rather
  // than render inside the WebView.
  static const _mediaExtensions = [
    '.pdf', '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.webp',
  ];

  late final WebViewController _controller;

  int _progress = 0;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    // Direct media URLs are not rendered in-app — defer to the system browser
    // and pop straight back out.
    if (_isMediaUrl(widget.url)) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _launchExternal(widget.url);
        if (mounted) Navigator.of(context).maybePop();
      });
      _controller = WebViewController();
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(widget.enableZoom)
      ..addJavaScriptChannel(
        _jsChannel,
        onMessageReceived: _onJsMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (mounted) setState(() => _progress = p);
          },
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            debugPrint(
              'WebView error: code=${error.errorCode} type=${error.errorType} '
              'mainFrame=${error.isForMainFrame} url=${error.url} '
              'desc=${error.description}',
            );
            // Only surface hard failures for the main frame, not sub-resources.
            if (mounted && error.isForMainFrame == true) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
          onNavigationRequest: _onNavigationRequest,
        ),
      );

    if (_controller.platform is AndroidWebViewController) {
      final android = _controller.platform as AndroidWebViewController;
      android.setUseWideViewPort(true);
      // Android WebView defaults to MIXED_CONTENT_NEVER_ALLOW, which silently
      // drops any http(s)-mixed sub-resources (css/js) and renders a blank
      // page. Browsers are lenient; match that so pages aren't white.
      android.setMixedContentMode(MixedContentMode.compatibilityMode);
      AndroidWebViewController.enableDebugging(kDebugMode);
    }

    _prepareAndLoad();
  }

  /// Clears cache/local-storage (if requested) *before* the first load.
  /// On Android, firing `clearCache()` and `loadRequest()` together races and
  /// can fail the main frame with `net::ERR_CACHE_MISS`; awaiting avoids it.
  Future<void> _prepareAndLoad() async {
    if (widget.clearCacheOnLoad) {
      await _controller.clearCache();
      await _controller.clearLocalStorage();
    }
    if (mounted) _loadUrl(widget.url);
  }

  @override
  void dispose() {
    if (widget.clearCookiesOnExit) {
      WebViewCookieManager().clearCookies();
    }
    super.dispose();
  }

  // ── Loading ──────────────────────────────────────────────────

  void _loadUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    _controller.loadRequest(_withSiteParam(uri), headers: _headersFor(uri));
  }

  /// Tags Hopscotch URLs with `site=android`/`site=ios` so the web app renders
  /// the native-app variant instead of the default (web/flutter) experience.
  /// Leaves a pre-existing `site` param untouched and skips non-Hopscotch hosts.
  Uri _withSiteParam(Uri uri) {
    if (!_isHopscotchHost(uri.host)) return uri;
    if (uri.queryParameters.containsKey('site')) return uri;
    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        'site': Platform.isIOS ? 'ios' : 'android',
      },
    );
  }

  /// QA hosts require the N7 security headers; same-origin hosts also receive
  /// any caller-supplied [InAppWebViewPage.additionalHeaders].
  Map<String, String> _headersFor(Uri uri) {
    final headers = <String, String>{};
    if (_isHopscotchHost(uri.host)) {
      headers.addAll(widget.additionalHeaders);
    }
    if (_isQaHost(uri.host)) {
      headers['x-nv'] = 'true';
      headers['x-nv-security-magic'] = EnvConfig.n7DebugMagicSecurityKey;
    }
    return headers;
  }

  // ── Navigation routing ───────────────────────────────────────

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    final url = request.url;
    final uri = Uri.tryParse(url);
    if (uri == null) return NavigationDecision.navigate;

    final scheme = uri.scheme.toLowerCase();

    // System-handled schemes (dialer, mail, sms).
    if (scheme == 'tel' || scheme == 'mailto' || scheme == 'sms') {
      _launchExternal(url);
      return NavigationDecision.prevent;
    }

    // App deep links — route inside the app.
    if (scheme == 'hopscotch') {
      ActionUrlHandler.navigate(context, url);
      return NavigationDecision.prevent;
    }

    // Facebook profile deep links are swallowed (Android blocked these to stop
    // the page bouncing users into the FB app on a profile redirect).
    if (scheme == 'fb' && (uri.host.contains('profile') || url.contains('profile'))) {
      return NavigationDecision.prevent;
    }

    // Direct media link tapped within the page → system browser.
    if (_isMediaUrl(url)) {
      _launchExternal(url);
      return NavigationDecision.prevent;
    }

    if (scheme == 'http' || scheme == 'https') {
      return NavigationDecision.navigate;
    }

    // Anything else (whatsapp, upi, intent, fb, …) → external app.
    _launchExternal(url);
    return NavigationDecision.prevent;
  }

  Future<void> _launchExternal(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        context.showSnack(
          'No app found to handle this action.',
          status: SnackStatus.error,
        );
      }
    } catch (_) {
      if (mounted) {
        context.showSnack(
          'No app found to handle this action.',
          status: SnackStatus.error,
        );
      }
    }
  }

  // ── JS channel ───────────────────────────────────────────────

  Future<void> _onJsMessage(JavaScriptMessage message) async {
    // The web app posts the redirect URL it wants resumed after login.
    final redirectUrl = message.message.isEmpty ? null : message.message;
    if (!mounted) return;

    final handler = widget.onLoginRequested;
    if (handler == null) {
      // No SSO wiring — just open the login screen.
      AppNavigator.goToLogin(context);
      return;
    }

    // Drive login + ticket generation, then reload the page authenticated.
    final loginTicket = await handler(context, redirectUrl);
    if (!mounted || loginTicket == null || loginTicket.isEmpty) return;

    final target = (redirectUrl != null && redirectUrl.isNotEmpty)
        ? redirectUrl
        : await _controller.currentUrl();
    final authedUrl = _appendLoginTicket(target, loginTicket);
    if (authedUrl != null && mounted) _loadUrl(authedUrl);
  }

  /// Appends the web SSO params (`id`, `site`, `loginTicket`) to [url] so the
  /// reloaded page resumes the now-authenticated session. Returns `null` for a
  /// non-http URL.
  String? _appendLoginTicket(String? url, String ticket) {
    if (url == null || !url.contains('http')) return null;
    final site = Platform.isIOS ? 'ios' : 'android';
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}id=app&site=$site&loginTicket=$ticket';
  }

  // ── Back handling ────────────────────────────────────────────

  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    if (didPop) return;
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return;
    }
    if (!mounted) return;
    // From a notification there is no meaningful back stack — send the user
    // home instead of popping (Android `onBackFromExternal`).
    if (widget.fromNotification) {
      AppNavigator.goToHome(context);
      return;
    }
    Navigator.of(context).pop(result);
  }

  // ── Host / URL helpers ───────────────────────────────────────

  bool _isHopscotchHost(String host) => host.contains('hopscotch.in');

  bool _isQaHost(String host) =>
      host == EnvConfig.webHostQa ||
      host == EnvConfig.webHostQaVpn ||
      host.contains('qa.');

  bool _isMediaUrl(String url) {
    final lower = url.toLowerCase();
    return _mediaExtensions.any(lower.contains);
  }

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.showAppBar
            ? HsAppbar(
                title: widget.title ?? '',
                onLeadingTap: () => _onPopInvoked(false, null),
              )
            : null,
        body: SafeArea(child: _body()),
      ),
    );
  }

  Widget _body() {
    if (_hasError) return _errorView();
    return Column(
      children: [
        if (_isLoading)
          LinearProgressIndicator(
            value: _progress == 0 ? null : _progress / 100,
            color: AppColors.primary,
            backgroundColor: AppColors.primaryLight,
          ),
        Expanded(child: WebViewWidget(controller: _controller)),
      ],
    );
  }

  Widget _errorView() {
    return EmptyStateWidget(
      type: EmptyStateType.serverError,
      onButtonTap: () {
        setState(() {
          _hasError = false;
          _isLoading = true;
        });
        _loadUrl(widget.url);
      },
    );
  }
}