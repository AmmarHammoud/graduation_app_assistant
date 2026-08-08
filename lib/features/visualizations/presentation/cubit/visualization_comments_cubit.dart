import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_visualization_comments.dart';
import '../../domain/usecases/add_visualization_comment.dart';
import 'visualization_comments_state.dart';

class VisualizationCommentsCubit extends Cubit<VisualizationCommentsState> {
  final GetVisualizationComments getVisualizationComments;
  final AddVisualizationComment addVisualizationComment;

  VisualizationCommentsCubit({
    required this.getVisualizationComments,
    required this.addVisualizationComment,
  }) : super(VisualizationCommentsInitial());

  Future<void> loadComments(int aiVisualizationId) async {
    emit(VisualizationCommentsLoading());
    final result = await getVisualizationComments(aiVisualizationId);
    result.fold(
      (failure) => emit(VisualizationCommentsError(failure.errMessage)),
      (comments) => emit(VisualizationCommentsLoaded(comments)),
    );
  }

  Future<void> postComment(int aiVisualizationId, String commentText) async {
    final currentState = state;
    final List<dynamic> previousComments = currentState is VisualizationCommentsLoaded 
        ? currentState.comments 
        : [];

    final result = await addVisualizationComment(aiVisualizationId, commentText);
    result.fold(
      (failure) {
        emit(VisualizationCommentsError(failure.errMessage));
        if (previousComments.isNotEmpty) {
          emit(VisualizationCommentsLoaded(List.from(previousComments).cast()));
        }
      },
      (newComment) {
        if (currentState is VisualizationCommentsLoaded) {
          final updatedComments = List<dynamic>.from(currentState.comments)..insert(0, newComment);
          emit(VisualizationCommentsLoaded(updatedComments.cast()));
        } else {
          emit(VisualizationCommentsLoaded([newComment]));
        }
      },
    );
  }
}
