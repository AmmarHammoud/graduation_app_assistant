import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/project_image_entity.dart';
import '../../domain/repositories/project_images_repository.dart';
import '../datasources/project_images_remote_data_source.dart';

class ProjectImagesRepositoryImpl implements ProjectImagesRepository {
  final ProjectImagesRemoteDataSource remoteDataSource;

  ProjectImagesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProjectImageEntity>>> getProjectImages(String projectId) async {
    try {
      final remoteModels = await remoteDataSource.getProjectImages(projectId);
      return Right(remoteModels);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectImageEntity>> uploadProjectImage({
    required String projectId,
    required String name,
    required String imagePath,
  }) async {
    try {
      final remoteModel = await remoteDataSource.uploadProjectImage(
        projectId: projectId,
        name: name,
        imagePath: imagePath,
      );
      return Right(remoteModel);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProjectImage(int id) async {
    try {
      final result = await remoteDataSource.deleteProjectImage(id);
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
