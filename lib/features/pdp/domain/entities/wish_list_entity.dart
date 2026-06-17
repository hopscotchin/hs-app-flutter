import 'package:equatable/equatable.dart';

class WishListEntity extends Equatable {
  final String? id;
  final bool? status;

  const WishListEntity({this.id, this.status});

  @override
  List<Object?> get props => [id, status];
}
