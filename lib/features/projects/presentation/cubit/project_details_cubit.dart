import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_project_details.dart';
import 'project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  final GetProjectDetails getProjectDetails;

  ProjectDetailsCubit({required this.getProjectDetails}) : super(ProjectDetailsInitial());

  Future<void> loadProjectDetails(String id) async {
    emit(ProjectDetailsLoading());
    final result = await getProjectDetails(id);
    result.fold(
          (failure) => emit(ProjectDetailsError(failure.errMessage)),
          (details) => emit(ProjectDetailsLoaded(details)),
    );
  }
}