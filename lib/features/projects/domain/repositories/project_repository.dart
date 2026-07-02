import 'package:dartz/dartz.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_proejct_details.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_project.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/project_space.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/duration_extension_result.dart';
import '../../../../core/errors/failures.dart';

abstract class ProjectRepository {
  Future< Adil<Failure, List<AssignedProject>>> getProjects({String? filter});
  Future<Either<Failure, AssignedProjectDetails>> getProjectDetails(String id);
  Future<Either<Failure, List<ProjectSpace>>> getProjectSpaces(String projectId);
  Future<Either<Failure, List<ProjectSpace>>> getGypsumSpaces(String projectId);
  Future<Either<Failure, List<ProjectSpace>>> getSanitarySpaces(String projectId);
  Future<Either<Failure, List<ProjectSpace>>> getCeramicSpaces(String projectId);
  Future<Either<Failure, DurationExtensionResult>> submitDurationExtension({
    required String projectId,
    required String workItemId,
    required int requestedDurationDays,
    required String reason,
  });
}
// Using standard Either implementation via dartz
typedef Adil<L, R> = Either<L, R>;