import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ai_visualization_entity.dart';

abstract class AiVisualizationRepository {
  Future<Either<Failure, List<AiVisualizationEntity>>> getVisualizations(String projectId);
  Future<Either<Failure, AiVisualizationEntity>> createVisualization({
    required int projectImageId,
    required String prompt,
    List<String>? referenceImages,
  });
}
