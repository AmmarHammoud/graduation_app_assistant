import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/proejct_details.dart';
import '../repositories/project_repository.dart';

class GetProjectDetails {
  final ProjectRepository repository;

  GetProjectDetails(this.repository);

  Future<Either<Failure, ProjectDetails>> call(String projectId) async {
    // Note: Add an abstract declaration `Future<Either<Failure, ProjectDetails>> getProjectDetails(String id);`
    // to your abstract ProjectRepository file.
    return await repository.getProjectDetails(projectId);
  }
}