import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ai_visualization_entity.dart';
import '../repositories/ai_visualization_repository.dart';

class GetVisualizationsUseCase {
  final AiVisualizationRepository repository;

  GetVisualizationsUseCase(this.repository);

  Future<Either<Failure, List<AiVisualizationEntity>>> call(String projectId) {
    return repository.getVisualizations(projectId);
  }
}

class CreateVisualizationUseCase {
  final AiVisualizationRepository repository;

  CreateVisualizationUseCase(this.repository);

  Future<Either<Failure, AiVisualizationEntity>> call({
    required int projectImageId,
    required String prompt,
    List<String>? referenceImages,
  }) {
    return repository.createVisualization(
      projectImageId: projectImageId,
      prompt: prompt,
      referenceImages: referenceImages,
    );
  }
}
