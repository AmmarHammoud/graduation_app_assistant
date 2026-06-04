import 'package:dartz/dartz.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_project.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/project_repository.dart';

class GetProjects {
  final ProjectRepository repository;

  GetProjects(this.repository);

  Future<Either<Failure, List<AssignedProject>>> call({String? filter}) async {
    return await repository.getProjects(filter: filter);
  }
}