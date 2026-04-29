import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';
import 'package:url_launcher/url_launcher.dart';


/// Base class for navigation destinations.
sealed class NavDestination {
  const NavDestination();

  void navigate(BuildContext context, {String? title});
}

class HomeDestination extends NavDestination {
  const HomeDestination();

  @override
  void navigate(BuildContext context, {String? title}) {
    AppNavigator.goToHome(context);
  }
}

class CartDestination extends NavDestination {
  const CartDestination();

  @override
  void navigate(BuildContext context, {String? title}) {
    AppNavigator.goToCart(context);
  }
}

class CategoriesDestination extends NavDestination {
  const CategoriesDestination();

  @override
  void navigate(BuildContext context, {String? title}) {
    AppNavigator.goToCategories(context);
  }
}

class MomentsDestination extends NavDestination {
  const MomentsDestination();

  @override
  void navigate(BuildContext context, {String? title}) {
    AppNavigator.goToMoments(context);
  }
}

class AccountDestination extends NavDestination {
  const AccountDestination();

  @override
  void navigate(BuildContext context, {String? title}) {
    AppNavigator.goToAccount(context);
  }
}

class ExternalDestination extends NavDestination {
  final String url;

  const ExternalDestination({required this.url});

  @override
  void navigate(BuildContext context, {String? title}) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class RateAppDestination extends NavDestination {
  const RateAppDestination();

  @override
  void navigate(BuildContext context, {String? title}) {
    launchUrl(
      Uri.parse('market://details?id=in.hopscotch.android'),
      mode: LaunchMode.externalApplication,
    );
  }
}

class WebViewDestination extends NavDestination {
  final String url;
  final String? pageTitle;

  const WebViewDestination({required this.url, this.pageTitle});

  @override
  void navigate(BuildContext context, {String? title}) {
    AppNavigator.goToWebView(context, url: url, title: title ?? pageTitle);
  }
}
