import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/appbar/hs_appbar.dart';
import '../../../../components/atoms/filled_text_field.dart' show MobileNumberFormatter;
import '../../../../components/atoms/outlined_text_field.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../domain/entities/auth_entry_args.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../widgets/auth_footer_link_row.dart';
import '../widgets/auth_primary_button.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/navigation/action_url_handler.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../account/presentation/bloc/account_bloc.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.initialMobile,
    this.entry = AuthEntryArgs.unknown,
    this.initialMessageBars = const [],
    this.isCheckoutFlow = false,
    this.redirectType,
  });

  final String? initialMobile;

  /// Where the user came from, for the auth events. Defaults to
  /// [AuthEntryArgs.unknown], which reports "none" — the same value Android
  /// sends when its intent extras are absent.
  final AuthEntryArgs entry;
  final List<MessageBarEntity> initialMessageBars;
  final bool isCheckoutFlow;
  final String? redirectType;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _inputController = TextEditingController();
  final _inputFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late List<MessageBarEntity> _pendingMessageBars;
  String _checkoutOtpReason = AuthStrings.getAddressReason;
  bool _showErrors = false;

  void _onFieldChanged(String _) {
    if (_showErrors) {
      _showErrors = false;
      _formKey.currentState?.validate();
    }
  }

  @override
  void initState() {
    super.initState();
    _pendingMessageBars = widget.initialMessageBars;
    final mobile = widget.initialMobile;
    if (mobile != null && mobile.length == 10) {
      _inputController.text = '${mobile.substring(0, 5)} ${mobile.substring(5)}';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _inputFocusNode.requestFocus());
    // Dispatched, not fired here: analytics emits from Blocs on this codebase.
    // Once per route mount, mirroring Android's onViewCreated
    // (MobileLoginFragment.kt:78), which has no suppression flag either.
    context.read<AuthBloc>().add(AuthEvent.loginViewed(entry: _entry));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  /// Entry context for the auth events, with `from_redirect` merged in.
  ///
  /// `redirectType` arrives on the route and the rest of [AuthEntryArgs] does
  /// not yet — `from_screen` and `from_location` need the ~19 navigation call
  /// sites, which live in other feature modules. So this reports a real
  /// `from_redirect` and `"none"` for the other two, today.
  AuthEntryArgs get _entry =>
      widget.entry.copyWith(fromRedirect: widget.redirectType);

  String get _rawMobile => _inputController.text.replaceAll(RegExp(r'\D'), '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      appBar: HsAppbar(
        title: AuthStrings.signInTitle,
        titleKey: const ValueKey(LoginTestStrings.loginAppBarTitle),
        backButtonKey: const ValueKey(LoginTestStrings.loginBackButton),
        onLeadingTap: () => Navigator.of(context).pop(),
      ),
      body: widget.isCheckoutFlow
          ? BlocListener<AuthBloc, AuthState>(
              listenWhen: (prev, curr) =>
                  (curr.isMobileChecked && !prev.isMobileChecked) ||
                  (curr.isOtpSent && !prev.isOtpSent),
              listener: (context, state) {
                if (state.isMobileChecked) {
                  _checkoutOtpReason =
                      state.checkMobileResult?.otpReason ?? AuthStrings.getAddressReason;
                  context.read<AuthBloc>().add(
                    AuthEvent.sendOtp(
                      loginId: _rawMobile,
                      otpReason: _checkoutOtpReason,
                      pathUri: state.checkMobileResult?.pathUri,
                      entry: _entry,
                    ),
                  );
                  return;
                }
                if (!ModalRoute.of(context)!.isCurrent) return;
                context
                    .pushNamed<bool>(
                      RouteNames.otpVerification,
                      extra: <String, dynamic>{
                        'bloc': context.read<AuthBloc>(),
                        'accountBloc': context.read<AccountBloc>(),
                        'loginId': _rawMobile,
                        'otpConfig': state.otpConfig!,
                        'otpReason': _checkoutOtpReason,
                        'isCheckoutFlow': true,
                        'entry': _entry,
                      },
                    )
                    .then((success) {
                      if (success == true && context.mounted) context.pop(true);
                    });
              },
              child: _buildBody(),
            )
          : BlocListener<AuthBloc, AuthState>(
              listenWhen: (prev, curr) => curr.isOtpSent && !prev.isOtpSent,
              listener: (context, state) {
                if (!ModalRoute.of(context)!.isCurrent) return;
                AppNavigator.goToOtpVerification(
                  context,
                  bloc: context.read<AuthBloc>(),
                  loginId: _rawMobile,
                  otpConfig: state.otpConfig!,
                  otpReason: AuthStrings.signInReason,
                  redirectType: widget.redirectType,
                  entry: _entry,
                );
              },
              child: _buildBody(),
            ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state.isLoading;

        void onMessageAction(String? link, MessageBarEntity bar) {
          final destination = ActionUrlHandler.parse(link ?? '');
          if (destination == null || destination is LoginDestination) return;
          destination.navigate(context, extra: {'redirectType': widget.redirectType});
        }

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Builder(
                builder: (_) {
                  final bars = state.isError
                      ? state.messageBars
                      : (!state.isLoading ? _pendingMessageBars : const <MessageBarEntity>[]);
                  if (bars.isEmpty) return const SizedBox.shrink();
                  return Column(
                    children: [
                      AppSpacing.verticalGapLg,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MessageBarsWidget(
                          messageBars: bars,
                          cardStyle: true,
                          onAction: onMessageAction,
                          keyPrefix: LoginTestStrings.screen,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPaddingHorizontal,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.verticalGapLg,
                        _buildMobileField(),
                        AppSpacing.verticalGapLg,
                        AuthPrimaryButton(
                          key: const ValueKey(LoginTestStrings.loginSendOtpButton),
                          label: AuthStrings.sendOtp,
                          isLoading: isLoading,
                          onPressed: _onSendOtp,
                        ),

                        AppSpacing.verticalGapXl,
                        AuthFooterLinkRow(
                          key: const ValueKey(LoginTestStrings.loginJoinUsButton),
                          promptText: AuthStrings.newToHopscotch,
                          actionLabel: AuthStrings.joinUs.toUpperCase(),
                          onActionTap: () => AppNavigator.goToJoinUs(
                            context,
                            initialMobile: _rawMobile.length == 10 ? _rawMobile : null,
                            redirectType: widget.redirectType,
                            // The pivot is a new entry, not a continuation:
                            // join_viewed reports Login as its from_screen.
                            entry: const AuthEntryArgs(
                              fromScreen: FromScreens.login,
                              fromLocation: FromLocations.signUpButton,
                            ),
                          ),
                        ),
                        AppSpacing.verticalGapLg,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileField() {
    return OutlinedTextField(
      key: const ValueKey(LoginTestStrings.loginMobileInputField),
      controller: _inputController,
      focusNode: _inputFocusNode,
      labelText: AuthStrings.mobileNumberTitle,
      hintTextKey: const ValueKey(LoginTestStrings.loginMobileInputHint),
      keyboardType: TextInputType.phone,
      maxLength: 11,
      prefixText: '+91 ',
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, const MobileNumberFormatter()],
      onChanged: _onFieldChanged,
      validator: (value) {
        if (!_showErrors) return null;
        final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
        if (digits.isEmpty) return AuthStrings.enterValidMobileNumber;
        if (digits.length != 10) {
          return AuthStrings.enterValidMobileNumber;
        }
        return null;
      },
    );
  }

  void _onSendOtp() {
    _showErrors = true;
    if (_formKey.currentState!.validate()) {
      setState(() => _pendingMessageBars = const []);
      if (widget.isCheckoutFlow) {
        context.read<AuthBloc>().add(AuthEvent.checkMobile(mobile: _rawMobile));
      } else {
        context.read<AuthBloc>().add(
          AuthEvent.sendOtp(
            loginId: _rawMobile,
            otpReason: AuthStrings.signInReason,
            entry: _entry,
          ),
        );
      }
    }
  }
}
