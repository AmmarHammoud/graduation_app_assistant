import 'package:equatable/equatable.dart';
import '../../domain/entities/ai_visualization_entity.dart';

abstract class AiVisualizationState extends Equatable {
  const AiVisualizationState();

  @override
  List<Object?> get props => [];
}

class AiVisualizationInitial extends AiVisualizationState {}

class AiVisualizationLoading extends AiVisualizationState {}

class AiVisualizationLoaded extends AiVisualizationState {
  final List<AiVisualizationEntity> visualizations;

  const AiVisualizationLoaded(this.visualizations);

  @override
  List<Object?> get props => [visualizations];
}

class AiVisualizationSubmitting extends AiVisualizationState {
  final List<AiVisualizationEntity> currentVisualizations;

  const AiVisualizationSubmitting(this.currentVisualizations);

  @override
  List<Object?> get props => [currentVisualizations];
}

class AiVisualizationSubmitSuccess extends AiVisualizationState {
  final List<AiVisualizationEntity> visualizations;
  final AiVisualizationEntity newlyCreated;

  const AiVisualizationSubmitSuccess({
    required this.visualizations,
    required this.newlyCreated,
  });

  @override
  List<Object?> get props => [visualizations, newlyCreated];
}

class AiVisualizationError extends AiVisualizationState {
  final String message;
  final List<AiVisualizationEntity> currentVisualizations;

  const AiVisualizationError({
    required this.message,
    required this.currentVisualizations,
  });

  @override
  List<Object?> get props => [message, currentVisualizations];
}
