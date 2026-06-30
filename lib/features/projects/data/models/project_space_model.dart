import '../../domain/entities/project_space.dart';

class ProjectSpaceModel extends ProjectSpace {
  const ProjectSpaceModel({
    required super.id,
    super.projectId,
    required super.type,
    super.wallArea,
    super.wallFinishType,
    super.ceilingFinishType,
    super.toiletType,
    super.ceilingArea,
    super.isShedFloorTiled,
    super.createdAt,
    super.updatedAt,
  });

  factory ProjectSpaceModel.fromJson(Map<String, dynamic> json) {
    return ProjectSpaceModel(
      id: json['id'] as int? ?? 0,
      projectId: json['project_id'] as int?,
      type: json['type'] as String? ?? '',
      wallArea: json['wall_area']?.toString(),
      wallFinishType: json['wall_finish_type'] as String?,
      ceilingFinishType: json['ceiling_finish_type'] as String?,
      toiletType: json['toilet_type'] as String?,
      ceilingArea: json['ceiling_area']?.toString(),
      isShedFloorTiled: json['is_shed_floor_tiled'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'type': type,
      'wall_area': wallArea,
      'wall_finish_type': wallFinishType,
      'ceiling_finish_type': ceilingFinishType,
      'toilet_type': toiletType,
      'ceiling_area': ceilingArea,
      'is_shed_floor_tiled': isShedFloorTiled,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
