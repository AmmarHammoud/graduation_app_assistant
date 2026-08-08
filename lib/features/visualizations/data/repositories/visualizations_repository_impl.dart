import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/ai_visualization.dart';
import '../../domain/entities/visualization_comment.dart';
import '../../domain/repositories/visualizations_repository.dart';
import '../datasources/visualizations_remote_data_source.dart';

class VisualizationsRepositoryImpl implements VisualizationsRepository {
  final VisualizationsRemoteDataSource remoteDataSource;

  VisualizationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AIVisualization>>> getProjectVisualizations(String projectId) async {
    try {
      final list = await remoteDataSource.fetchVisualizations(projectId);
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر جلب تصاميم الذكاء الاصطناعي للمشروع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<VisualizationComment>>> getVisualizationComments(int aiVisualizationId) async {
    try {
      final list = await remoteDataSource.fetchComments(aiVisualizationId);
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر جلب تعليقات التصميم: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, VisualizationComment>> addVisualizationComment(int aiVisualizationId, String comment) async {
    try {
      final res = await remoteDataSource.addComment(aiVisualizationId, comment);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر إضافة التعليق: ${e.toString()}"));
    }
  }
}
