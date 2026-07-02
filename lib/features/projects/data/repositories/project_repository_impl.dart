import 'package:dartz/dartz.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_proejct_details.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_project.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/project_space.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/duration_extension_result.dart';
import '../../../../core/errors/failures.dart';
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
  Future<Either<Failure, AssignedProjectDetails>> getProjectDetails(String projectId) async {
    try {
      final remoteDetails = await remoteDataSource.fetchAssignedProjectDetails(projectId);
      return Right(remoteDetails); // Implicitly upcasts from Model to Entity safely
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر تحميل تفاصيل المشروع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<ProjectSpace>>> getProjectSpaces(String projectId) async {
    try {
      final spaces = await remoteDataSource.fetchProjectSpaces(projectId);
      return Right(spaces);
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر تحميل مساحات المشروع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<ProjectSpace>>> getGypsumSpaces(String projectId) async {
    try {
      final response = await remoteDataSource.fetchGypsumSpaces(projectId);
      return Right(response.data);
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر تحميل مساحات الجبس للمشروع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<ProjectSpace>>> getSanitarySpaces(String projectId) async {
    try {
      final response = await remoteDataSource.fetchSanitarySpaces(projectId);
      return Right(response.data);
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر تحميل المساحات الصحية للمشروع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<ProjectSpace>>> getCeramicSpaces(String projectId) async {
    try {
      final response = await remoteDataSource.fetchCeramicSpaces(projectId);
      return Right(response.data);
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر تحميل مساحات السيراميك للمشروع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, DurationExtensionResult>> submitDurationExtension({
    required String projectId,
    required String workItemId,
    required int requestedDurationDays,
    required String reason,
  }) async {
    try {
      final model = await remoteDataSource.submitDurationExtension(
        projectId: projectId,
        workItemId: workItemId,
        requestedDurationDays: requestedDurationDays,
        reason: reason,
      );
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(errMessage: "تعذر تقديم طلب تمديد الوقت: ${e.toString()}"));
    }
  }
}