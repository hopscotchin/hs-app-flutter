import 'package:equatable/equatable.dart';

class CartItemMediaEntity extends Equatable {
  final String? mimeType;
  final String? url;

  const CartItemMediaEntity({this.mimeType, this.url});

  bool get isImage => (mimeType ?? '').toUpperCase() == 'IMAGE';

  @override
  List<Object?> get props => [mimeType, url];
}
