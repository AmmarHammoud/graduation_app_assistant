import 'package:equatable/equatable.dart';
import '../../domain/entities/proejct_details.dart';

abstract class ProjectDetailsState extends Equatable {
  const ProjectDetailsState();
  @override
  List<Object?> get props => [];
}

class ProjectDetailsInitial extends ProjectDetailsState {}
class ProjectDetailsLoading extends ProjectDetailsState {}
class ProjectDetailsLoaded extends ProjectDetailsState {
  final ProjectDetails details;
  const ProjectDetailsLoaded(this.details);
  @override
  List<Object?> get props => [details];
}
class ProjectDetailsError extends ProjectDetailsState {
  final String message;
  const ProjectDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}