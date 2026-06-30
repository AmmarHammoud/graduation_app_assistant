import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/ai_visualization_entity.dart';
import '../../domain/repositories/ai_visualization_repository.dart';
import '../datasources/ai_visualization_remote_data_source.dart';

class AiVisualizationRepositoryImpl implements AiVisualizationRepository {
  final AiVisualizationRemoteDataSource remoteDataSource;

  AiVisualizationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AiVisualizationEntity>>> getVisualizations(String projectId) async {
    try {
      final remoteModels = await remoteDataSource.getVisualizations(projectId);
      return Right(remoteModels);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AiVisualizationEntity>> createVisualization({
    required int projectImageId,
    required String prompt,
    List<String>? referenceImages,
  }) async {
    try {
      final remoteModel = await remoteDataSource.createVisualization(
        projectImageId: projectImageId,
        prompt: prompt,
        referenceImages: referenceImages,
      );
      return Right(remoteModel);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
