import 'package:dartz/dartz.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_proejct_details.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/project_repository.dart';

class GetProjectDetails {
  final ProjectRepository repository;

  GetProjectDetails(this.repository);

  Future<Either<Failure, AssignedProjectDetails>> call(String projectId) async {
    // Note: Add an abstract declaration `Future<Either<Failure, ProjectDetails>> getProjectDetails(String id);`
    // to your abstract ProjectRepository file.
    return await repository.getProjectDetails(projectId);
  }
}