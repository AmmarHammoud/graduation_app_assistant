import 'package:equatable/equatable.dart';

class AssignedProjectDetails extends Equatable {
  final String id;
  final String title;
  final String location;
  final String statusText;
  final double progressPercentage;
  final String areaText;
  final String heightText;
  final String supervisorName;
  final List<AssistantWorkItemEntity> workItems;

  const AssignedProjectDetails({
    required this.id,
    required this.title,
    required this.location,
    required this.statusText,
    required this.progressPercentage,
    required this.areaText,
    required this.heightText,
    required this.supervisorName,
    required this.workItems,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    location,
    statusText,
    progressPercentage,
    areaText,
    heightText,
    supervisorName,
    workItems,
  ];
}

class AssistantWorkItemEntity extends Equatable {
  final int id;
  final int sequenceNumber;
  final String name;
  final String statusLabel; // "مكتمل", "قيد التنفيذ", "لم يبدأ"
  final double completionPercent;
  final int commentCount;
  final bool canUpdate; // true if it shows the "تحديث" button

  const AssistantWorkItemEntity({
    required this.id,
    required this.sequenceNumber,
    required this.name,
    required this.statusLabel,
    required this.completionPercent,
    required this.commentCount,
    required this.canUpdate,
  });

  @override
  List<Object?> get props => [
    id,
    sequenceNumber,
    name,
    statusLabel,
    completionPercent,
    commentCount,
    canUpdate,
  ];
}