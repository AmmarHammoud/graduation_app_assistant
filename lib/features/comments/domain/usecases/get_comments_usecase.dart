import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository repository;

  GetCommentsUseCase(this.repository);

  Future<Either<Failure, List<CommentEntity>>> call({required int workItemId}) {
    return repository.getComments(workItemId: workItemId);
  }
}
