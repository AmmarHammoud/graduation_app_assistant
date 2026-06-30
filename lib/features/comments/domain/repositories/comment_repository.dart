import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/comment_entity.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<CommentEntity>>> getComments({required int workItemId});
  Future<Either<Failure, CommentEntity>> addComment({required int workItemId, required String comment});
}
