import 'package:equatable/equatable.dart';

class ProjectImageEntity extends Equatable {
  final int id;
  final String projectId;
  final String name;
  final String imageUrl;
  final String createdAt;

  const ProjectImageEntity({
    required this.id,
    required this.projectId,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, projectId, name, imageUrl, createdAt];
}
