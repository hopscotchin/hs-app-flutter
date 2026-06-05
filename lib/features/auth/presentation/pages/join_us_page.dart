import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/filled_text_field.dart' show MobileNumberFormatter;
import '../widgets/auth_footer_link_row.dart';
import '../../../../components/atoms/outlined_text_field.dart';
import '../widgets/auth_primary_button.dart';
import '../../../../components/appbar/hs_appbar.dart';
import '../widgets/auth_terms_disclaimer.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/navigation/action_url_handler.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../bloc/auth_bloc.dart';

class JoinUsPage extends StatefulWidget {
  final String? initialMobile;
  final String? redirectType;

  const JoinUsPage({super.key, this.initialMobile, this.redirectType});

  @override
  State<JoinUsPage> createState() => _JoinUsPageState();
}

class _JoinUsPageState extends State<JoinUsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final mobile = widget.initialMobile;
    if (mobile != null && mobile.length == 10) {
      _mobileController.text = '${mobile.substring(0, 5)} ${mobile.substring(5)}';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _nameFocusNode.requestFocus());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  String get _rawMobile => _mobileController.text.replaceAll(RegExp(r'\D'), '');
  bool _showErrors = false;

  void _onFieldChanged(String _) {
    if (_showErrors) {
      _showErrors = false;
      _formKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      appBar: HsAppbar(title: AuthStrings.joinUs, onLeadingTap: () => Navigator.of(context).pop()),
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            (curr.isOtpSent && !prev.isOtpSent) ||
            (curr.isRedirectLinkFound && !prev.isRedirectLinkFound),
        listener: (context, state) {
          if (!ModalRoute.of(context)!.isCurrent) return;
          if (state.isOtpSent) {
            AppNavigator.goToOtpVerification(
              context,
              bloc: context.read<AuthBloc>(),
              loginId: _rawMobile,
              otpConfig: state.otpConfig!,
              otpReason: 'SIGN_UP',
              redirectType: widget.redirectType,
            );
          } else if (state.isRedirectLinkFound) {
            ActionUrlHandler.navigate(
              context,
              state.redirectLink,
              extra: {'messageBars': state.messageBars},
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.isLoading;
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.isError && state.messageBars.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: MessageBarsWidget(messageBars: state.messageBars, cardStyle: true),
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
                          OutlinedTextField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            labelText: AuthStrings.fullName,
                            keyboardType: TextInputType.name,
                            onChanged: _onFieldChanged,
                            validator: (value) {
                              if (!_showErrors) return null;
                              if (value == null || value.trim().isEmpty) {
                                return AuthStrings.validateFullName;
                              }
                              return null;
                            },
                          ),
                          AppSpacing.verticalGapMd,
                          OutlinedTextField(
                            controller: _emailController,
                            labelText: AuthStrings.emailAddress,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: _onFieldChanged,
                            validator: (value) {
                              if (!_showErrors) return null;
                              if (value == null || value.trim().isEmpty) {
                                return AuthStrings.validateEmail;
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$',
                              ).hasMatch(value.trim())) {
                                return AuthStrings.validateEmailFormat;
                              }
                              return null;
                            },
                          ),
                          AppSpacing.verticalGapMd,
                          OutlinedTextField(
                            controller: _mobileController,
                            labelText: AuthStrings.mobileNumberTitle,
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            prefixText: '+91 ',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              const MobileNumberFormatter(),
                            ],
                            helperText: AuthStrings.verifyNumberHint,
                            onChanged: _onFieldChanged,
                            validator: (value) {
                              if (!_showErrors) return null;
                              final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                              if (digits.isEmpty) {
                                return AuthStrings.validateMobile;
                              }
                              if (digits.length != 10) {
                                return AuthStrings.validateMobileFormat;
                              }
                              return null;
                            },
                          ),
                          AppSpacing.verticalGapLg,
                          AuthPrimaryButton(
                            label: AuthStrings.sendOtp,
                            isLoading: isLoading,
                            onPressed: _onSendOtp,
                          ),
                          AppSpacing.verticalGapXl,
                          const Center(child: AuthTermsDisclaimer()),
                          AppSpacing.verticalGapLg,
                          AuthFooterLinkRow(
                            promptText: AuthStrings.haveAccount,
                            actionLabel: AuthStrings.signIn,
                            onActionTap: () => AppNavigator.goToLogin(
                              context,
                              initialMobile: _rawMobile.length == 10 ? _rawMobile : null,
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
      ),
    );
  }

  void _onSendOtp() {
    _showErrors = true;
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        Register(
          displayName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          mobile: _rawMobile,
        ),
      );
    }
  }
}
