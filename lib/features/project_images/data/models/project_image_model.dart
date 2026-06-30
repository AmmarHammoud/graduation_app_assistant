import '../../domain/entities/project_image_entity.dart';

class ProjectImageModel extends ProjectImageEntity {
  const ProjectImageModel({
    required super.id,
    required super.projectId,
    required super.name,
    required super.imageUrl,
    required super.createdAt,
  });

  factory ProjectImageModel.fromJson(Map<String, dynamic> json) {
    return ProjectImageModel(
      id: json['id'] as int? ?? 0,
      projectId: (json['project_id'] ?? '').toString(),
      name: json['name'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'name': name,
      'image': imageUrl,
      'created_at': createdAt,
    };
  }
}
