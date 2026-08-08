import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/visualization_comment.dart';
import '../repositories/visualizations_repository.dart';

class AddVisualizationComment {
  final VisualizationsRepository repository;

  AddVisualizationComment(this.repository);

  Future<Either<Failure, VisualizationComment>> call(int aiVisualizationId, String comment) {
    return repository.addVisualizationComment(aiVisualizationId, comment);
  }
}
