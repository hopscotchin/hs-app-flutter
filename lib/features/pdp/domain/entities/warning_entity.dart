import 'package:equatable/equatable.dart';

class WarningEntity extends Equatable {
  final String? text;
  final String? textColor;

  const WarningEntity({this.text, this.textColor});

  @override
  List<Object?> get props => [text, textColor];
}
