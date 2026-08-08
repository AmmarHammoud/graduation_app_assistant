import 'package:equatable/equatable.dart';

class VisualizationComment extends Equatable {
  final int id;
  final int aiVisualizationId;
  final int userId;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userName;

  const VisualizationComment({
    required this.id,
    required this.aiVisualizationId,
    required this.userId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
  });

  @override
  List<Object?> get props => [
        id,
        aiVisualizationId,
        userId,
        comment,
        createdAt,
        updatedAt,
        userName,
      ];
}
