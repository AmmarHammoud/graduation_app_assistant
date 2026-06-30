import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/project_image_entity.dart';

abstract class ProjectImagesRepository {
  Future<Either<Failure, List<ProjectImageEntity>>> getProjectImages(String projectId);
  Future<Either<Failure, ProjectImageEntity>> uploadProjectImage({
    required String projectId,
    required String name,
    required String imagePath,
  });
  Future<Either<Failure, bool>> deleteProjectImage(int id);
}
