import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class AddCommentUseCase {
  final CommentRepository repository;

  AddCommentUseCase(this.repository);

  Future<Either<Failure, CommentEntity>> call({
    required int workItemId,
    required String comment,
  }) {
    return repository.addComment(workItemId: workItemId, comment: comment);
  }
}
