import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../components/atoms/filled_text_field.dart' show MobileNumberFormatter;
import '../../../../components/atoms/outlined_text_field.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_screen_header.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/navigation/action_url_handler.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.initialMobile, this.initialMessageBars = const []});

  final String? initialMobile;
  final List<MessageBarEntity> initialMessageBars;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _inputController = TextEditingController();
  final _inputFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late List<MessageBarEntity> _pendingMessageBars;

  @override
  void initState() {
    super.initState();
    _pendingMessageBars = widget.initialMessageBars;
    final mobile = widget.initialMobile;
    if (mobile != null && mobile.length == 10) {
      _inputController.text = '${mobile.substring(0, 5)} ${mobile.substring(5)}';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _inputFocusNode.requestFocus());
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  String get _rawMobile => _inputController.text.replaceAll(RegExp(r'\D'), '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (prev, curr) => curr.isOtpSent && !prev.isOtpSent,
        listener: (context, state) {
          if (!ModalRoute.of(context)!.isCurrent) return;
          AppNavigator.goToOtpVerification(
            context,
            bloc: context.read<AuthBloc>(),
            loginId: _rawMobile,
            otpConfig: state.otpConfig!,
            otpReason: 'SIGN_IN',
          );
        },
        builder: (context, state) {
          final isLoading = state.isLoading;

          void onMessageAction(String? link, MessageBarEntity bar) {
            final destination = ActionUrlHandler.parse(link ?? '');
            if (destination == null || destination is LoginDestination) return;
            destination.navigate(context);
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthScreenHeader(
                  title: AuthStrings.signInTitle,
                  leading: SizedBox(
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: SvgPicture.asset(ImageConstants.arrowBack),
                    ),
                  ),
                ),
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
                            style: MessageBarsStyle.compact(),
                            onAction: onMessageAction,
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
                            label: AuthStrings.sendOtp,
                            isLoading: isLoading,
                            onPressed: _onSendOtp,
                          ),
                          AppSpacing.verticalGapMd,

                          AppSpacing.verticalGapXl,
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

  Widget _buildMobileField() {
    return OutlinedTextField(
      controller: _inputController,
      focusNode: _inputFocusNode,
      labelText: AuthStrings.mobileNumberTitle,
      keyboardType: TextInputType.phone,
      maxLength: 11,
      prefixText: '+91 ',
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d ]')),
        MobileNumberFormatter(),
      ],
      validator: (value) {
        final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
        if (digits.isEmpty) return AuthStrings.validateMobile;
        if (digits.length != 10) {
          return AuthStrings.validateMobileFormat;
        }
        return null;
      },
    );
  }

  void _onSendOtp() {
    if (_formKey.currentState!.validate()) {
      setState(() => _pendingMessageBars = const []);
      context.read<AuthBloc>().add(SendOtp(loginId: _rawMobile));
    }
  }
}
