import 'package:equatable/equatable.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/duration_extension_result.dart';

abstract class DurationExtensionState extends Equatable {
  const DurationExtensionState();

  @override
  List<Object?> get props => [];
}

class DurationExtensionInitial extends DurationExtensionState {}

class DurationExtensionSubmitting extends DurationExtensionState {}

class DurationExtensionSuccess extends DurationExtensionState {
  final DurationExtensionResult result;

  const DurationExtensionSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class DurationExtensionFailure extends DurationExtensionState {
  final String errorMessage;

  const DurationExtensionFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
