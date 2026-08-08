import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_project_visualizations.dart';
import 'visualizations_state.dart';

class VisualizationsCubit extends Cubit<VisualizationsState> {
  final GetProjectVisualizations getProjectVisualizations;

  VisualizationsCubit({required this.getProjectVisualizations}) : super(VisualizationsInitial());

  Future<void> loadVisualizations(String projectId) async {
    emit(VisualizationsLoading());
    final result = await getProjectVisualizations(projectId);
    result.fold(
      (failure) => emit(VisualizationsError(message: failure.errMessage)),
      (list) => emit(VisualizationsLoaded(
        allVisualizations: list,
        filteredVisualizations: list,
      )),
    );
  }

  void searchVisualizations(String query) {
    final currentState = state;
    if (currentState is VisualizationsLoaded) {
      if (query.trim().isEmpty) {
        emit(currentState.copyWith(
          filteredVisualizations: currentState.allVisualizations,
          searchQuery: '',
        ));
        return;
      }

      final filtered = currentState.allVisualizations.where((vis) {
        final titleMatch = vis.title.toLowerCase().contains(query.toLowerCase());
        final descMatch = vis.description.toLowerCase().contains(query.toLowerCase());
        return titleMatch || descMatch;
      }).toList();

      emit(currentState.copyWith(
        filteredVisualizations: filtered,
        searchQuery: query,
      ));
    }
  }
}
