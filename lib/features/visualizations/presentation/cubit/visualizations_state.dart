import 'package:equatable/equatable.dart';
import '../../domain/entities/ai_visualization.dart';

abstract class VisualizationsState extends Equatable {
  const VisualizationsState();

  @override
  List<Object?> get props => [];
}

class VisualizationsInitial extends VisualizationsState {}

class VisualizationsLoading extends VisualizationsState {}

class VisualizationsLoaded extends VisualizationsState {
  final List<AIVisualization> allVisualizations;
  final List<AIVisualization> filteredVisualizations;
  final String searchQuery;

  const VisualizationsLoaded({
    required this.allVisualizations,
    required this.filteredVisualizations,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [allVisualizations, filteredVisualizations, searchQuery];

  VisualizationsLoaded copyWith({
    List<AIVisualization>? allVisualizations,
    List<AIVisualization>? filteredVisualizations,
    String? searchQuery,
  }) {
    return VisualizationsLoaded(
      allVisualizations: allVisualizations ?? this.allVisualizations,
      filteredVisualizations: filteredVisualizations ?? this.filteredVisualizations,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class VisualizationsError extends VisualizationsState {
  final String message;

  const VisualizationsError({required this.message});

  @override
  List<Object?> get props => [message];
}
