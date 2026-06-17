import 'package:equatable/equatable.dart';

class MessageBarEntity extends Equatable {
  final String? icon;
  final bool hasIcon;
  final String? message;
  final String? messageType;
  final String? backgroundColor;

  const MessageBarEntity({
    this.icon,
    this.hasIcon = false,
    this.message,
    this.messageType,
    this.backgroundColor,
  });

  @override
  List<Object?> get props => [icon, hasIcon, message, messageType, backgroundColor];
}
