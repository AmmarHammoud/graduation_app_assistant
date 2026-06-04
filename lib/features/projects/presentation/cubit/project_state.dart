import 'package:equatable/equatable.dart';
import '../../domain/entities/project.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();
  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}
class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<Project> projects;
  final String activeFilter;

  const ProjectLoaded({required this.projects, required this.activeFilter});

  @override
  List<Object?> get props => [projects, activeFilter];
}

class ProjectError extends ProjectState {
  final String message;
  const ProjectError({required this.message});

  @override
  List<Object?> get props => [message];
}