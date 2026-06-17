import 'package:equatable/equatable.dart';

class VisualProductInfoEntity extends Equatable {
  final String? groupName;
  final List<VisualProductItemEntity> items;
  final String? title;

  const VisualProductInfoEntity({
    this.groupName,
    this.items = const [],
    this.title,
  });

  @override
  List<Object?> get props => [groupName, items, title];
}

class VisualProductItemEntity extends Equatable {
  final String? id;
  final String? name;
  final String? type;
  final String? url;

  const VisualProductItemEntity({this.id, this.name, this.type, this.url});

  @override
  List<Object?> get props => [id, name, type, url];
}
