import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/visualization_comment.dart';
import '../repositories/visualizations_repository.dart';

class GetVisualizationComments {
  final VisualizationsRepository repository;

  GetVisualizationComments(this.repository);

  Future<Either<Failure, List<VisualizationComment>>> call(int aiVisualizationId) {
    return repository.getVisualizationComments(aiVisualizationId);
  }
}
