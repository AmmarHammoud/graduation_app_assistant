import 'package:equatable/equatable.dart';

class AIVisualization extends Equatable {
  final int id;
  final String generatedImage;
  final DateTime createdAt;
  final String title;
  final String description;

  const AIVisualization({
    required this.id,
    required this.generatedImage,
    required this.createdAt,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, generatedImage, createdAt, title, description];
}
