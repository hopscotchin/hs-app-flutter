import 'package:equatable/equatable.dart';

/// A single button inside a [BackendActionEntity]'s bottom sheet or dialog.
class BackendActionButtonEntity extends Equatable {
  final String? label;
  final String? actionUrl;

  /// Backend-chosen emphasis — `"primary"` / `"secondary"`. Null when the
  /// payload omits it, in which case the call site keeps its own default.
  final String? style;

  const BackendActionButtonEntity({this.label, this.actionUrl, this.style});

  bool get isPrimaryStyle => style == 'primary';
  bool get isSecondaryStyle => style == 'secondary';
  bool get isTertiaryStyle => style == 'tertiary';

  @override
  List<Object?> get props => [label, actionUrl, style];
}

/// Type-specific payload for a [BackendActionEntity]. Every field is
/// nullable since `tooltip` only ever fills `text`/`bgColor`/`textColor`,
/// while `bottomSheet`/`dialog` only ever fill
/// `title`/`description`/`leftAction`/`rightAction`.
class BackendActionContentEntity extends Equatable {
  final String? title;
  final String? description;
  final String? text;
  final String? bgColor;
  final String? textColor;
  final BackendActionButtonEntity? leftAction;
  final BackendActionButtonEntity? rightAction;

  const BackendActionContentEntity({
    this.title,
    this.description,
    this.text,
    this.bgColor,
    this.textColor,
    this.leftAction,
    this.rightAction,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    text,
    bgColor,
    textColor,
    leftAction,
    rightAction,
  ];
}

/// Generic backend-driven "action" object — the same `{type, icon, content}`
/// shape shows up on price-summary rows (`type: "bottomSheet"`) and cart-item
/// message bars (`type: "tooltip"`), and may show up as `type: "dialog"`
/// elsewhere. One entity + one dispatcher widget ([ActionTrigger]) handles
/// all of them instead of each call site reimplementing its own subset.
class BackendActionEntity extends Equatable {
  final String? type;
  final String? iconUrl;
  final BackendActionContentEntity? content;

  const BackendActionEntity({this.type, this.iconUrl, this.content});

  bool get isTooltip => type == 'tooltip';
  bool get isBottomSheet => type == 'bottomSheet';
  bool get isDialog => type == 'dialog';

  @override
  List<Object?> get props => [type, iconUrl, content];
}
