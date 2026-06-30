import 'package:equatable/equatable.dart';

class AiVisualizationEntity extends Equatable {
  final int id;
  final String generatedImage;
  final String createdAt;
  final String title;
  final String? description;
  final bool isConceptual;
  final String? prompt;
  final int? projectImageId;

  const AiVisualizationEntity({
    required this.id,
    required this.generatedImage,
    required this.createdAt,
    required this.title,
    this.description,
    this.isConceptual = false,
    this.prompt,
    this.projectImageId,
  });

  @override
  List<Object?> get props => [
        id,
        generatedImage,
        createdAt,
        title,
        description,
        isConceptual,
        prompt,
        projectImageId,
      ];
}
