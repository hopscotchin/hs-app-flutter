import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../components/appbar/hs_appbar.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../account/presentation/bloc/account_bloc.dart';
import '../../../discover/presentation/bloc/home_bloc.dart';
import '../../domain/entities/otp_config/otp_config_entity.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_otp_slot_row.dart';
import '../widgets/otp_waiting_indicator.dart';

class OtpVerificationPage extends StatefulWidget {
  final String loginId;
  final OtpConfigEntity otpConfig;
  final String otpReason;
  final bool isCheckoutFlow;
  final String? redirectType;

  const OtpVerificationPage({
    super.key,
    required this.loginId,
    required this.otpConfig,
    this.otpReason = 'SIGN_IN',
    this.isCheckoutFlow = false,
    this.redirectType,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> with TickerProviderStateMixin {
  late int _otpLength;
  late int _remainingSeconds;
  Timer? _timer;
  StreamSubscription<String?>? _smsSubscription;

  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _otpLength = widget.otpConfig.length;
    _remainingSeconds = widget.otpConfig.timerSeconds;
    _startTimer();
    if (Platform.isAndroid) _startSmsListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_otpController.text.isEmpty) {
        _otpFocusNode.requestFocus();
      }
    });
  }

  Future<void> _startSmsListener() async {
    await SmsAutoFill().listenForCode(smsCodeRegexPattern: '\\d{$_otpLength}');
    if (!mounted) return;
    _smsSubscription = SmsAutoFill().code.listen(_onSmsCode);
  }

  void _onSmsCode(String? code) {
    if (code == null || code.length != _otpLength || !mounted) return;
    _otpController.text = code;
    setState(() {});
    _onVerify();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_remainingSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds <= 1) timer.cancel();
        setState(() => _remainingSeconds--);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _smsSubscription?.cancel();
    if (Platform.isAndroid) SmsAutoFill().unregisterListener();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  String get _displayLoginId {
    final id = widget.loginId;
    if (id.length == 10 && RegExp(r'^\d+$').hasMatch(id)) {
      return '+91 ${id.substring(0, 5)} ${id.substring(5)}';
    }
    return id;
  }

  String get _otp => _otpController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      appBar: HsAppbar(
        title: AuthStrings.verifyMobile,
        titleKey: const ValueKey(OtpVerificationTestStrings.otpVerificationAppBarTitle),
        backButtonKey: const ValueKey(OtpVerificationTestStrings.otpVerificationBackButton),
        onLeadingTap: () => context.pop(),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.read<CartCountCubit>().set(state.verifyOtpResult!.user.cartItemCount);

            context.read<AccountBloc>().add(const RefreshFromLocal());
            context.read<AccountBloc>().add(const LoadAccount());
            context.read<HomeBloc>().add(const RefreshHomePage());

            if (widget.isCheckoutFlow) {
              context.pop(true);
            } else {
              AppNavigator.redirectAfterLogin(context, widget.redirectType);
            }
          } else if (state.isError) {
            _otpController.clear();
            setState(() {});
          } else if (state.isOtpSent) {
            setState(() {
              _remainingSeconds = state.otpConfig!.timerSeconds;
            });
            _startTimer();
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state.isLoading;
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.isError && state.otpMessageBars.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: MessageBarsWidget(
                        messageBars: state.otpMessageBars,
                        cardStyle: true,
                        keyPrefix: OtpVerificationTestStrings.screen,
                      ),
                    )
                  else if (state.isOtpSent && state.messageBars.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: MessageBarsWidget(
                        messageBars: state.messageBars,
                        cardStyle: true,
                        keyPrefix: OtpVerificationTestStrings.screen,
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: AppSpacing.screenPaddingHorizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppSpacing.verticalGapLg,
                          OtpWaitingIndicator(dotCount: _otpLength),
                          AppSpacing.verticalGapLg,
                          Text(
                            AuthStrings.enterOtpSentToNumber,
                            key: const ValueKey(OtpVerificationTestStrings.otpVerificationPromptTextField),
                            textAlign: TextAlign.center,
                            style: AppTypographyV1.labelLarge.regular.copyWith(
                              color: AppColors.neutralBlack,
                            ),
                          ),
                          AppSpacing.verticalGapSm,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  _displayLoginId,
                                  key: const ValueKey(OtpVerificationTestStrings.otpVerificationLoginIdTextField),
                                  style: AppTypographyV1.labelLarge.bold.copyWith(
                                    color: AppColors.neutralBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              AppSpacing.horizontalGapMd,
                              GestureDetector(
                                onTap: () => context.pop(),
                                key: const ValueKey(OtpVerificationTestStrings.otpVerificationChangeButton),
                                child: Text(
                                  AuthStrings.change,
                                  style: AppTypographyV1.labelMedium.bold.copyWith(
                                    color: AppColors.secondary,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.verticalGapXl,
                          GestureDetector(
                            onTap: _otpFocusNode.requestFocus,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: AuthOtpSlotRow(
                                    key: const ValueKey(OtpVerificationTestStrings.otpVerificationOtpSlotRow),
                                    length: _otpLength,
                                    otp: _otp,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: kDebugMode ? 0.01 : 0,
                                    child: TextField(
                                      key: const ValueKey(OtpVerificationTestStrings.otpVerificationOtpInputField),
                                      controller: _otpController,
                                      focusNode: _otpFocusNode,
                                      keyboardType: TextInputType.number,
                                      autofillHints: kDebugMode ? const []: const [AutofillHints.oneTimeCode],
                                      enableIMEPersonalizedLearning: kDebugMode ? false : true,
                                      maxLength: _otpLength,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      decoration: const InputDecoration(
                                        counterText: '',
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        setState(() {});
                                        if (value.length == _otpLength) {
                                          _onVerify();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.verticalGapLgMd,
                          _remainingSeconds > 0
                              ? Text(
                                  '${AuthStrings.resendOtpIn} $_remainingSeconds s',
                                  key: const ValueKey(OtpVerificationTestStrings.otpVerificationResendTimerTextField),
                                  style: AppTypographyV1.labelLarge.regular.copyWith(
                                    color: AppColors.neutralBlack,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: isLoading ? null : _onResend,
                                  key: const ValueKey(OtpVerificationTestStrings.otpVerificationResendButton),
                                  child: Text(
                                    AuthStrings.resendOtpButton,
                                    style: AppTypographyV1.bodyRegular.semiBold.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onVerify() {
    if (_otp.length == _otpLength && !context.read<AuthBloc>().state.isLoading) {
      context.read<AuthBloc>().add(
        VerifyOtp(loginId: widget.loginId, otp: _otp, otpReason: widget.otpReason),
      );
    }
  }

  void _onResend() {
    _otpController.clear();
    setState(() {});
    _otpFocusNode.requestFocus();
    context.read<AuthBloc>().add(SendOtp(loginId: widget.loginId, otpReason: widget.otpReason));
  }
}
