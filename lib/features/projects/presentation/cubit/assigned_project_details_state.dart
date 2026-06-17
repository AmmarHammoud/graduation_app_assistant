import 'package:equatable/equatable.dart';
import 'package:graduation_app_assistant/features/projects/domain/entities/assigned_proejct_details.dart';

abstract class AssignedProjectDetailsState extends Equatable {
  const AssignedProjectDetailsState();
  @override
  List<Object?> get props => [];
}

class AssignedProjectDetailsInitial extends AssignedProjectDetailsState {}
class AssignedProjectDetailsLoading extends AssignedProjectDetailsState {}
class AssignedProjectDetailsLoaded extends AssignedProjectDetailsState {
  final AssignedProjectDetails details;
  const AssignedProjectDetailsLoaded(this.details);
  @override
  List<Object?> get props => [details];
}
class AssignedProjectDetailsError extends AssignedProjectDetailsState {
  final String message;
  const AssignedProjectDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}