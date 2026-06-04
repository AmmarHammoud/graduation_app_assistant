import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/proejct_details.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Project>>> getProjects({String? filter}) async {
    try {
      final remoteProjects = await remoteDataSource.fetchProjects(filter: filter);
      return Right(remoteProjects);
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  // New method override implementation
  @override
  Future<Either<Failure, ProjectDetails>> getProjectDetails(String projectId) async {
    try {
      final remoteDetails = await remoteDataSource.fetchProjectDetails(projectId);
      return Right(remoteDetails); // Implicitly upcasts from Model to Entity safely
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر تحميل تفاصيل المشروع: ${e.toString()}"));
    }
  }
}