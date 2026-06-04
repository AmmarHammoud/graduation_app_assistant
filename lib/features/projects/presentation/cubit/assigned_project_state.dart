import 'package:equatable/equatable.dart';
import '../../domain/entities/assigned_project.dart';

abstract class AssignedProjectsState extends Equatable {
  const AssignedProjectsState();
  @override
  List<Object?> get props => [];
}

class AssignedProjectsInitial extends AssignedProjectsState {}
class AssignedProjectsLoading extends AssignedProjectsState {}

class AssignedProjectsLoaded extends AssignedProjectsState {
  final List<AssignedProject> allProjects;
  final List<AssignedProject> filteredProjects;
  final String activeFilter; // 'الكل', 'قيد التنفيذ', 'منجز'

  const AssignedProjectsLoaded({
    required this.allProjects,
    required this.filteredProjects,
    required this.activeFilter,
  });

  @override
  List<Object?> get props => [allProjects, filteredProjects, activeFilter];
}

class AssignedProjectsError extends AssignedProjectsState {
  final String message;
  const AssignedProjectsError(this.message);
  @override
  List<Object?> get props => [message];
}