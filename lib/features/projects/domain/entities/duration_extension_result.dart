import 'package:equatable/equatable.dart';

class DurationExtensionResult extends Equatable {
  final int id;
  final int projectId;
  final int workItemId;
  final String status;
  final int requestedDurationDays;
  final String reason;
  final String? comment;
  final String requesterName;
  final String? reviewedAt;
  final String createdAt;
  final String updatedAt;

  const DurationExtensionResult({
    required this.id,
    required this.projectId,
    required this.workItemId,
    required this.status,
    required this.requestedDurationDays,
    required this.reason,
    this.comment,
    required this.requesterName,
    this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        workItemId,
        status,
        requestedDurationDays,
        reason,
        comment,
        requesterName,
        reviewedAt,
        createdAt,
        updatedAt,
      ];
}
