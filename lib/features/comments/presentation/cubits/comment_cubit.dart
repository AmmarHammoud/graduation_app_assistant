import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_comment_usecase.dart';
import '../../domain/usecases/get_comments_usecase.dart';
import '../../domain/entities/comment_entity.dart';
import 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;

  CommentCubit({
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
  }) : super(CommentInitial());

  Future<void> loadComments({required int workItemId}) async {
    emit(CommentLoading());

    final result = await getCommentsUseCase(workItemId: workItemId);

    result.fold(
      (failure) => emit(CommentError(message: failure.errMessage)),
      (comments) => emit(CommentLoaded(comments: comments)),
    );
  }

  Future<void> addComment({
    required int workItemId,
    required String comment,
  }) async {
    final currentState = state;
    List<CommentEntity> previousComments = [];
    if (currentState is CommentLoaded) {
      previousComments = currentState.comments;
    } else if (currentState is CommentSending) {
      previousComments = currentState.currentComments;
    }

    emit(CommentSending(currentComments: previousComments));

    final result = await addCommentUseCase(
      workItemId: workItemId,
      comment: comment,
    );

    result.fold(
      (failure) {
        emit(CommentError(message: failure.errMessage));
        emit(CommentLoaded(comments: previousComments));
      },
      (newComment) {
        final List<CommentEntity> updatedList = List.from(previousComments)..add(newComment);
        emit(CommentSendSuccess(newComment: newComment));
        emit(CommentLoaded(comments: updatedList));
      },
    );
  }
}
