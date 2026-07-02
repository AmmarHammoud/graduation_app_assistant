import '../../domain/entities/duration_extension_result.dart';

class DurationExtensionModel extends DurationExtensionResult {
  const DurationExtensionModel({
    required super.id,
    required super.projectId,
    required super.workItemId,
    required super.status,
    required super.requestedDurationDays,
    required super.reason,
    super.comment,
    required super.requesterName,
    super.reviewedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DurationExtensionModel.fromJson(Map<String, dynamic> json) {
    final requester = json['requester'] as Map<String, dynamic>?;
    final requesterName = requester != null ? requester['name'] as String? ?? 'مساعد' : 'مساعد';

    return DurationExtensionModel(
      id: json['id'] as int? ?? 0,
      projectId: json['project_id'] as int? ?? 0,
      workItemId: json['work_item_id'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      requestedDurationDays: json['requested_duration_days'] as int? ?? 0,
      reason: json['reason'] as String? ?? '',
      comment: json['comment'] as String?,
      requesterName: requesterName,
      reviewedAt: json['reviewed_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}
