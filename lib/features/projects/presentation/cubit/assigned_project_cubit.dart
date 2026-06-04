import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app_assistant/features/projects/domain/usecases/get_projects.dart';
import '../../domain/entities/assigned_project.dart';
import 'assigned_project_state.dart';

class AssignedProjectsCubit extends Cubit<AssignedProjectsState> {
  final GetProjects getProjects;

  AssignedProjectsCubit({required this.getProjects}) : super(AssignedProjectsInitial());

  Future<void> loadDashboard(String filter) async {
    emit(AssignedProjectsLoading());

    final result = await getProjects(filter: filter);
    print('-------------------------------------------------------------------');
    print(result);

    result.fold(
          (failure) => emit(AssignedProjectsError(failure.errMessage)),
          (projects) {
        // App-side filtering logic based on the selected tab
        final filteredList = projects.where((p) {
          if (filter == 'منجز') return p.statusText == 'منجز';
          if (filter == 'قيد التنفيذ') return p.statusText == 'قيد التنفيذ';
          return true; // 'الكل'
        }).toList();

        emit(AssignedProjectsLoaded(
          allProjects: projects,
          filteredProjects: filteredList,
          activeFilter: filter,
        ));
      },
    );
  }
}