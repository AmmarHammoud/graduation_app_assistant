import 'package:equatable/equatable.dart';

class WorkItemUpdateDetails extends Equatable {
  final int itemId;
  final String itemName;
  final double currentPercent;
  final String? delayWarningMessage;
  final List<SubSpaceItemEntity> subSpaces;
  final List<UpdateCommentEntity> managerComments;

  const WorkItemUpdateDetails({
    required this.itemId,
    required this.itemName,
    required this.currentPercent,
    this.delayWarningMessage,
    required this.subSpaces,
    required this.managerComments,
  });

  @override
  List<Object?> get props => [itemId, itemName, currentPercent, delayWarningMessage, subSpaces, managerComments];
}

class SubSpaceItemEntity extends Equatable {
  final String spaceName; // e.g., "مطبخ (Kitchen)"
  final String statusLabel; // "مكتمل", "قيد المراجعة", "لم يتم الرفع"
  final String? uploadedMediaUrl;
  final String? uploadDate;

  const SubSpaceItemEntity({
    required this.spaceName,
    required this.statusLabel,
    this.uploadedMediaUrl,
    this.uploadDate,
  });

  @override
  List<Object?> get props => [spaceName, statusLabel, uploadedMediaUrl, uploadDate];
}

class UpdateCommentEntity extends Equatable {
  final String authorName;
  final String commentText;
  final String relativeTime;

  const UpdateCommentEntity({
    required this.authorName,
    required this.commentText,
    required this.relativeTime,
  });

  @override
  List<Object?> get props => [authorName, commentText, relativeTime];
}