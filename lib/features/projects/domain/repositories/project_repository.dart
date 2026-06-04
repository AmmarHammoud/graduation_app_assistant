import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/proejct_details.dart';
import '../entities/project.dart';

abstract class ProjectRepository {
  Future< Adil<Failure, List<Project>>> getProjects({String? filter});
  Future<Either<Failure, ProjectDetails>> getProjectDetails(String id);
}
// Using standard Either implementation via dartz
typedef Adil<L, R> = Either<L, R>;