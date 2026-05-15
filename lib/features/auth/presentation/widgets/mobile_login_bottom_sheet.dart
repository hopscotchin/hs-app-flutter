import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/atoms/filled_text_field.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../account/presentation/bloc/account_bloc.dart';
import '../bloc/auth_bloc.dart';

/// Mobile-number entry page used in the checkout auth flow.
///
/// Push this via [AppNavigator.showMobileLoginFlow], which wraps it with the
/// required [BlocProvider] and returns `true` when the user logs in.
class MobileLoginPage extends StatefulWidget {
  const MobileLoginPage({super.key});

  @override
  State<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage> {
  final _inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String get _rawMobile => _inputController.text.replaceAll(RegExp(r'\D'), '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) => curr.isOtpSent && !prev.isOtpSent,
        listener: (context, state) {
          final authBloc = context.read<AuthBloc>();
          final accountBloc = context.read<AccountBloc>();
          context
              .pushNamed<bool>(
                RouteNames.otpVerification,
                extra: <String, dynamic>{
                  'bloc': authBloc,
                  'accountBloc': accountBloc,
                  'loginId': _rawMobile,
                  'otpConfig': state.otpConfig!,
                  'otpReason': 'SIGN_IN',
                  'isCheckoutFlow': true,
                },
              )
              .then((success) {
                if (success == true && context.mounted) {
                  context.pop(true);
                }
              });
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state.isLoading;
            return Column(
              children: [
                if (state.isError && state.messageBars.isNotEmpty)
                  MessageBarsWidget(messageBars: state.messageBars),
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.screenPaddingHorizontal,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpacing.verticalGapMd,
                          Text(
                            AuthStrings.mobileNumberTitle,
                            style: AppTypographyV1.titleLarge.semiBold.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          AppSpacing.verticalGapSm,
                          Text(
                            AuthStrings.mobileShippingHint,
                            style: AppTypographyV1.bodyRegular.regular.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          AppSpacing.verticalGapLg,
                          FilledTextField(
                            controller: _inputController,
                            labelText: AuthStrings.yourNumber,
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[\d ]'),
                              ),
                              MobileNumberFormatter(),
                            ],
                            validator: (value) {
                              final digits = (value ?? '').replaceAll(
                                RegExp(r'\D'),
                                '',
                              );
                              if (digits.isEmpty) {
                                return AuthStrings.validateMobile;
                              }
                              if (digits.length != 10) {
                                return AuthStrings.validateMobileFormat;
                              }
                              return null;
                            },
                          ),
                          AppSpacing.verticalGapSm,
                          SizedBox(
                            width: double.infinity,
                            height: AppSpacing.buttonHeightLg,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                disabledBackgroundColor:
                                    AppColors.secondaryInActive,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppSpacing.borderRadiusXs,
                                ),
                                textStyle: AppTypographyV1.bodyRegular.semiBold,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.onPrimary,
                                      ),
                                    )
                                  : const Text(AuthStrings.continueButton),
                            ),
                          ),
                          AppSpacing.verticalGapXs,
                          Text.rich(
                            TextSpan(
                              text: AuthStrings.termsPrefix,
                              style: AppTypographyV1.labelLarge.regular
                                  .copyWith(color: AppColors.textSecondary),
                              children: [
                                TextSpan(
                                  text: AuthStrings.termsAndConditions,
                                  style: AppTypographyV1.labelLarge.regular
                                      .copyWith(
                                        color: AppColors.textSecondary,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            AppColors.textSecondary,
                                      ),
                                ),
                                TextSpan(
                                  text: AuthStrings.termsAnd,
                                  style: AppTypographyV1.labelLarge.regular
                                      .copyWith(color: AppColors.textSecondary),
                                ),
                                TextSpan(
                                  text: AuthStrings.privacyPolicy,
                                  style: AppTypographyV1.labelLarge.regular
                                      .copyWith(
                                        color: AppColors.textSecondary,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(SendOtp(loginId: _rawMobile));
    }
  }
}
