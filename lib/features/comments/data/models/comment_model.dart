import '../../domain/entities/comment_entity.dart';

class CommentUserModel extends CommentUserEntity {
  const CommentUserModel({
    required super.id,
    required super.name,
    required super.internalId,
  });

  factory CommentUserModel.fromJson(Map<String, dynamic> json) {
    return CommentUserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      internalId: json['internal_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'internal_id': internalId,
    };
  }
}

class CommentWorkItemModel extends CommentWorkItemEntity {
  const CommentWorkItemModel({
    required super.id,
    required super.name,
  });

  factory CommentWorkItemModel.fromJson(Map<String, dynamic> json) {
    return CommentWorkItemModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.comment,
    required super.createdAt,
    required CommentUserModel super.user,
    required CommentWorkItemModel super.workItem,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      user: CommentUserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      workItem: CommentWorkItemModel.fromJson(json['work_item'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'created_at': createdAt,
      'user': (user as CommentUserModel).toJson(),
      'work_item': (workItem as CommentWorkItemModel).toJson(),
    };
  }
}
