import 'package:equatable/equatable.dart';

class CommentUserEntity extends Equatable {
  final int id;
  final String name;
  final String internalId;

  const CommentUserEntity({
    required this.id,
    required this.name,
    required this.internalId,
  });

  @override
  List<Object?> get props => [id, name, internalId];
}

class CommentWorkItemEntity extends Equatable {
  final int id;
  final String name;

  const CommentWorkItemEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class CommentEntity extends Equatable {
  final int id;
  final String comment;
  final String createdAt;
  final CommentUserEntity user;
  final CommentWorkItemEntity workItem;

  const CommentEntity({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.user,
    required this.workItem,
  });

  @override
  List<Object?> get props => [id, comment, createdAt, user, workItem];
}
