import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ai_visualization.dart';
import '../repositories/visualizations_repository.dart';

class GetProjectVisualizations {
  final VisualizationsRepository repository;

  GetProjectVisualizations(this.repository);

  Future<Either<Failure, List<AIVisualization>>> call(String projectId) {
    return repository.getProjectVisualizations(projectId);
  }
}
