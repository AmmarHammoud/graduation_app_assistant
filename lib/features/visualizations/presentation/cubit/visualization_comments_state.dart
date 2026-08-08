import 'package:equatable/equatable.dart';
import '../../domain/entities/visualization_comment.dart';

abstract class VisualizationCommentsState extends Equatable {
  const VisualizationCommentsState();

  @override
  List<Object?> get props => [];
}

class VisualizationCommentsInitial extends VisualizationCommentsState {}

class VisualizationCommentsLoading extends VisualizationCommentsState {}

class VisualizationCommentsLoaded extends VisualizationCommentsState {
  final List<VisualizationComment> comments;

  const VisualizationCommentsLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class VisualizationCommentsError extends VisualizationCommentsState {
  final String message;

  const VisualizationCommentsError(this.message);

  @override
  List<Object?> get props => [message];
}
