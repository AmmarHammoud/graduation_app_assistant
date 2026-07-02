import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final int userId;
  final int? projectId;
  final int? projectWorkItemId;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final String? readAt;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    this.projectId,
    this.projectWorkItemId,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    this.readAt,
    this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Helper to create a copy of the notification with optional overrides.
  NotificationEntity copyWith({
    int? id,
    int? userId,
    int? projectId,
    int? projectWorkItemId,
    String? type,
    String? title,
    String? body,
    bool? isRead,
    String? readAt,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
      projectWorkItemId: projectWorkItemId ?? this.projectWorkItemId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        projectId,
        projectWorkItemId,
        type,
        title,
        body,
        isRead,
        readAt,
        data,
        createdAt,
        updatedAt,
      ];
}
