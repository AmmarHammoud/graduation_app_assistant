import 'package:equatable/equatable.dart';

class ProjectSpace extends Equatable {
  final int id;
  final int? projectId;
  final String type;
  final String? wallArea;
  final String? wallFinishType;
  final String? ceilingFinishType;
  final String? toiletType;
  final String? ceilingArea;
  final bool? isShedFloorTiled;
  final String? createdAt;
  final String? updatedAt;

  const ProjectSpace({
    required this.id,
    this.projectId,
    required this.type,
    this.wallArea,
    this.wallFinishType,
    this.ceilingFinishType,
    this.toiletType,
    this.ceilingArea,
    this.isShedFloorTiled,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        type,
        wallArea,
        wallFinishType,
        ceilingFinishType,
        toiletType,
        ceilingArea,
        isShedFloorTiled,
        createdAt,
        updatedAt,
      ];
}
