import 'package:dartz/dartz.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/duration_extension_result.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/project_repository.dart';

class SubmitDurationExtension {
  final ProjectRepository repository;

  SubmitDurationExtension(this.repository);

  Future<Either<Failure, DurationExtensionResult>> call({
    required String projectId,
    required String workItemId,
    required int requestedDurationDays,
    required String reason,
  }) async {
    return await repository.submitDurationExtension(
      projectId: projectId,
      workItemId: workItemId,
      requestedDurationDays: requestedDurationDays,
      reason: reason,
    );
  }
}
