import 'package:equatable/equatable.dart';

class VisualCueEntity extends Equatable {
  final String? bgColor;
  final String? text;
  final String? textColor;
  final String? location;
  final String? uiType;
  final String? imageUrl;

  const VisualCueEntity({
    this.bgColor,
    this.text,
    this.textColor,
    this.location,
    this.uiType,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    bgColor,
    text,
    textColor,
    location,
    uiType,
    imageUrl,
  ];
}
