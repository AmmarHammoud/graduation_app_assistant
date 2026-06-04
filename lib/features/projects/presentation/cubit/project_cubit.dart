import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_projects.dart';
import '../../domain/entities/project.dart';
import 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final GetProjects getProjects;

  ProjectCubit({required this.getProjects}) : super(ProjectInitial());

  Future<void> loadProjects(String filter) async {
    emit(ProjectLoading());

    final result = await getProjects(filter: filter);

    result.fold(
          (failure) => emit(ProjectError(message: failure.errMessage)),
          (projects) {
        // App-side filtering logic based on the selected tab
        final filteredList = projects.where((p) {
          if (filter == 'منجز') return p.status == ProjectStatus.completed;
          if (filter == 'قيد التنفيذ') return p.status == ProjectStatus.inProgress;
          return true; // 'الكل'
        }).toList();

        emit(ProjectLoaded(projects: filteredList, activeFilter: filter));
      },
    );
  }
}