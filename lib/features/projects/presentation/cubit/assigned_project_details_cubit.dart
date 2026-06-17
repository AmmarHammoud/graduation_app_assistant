import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_project_details.dart';
import 'assigned_project_details_state.dart';

class AssignedProjectDetailsCubit extends Cubit<AssignedProjectDetailsState> {
  final GetProjectDetails getProjectDetails;

  AssignedProjectDetailsCubit({required this.getProjectDetails}) : super(AssignedProjectDetailsInitial());

  Future<void> loadProjectDetails(String id) async {
    emit(AssignedProjectDetailsLoading());
    final result = await getProjectDetails(id);
    result.fold(
          (failure) => emit(AssignedProjectDetailsError(failure.errMessage)),
          (details) => emit(AssignedProjectDetailsLoaded(details)),
    );
  }
}