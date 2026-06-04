import 'package:dartz/dartz.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_project.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/proejct_details.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/assigned_projects_remote_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final AssignedProjectsRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AssignedProject>>> getProjects({String? filter}) async {
    try {
      final remoteProjects = await remoteDataSource.fetchAssignedProjects(filter: filter);
      return Right(remoteProjects);
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  // New method override implementation
  @override
  Future<Either<Failure, ProjectDetails>> getProjectDetails(String projectId) async {
    try {
      final remoteDetails = await remoteDataSource.fetchAssignedProjectDetails(projectId);
      return Right(remoteDetails); // Implicitly upcasts from Model to Entity safely
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر تحميل تفاصيل المشروع: ${e.toString()}"));
    }
  }
}