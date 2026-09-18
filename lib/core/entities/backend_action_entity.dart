import 'package:equatable/equatable.dart';

/// A single backend-driven button.
///
/// Named for its original home — a button inside a [BackendActionEntity]'s
/// bottom sheet or dialog — but it is now the shape for any standalone
/// backend-labelled tappable, including the orders suite's `refundPolicy` link
/// and empty-state CTAs.
class BackendActionButtonEntity extends Equatable {
  final String? label;

  /// Where the tap goes. **Always a URL string** — a deeplink (`hopscotch://…`)
  /// or an `https://` link routed by `ActionUrlHandler`.
  ///
  /// Sent as `actionUri` by the orders v6/v9 contracts, matching the key their
  /// listing records already use for the same thing. Cart, promos and the PLP
  /// empty state still send `action`, and the model reads either.
  ///
  /// `action` is the key this deliberately moved away from, and not only for
  /// tidiness: [BackendActionEntity] uses that same word for an *object*, and
  /// the value here is read through `parseToStringOrNull`, which is
  /// `value.toString()` with no type check. A map arriving under it does not
  /// become null — it becomes that map's `toString()`, non-empty enough to pass
  /// an `isNotNullOrEmpty` guard before failing on a nonsense destination. A
  /// button carrying structured data rather than a destination needs its own
  /// model, not this one.
  final String? actionUri;

  /// Names an app-owned behaviour or an identity, in SCREAMING_SNAKE —
  /// `CALL_US`, `HELP_CENTER`, `REFUND_POLICY`.
  ///
  /// Carries the buttons [actionUri] cannot: a dialog's Continue, a fixed next
  /// step, or anything whose destination is app config rather than a URL. Where
  /// both are present [actionUri] routes and this is identity only.
  ///
  /// Kept as the raw string, with [actionType] for switching on. An
  /// unrecognised value renders the button inert rather than throwing, so a
  /// type shipped by the backend degrades quietly on old builds — and keeping
  /// the string means the log says whatever actually arrived rather than just
  /// `unknown`.
  final String? type;

  /// Backend-chosen emphasis — `"primary"` / `"secondary"`. Null when the
  /// payload omits it, in which case the call site keeps its own default.
  final String? style;

  /// Optional leading or trailing glyph, as a URL. Sent as `icon` on the wire,
  /// named `iconUrl` here to match [BackendActionEntity.iconUrl].
  ///
  /// Usually chrome rather than content — the orders `refundPolicy` chevron,
  /// for instance — so a null just means the call site draws its own default
  /// affordance. Render through `CustomImage`, which handles the SVGs these
  /// URLs normally point at.
  final String? iconUrl;

  const BackendActionButtonEntity({
    this.label,
    this.actionUri,
    this.type,
    this.style,
    this.iconUrl,
  });

  /// Compatibility alias for the previous field name.
  ///
  /// Cart's message bars, the promos action sheet and the orders empty state
  /// all read `actionUrl`. This getter is what let the rename land in one file
  /// instead of eight; delete it once those call sites move to [actionUri].
  String? get actionUrl => actionUri;

  /// [type] resolved for switching. [BackendActionType.unknown] when the
  /// backend sends a behaviour this build does not handle, or nothing at all.
  BackendActionType get actionType => BackendActionType.from(type);

  bool get isPrimaryStyle => style == 'primary';
  bool get isSecondaryStyle => style == 'secondary';
  bool get isTertiaryStyle => style == 'tertiary';

  /// `"link"` — inline text rather than a bordered button. Used by the orders
  /// refund-policy line and the gift-card "Check Validity & Balance" action.
  bool get isLinkStyle => style == 'link';

  @override
  List<Object?> get props => [label, actionUri, type, style, iconUrl];
}

/// The behaviours [BackendActionButtonEntity.type] can name.
///
/// These are behaviours the app owns, not destinations. The dialer number comes
/// from `PrefManager.customerCareContact` (populated by app config at splash)
/// and the help centre from `HelpCenterLauncher`, which appends a login ticket
/// at tap time — neither is expressible as a URL on the wire, which is why
/// [BackendActionButtonEntity.actionUri] is null on those buttons.
///
/// The wire value sits beside each name because they differ: the wire is
/// SCREAMING_SNAKE and a Dart identifier cannot be, so `callUs` carries
/// `CALL_US` rather than deriving it.
///
/// [unknown] is not a wire value. The vocabulary is open by design — the
/// backend may ship a type before a build knows it — so [from] never throws and
/// a switch on this always needs a catch-all. Read
/// [BackendActionButtonEntity.type] for what actually arrived.
enum BackendActionType {
  callUs('CALL_US'),
  helpCenter('HELP_CENTER'),

  /// The "Read full refund T&C ›" line. A help-centre article, so it goes
  /// through the same launcher rather than arriving as a URL.
  refundPolicy('REFUND_POLICY'),

  /// privacy policy
  privacyPolicy('PRIVACY_POLICY'),

  /// terms and conditions
  termsAndConditions('TERMS_AND_CONDITIONS'),

  /// No wire value — what [from] returns for anything unrecognised, including
  /// null.
  unknown('');

  const BackendActionType(this.wire);

  /// The SCREAMING_SNAKE value as it arrives on the wire.
  final String wire;

  static BackendActionType from(String? value) => values.firstWhere(
    (t) => t != unknown && t.wire == value,
    orElse: () => unknown,
  );
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
