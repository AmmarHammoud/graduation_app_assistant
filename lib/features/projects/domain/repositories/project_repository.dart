import 'package:dartz/dartz.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_project.dart';
import '../../../../core/errors/failures.dart';
import '../entities/proejct_details.dart';

abstract class ProjectRepository {
  Future< Adil<Failure, List<AssignedProject>>> getProjects({String? filter});
  Future<Either<Failure, ProjectDetails>> getProjectDetails(String id);
}
// Using standard Either implementation via dartz
typedef Adil<L, R> = Either<L, R>;