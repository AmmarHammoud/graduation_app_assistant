import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ai_visualization.dart';
import '../entities/visualization_comment.dart';

abstract class VisualizationsRepository {
  Future<Either<Failure, List<AIVisualization>>> getProjectVisualizations(String projectId);
  Future<Either<Failure, List<VisualizationComment>>> getVisualizationComments(int aiVisualizationId);
  Future<Either<Failure, VisualizationComment>> addVisualizationComment(int aiVisualizationId, String comment);
}
