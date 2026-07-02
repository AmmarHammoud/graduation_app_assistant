import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_duration_extension.dart';
import 'duration_extension_state.dart';

class DurationExtensionCubit extends Cubit<DurationExtensionState> {
  final SubmitDurationExtension submitDurationExtension;

  DurationExtensionCubit({required this.submitDurationExtension})
      : super(DurationExtensionInitial());

  Future<void> submit({
    required String projectId,
    required String workItemId,
    required int requestedDurationDays,
    required String reason,
  }) async {
    emit(DurationExtensionSubmitting());
    final result = await submitDurationExtension(
      projectId: projectId,
      workItemId: workItemId,
      requestedDurationDays: requestedDurationDays,
      reason: reason,
    );
    result.fold(
      (failure) => emit(DurationExtensionFailure(failure.errMessage)),
      (successResult) => emit(DurationExtensionSuccess(successResult)),
    );
  }
}
