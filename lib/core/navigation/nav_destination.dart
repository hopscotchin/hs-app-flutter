import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/entities/message_bar_entity.dart';

/// Base class for navigation destinations.
sealed class NavDestination {
  const NavDestination();

  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra});
}

class PdpDestination extends NavDestination {
  final String productId;

  const PdpDestination({required this.productId});

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToPdp(context, productId);
  }
}

class HomeDestination extends NavDestination {
  const HomeDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToHome(context);
  }
}

class CartDestination extends NavDestination {
  const CartDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToCart(context);
  }
}

class CategoriesDestination extends NavDestination {
  const CategoriesDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToCategories(context);
  }
}

class MomentsDestination extends NavDestination {
  const MomentsDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToMoments(context);
  }
}

class AccountDestination extends NavDestination {
  const AccountDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToAccount(context);
  }
}

class ExternalDestination extends NavDestination {
  final String url;

  const ExternalDestination({required this.url});

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class RateAppDestination extends NavDestination {
  const RateAppDestination();

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    launchUrl(
      Uri.parse('market://details?id=in.hopscotch.android'),
      mode: LaunchMode.externalApplication,
    );
  }
}

class LandingPageDestination extends NavDestination {
  final String pageName;
  final String? pageTitle;

  const LandingPageDestination({required this.pageName, this.pageTitle});

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToLandingPage(
      context,
      pageName: pageName,
      title: title ?? pageTitle,
    );
  }
}

class JoinUsDestination extends NavDestination {
  const JoinUsDestination({this.mobile});

  final String? mobile;

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToJoinUs(
      context,
      initialMobile: mobile,
      redirectType: extra?['redirectType'] as String?,
    );
  }
}

class LoginDestination extends NavDestination {
  const LoginDestination({this.mobile, this.messageBars = const []});

  final String? mobile;
  final List<MessageBarEntity> messageBars;

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    final extraBars = extra?['messageBars'] as List<MessageBarEntity>? ?? const [];
    AppNavigator.goToLogin(
      context,
      initialMobile: mobile,
      initialMessageBars: extraBars.isNotEmpty ? extraBars : messageBars,
    );
  }
}

class WebViewDestination extends NavDestination {
  final String url;
  final String? pageTitle;

  const WebViewDestination({required this.url, this.pageTitle});

  @override
  void navigate(BuildContext context, {String? title, Map<String, dynamic>? extra}) {
    AppNavigator.goToWebView(context, url: url, title: title ?? pageTitle);
  }
}
