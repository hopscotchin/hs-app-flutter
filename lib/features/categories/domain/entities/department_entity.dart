import 'package:equatable/equatable.dart';

class DepartmentEntity extends Equatable {
  final String id;
  final String label;
  final String? imageUrl;
  final String? actionUrl;

  const DepartmentEntity({
    required this.id,
    required this.label,
    this.imageUrl,
    this.actionUrl,
  });

  @override
  List<Object?> get props => [id, label, imageUrl, actionUrl];
}
