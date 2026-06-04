import 'package:equatable/equatable.dart';

class ProjectDetails extends Equatable {
  final String title;
  final String statusText;
  final String areaText;
  final String heightText;
  final double totalCompletionPercentage;
  final List<ProjectSpaceEntity> spaces;
  final List<ProjectPhaseEntity> workItems;

  const ProjectDetails({
    required this.title,
    required this.statusText,
    required this.areaText,
    required this.heightText,
    required this.totalCompletionPercentage,
    required this.spaces,
    required this.workItems,
  });

  @override
  List<Object?> get props => [
    title,
    statusText,
    areaText,
    heightText,
    totalCompletionPercentage,
    spaces,
    workItems,
  ];
}

class ProjectSpaceEntity extends Equatable {
  final int id;
  final String name;
  final String statusLabel; // e.g., "مكتمل", "قيد العمل"
  final Map<String, String> specifications; // Keys for card metrics dynamically mapped

  const ProjectSpaceEntity({
    required this.id,
    required this.name,
    required this.statusLabel,
    required this.specifications,
  });

  @override
  List<Object?> get props => [id, name, statusLabel, specifications];
}

class ProjectPhaseEntity extends Equatable {
  final int id;
  final int order;
  final String name;
  final String statusLabel; // e.g., "قيد التنفيذ", "مخطط له", "مكتمل"
  final double completionPercent;

  const ProjectPhaseEntity({
    required this.id,
    required this.order,
    required this.name,
    required this.statusLabel,
    required this.completionPercent,
  });

  @override
  List<Object?> get props => [id, order, name, statusLabel, completionPercent];
}