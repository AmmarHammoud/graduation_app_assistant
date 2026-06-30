import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_data_source.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CommentEntity>>> getComments({required int workItemId}) async {
    try {
      final models = await remoteDataSource.getComments(workItemId: workItemId);
      return Right(models);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> addComment({
    required int workItemId,
    required String comment,
  }) async {
    try {
      final model = await remoteDataSource.addComment(workItemId: workItemId, comment: comment);
      return Right(model);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
