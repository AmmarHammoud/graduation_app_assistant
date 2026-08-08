import '../../domain/entities/visualization_comment.dart';

class VisualizationCommentModel extends VisualizationComment {
  const VisualizationCommentModel({
    required super.id,
    required super.aiVisualizationId,
    required super.userId,
    required super.comment,
    required super.createdAt,
    required super.updatedAt,
    required super.userName,
  });

  factory VisualizationCommentModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] as Map<String, dynamic>?;
    final nameStr = userMap != null ? (userMap['name'] as String? ?? 'مستخدم') : 'صاحب العمل';

    return VisualizationCommentModel(
      id: json['id'] as int? ?? 0,
      aiVisualizationId: json['ai_visualization_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      userName: nameStr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ai_visualization_id': aiVisualizationId,
      'user_id': userId,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  VisualizationComment toEntity() {
    return VisualizationComment(
      id: id,
      aiVisualizationId: aiVisualizationId,
      userId: userId,
      comment: comment,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userName: userName,
    );
  }
}
