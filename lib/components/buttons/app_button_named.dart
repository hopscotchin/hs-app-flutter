import 'package:hs_app_flutter/components/buttons/app_button.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';

class PrimaryButton extends AppButton {
  const PrimaryButton.defaultType({
    super.key,
    required super.text,
    super.onTap,
    super.isFullWidth = false,
    super.size = ButtonSize.medium,
    super.state = ButtonState.enabled,
    super.leadingIcon,
    super.trailingIcon,
  }) : super(variant: ButtonVariant.primary, styleType: ButtonStyleType.defaultType);

  const PrimaryButton.hover({
    super.key,
    required super.text,
    super.onTap,
    super.isFullWidth = false,
    super.size = ButtonSize.medium,
    super.state = ButtonState.enabled,
    super.leadingIcon,
    super.trailingIcon,
  }) : super(variant: ButtonVariant.primary, styleType: ButtonStyleType.hover);

  const PrimaryButton.inactive({
    super.key,
    required super.text,
    super.onTap,
    super.isFullWidth = false,
    super.size = ButtonSize.medium,
    super.state = ButtonState.enabled,
    super.leadingIcon,
    super.trailingIcon,
  }) : super(variant: ButtonVariant.primary, styleType: ButtonStyleType.inactive);
}

class SecondaryButton extends AppButton {
  const SecondaryButton.defaultType({
    super.key,
    required super.text,
    super.onTap,
    super.isFullWidth = false,
    super.size = ButtonSize.medium,
    super.state = ButtonState.enabled,
    super.leadingIcon,
    super.trailingIcon,
  }) : super(variant: ButtonVariant.secondary, styleType: ButtonStyleType.defaultType);

  const SecondaryButton.hover({
    super.key,
    required super.text,
    super.onTap,
    super.isFullWidth = false,
    super.size = ButtonSize.medium,
    super.state = ButtonState.enabled,
    super.leadingIcon,
    super.trailingIcon,
  }) : super(variant: ButtonVariant.secondary, styleType: ButtonStyleType.hover);

  const SecondaryButton.inactive({
    super.key,
    required super.text,
    super.onTap,
    super.isFullWidth = false,
    super.size = ButtonSize.medium,
    super.state = ButtonState.enabled,
    super.leadingIcon,
    super.trailingIcon,
  }) : super(variant: ButtonVariant.secondary, styleType: ButtonStyleType.inactive);
}

class TertiaryButton extends AppButton {
  const TertiaryButton.defaultType({
    super.key,
    required super.text,
    super.onTap,
    super.isFullWidth = false,
    super.size = ButtonSize.medium,
    super.state = ButtonState.enabled,
    super.leadingIcon,
    super.trailingIcon,
  }) : super(variant: ButtonVariant.tertiary, styleType: ButtonStyleType.defaultType);

  const TertiaryButton.hover({
    super.key,
    required super.text,
    super.onTap,
    super.isFullWidth = false,
    super.size = ButtonSize.medium,
    super.state = ButtonState.enabled,
    super.leadingIcon,
    super.trailingIcon,
  }) : super(variant: ButtonVariant.tertiary, styleType: ButtonStyleType.hover);

  const TertiaryButton.inactive({
    super.key,
    required super.text,
    super.onTap,
    super.isFullWidth = false,
    super.size = ButtonSize.medium,
    super.state = ButtonState.enabled,
    super.leadingIcon,
    super.trailingIcon,
  }) : super(variant: ButtonVariant.tertiary, styleType: ButtonStyleType.inactive);
}

class LinkButton extends AppButton {
  const LinkButton({
    super.key,
    required super.text,
    super.onTap,
    super.size = ButtonSize.medium,
    super.state = ButtonState.enabled,
  }) : super(variant: ButtonVariant.link);
}

class LinkSmallButton extends AppButton {
  const LinkSmallButton({
    super.key,
    required super.text,
    super.onTap,
    super.size = ButtonSize.small,
    super.state = ButtonState.enabled,
  }) : super(variant: ButtonVariant.linksmall);
}
