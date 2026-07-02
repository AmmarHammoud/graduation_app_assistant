import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    super.projectId,
    super.projectWorkItemId,
    required super.type,
    required super.title,
    required super.body,
    required super.isRead,
    super.readAt,
    super.data,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      projectId: json['project_id'] as int?,
      projectWorkItemId: json['project_work_item_id'] as int?,
      type: json['type'] as String? ?? 'notification',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      isRead: _parseBool(json['is_read']),
      readAt: json['read_at'] as String?,
      data: json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : null,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'project_id': projectId,
      'project_work_item_id': projectWorkItemId,
      'type': type,
      'title': title,
      'body': body,
      'is_read': isRead,
      'read_at': readAt,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return false;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}
