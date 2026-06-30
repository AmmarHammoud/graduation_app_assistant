import 'package:equatable/equatable.dart';
import '../../domain/entities/comment_entity.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<CommentEntity> comments;

  const CommentLoaded({required this.comments});

  @override
  List<Object?> get props => [comments];
}

class CommentSending extends CommentState {
  final List<CommentEntity> currentComments;

  const CommentSending({required this.currentComments});

  @override
  List<Object?> get props => [currentComments];
}

class CommentSendSuccess extends CommentState {
  final CommentEntity newComment;

  const CommentSendSuccess({required this.newComment});

  @override
  List<Object?> get props => [newComment];
}

class CommentError extends CommentState {
  final String message;

  const CommentError({required this.message});

  @override
  List<Object?> get props => [message];
}
