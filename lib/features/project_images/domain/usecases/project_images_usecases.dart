import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/project_image_entity.dart';
import '../repositories/project_images_repository.dart';

class GetProjectImagesUseCase {
  final ProjectImagesRepository repository;

  GetProjectImagesUseCase(this.repository);

  Future<Either<Failure, List<ProjectImageEntity>>> call(String projectId) {
    return repository.getProjectImages(projectId);
  }
}

class UploadProjectImageUseCase {
  final ProjectImagesRepository repository;

  UploadProjectImageUseCase(this.repository);

  Future<Either<Failure, ProjectImageEntity>> call({
    required String projectId,
    required String name,
    required String imagePath,
  }) {
    return repository.uploadProjectImage(
      projectId: projectId,
      name: name,
      imagePath: imagePath,
    );
  }
}

class DeleteProjectImageUseCase {
  final ProjectImagesRepository repository;

  DeleteProjectImageUseCase(this.repository);

  Future<Either<Failure, bool>> call(int id) {
    return repository.deleteProjectImage(id);
  }
}
