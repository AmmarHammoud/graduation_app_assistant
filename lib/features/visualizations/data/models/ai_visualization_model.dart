
import '../../../../core/utils/backend_endpoints.dart';
import '../../domain/entities/ai_visualization.dart';

class AIVisualizationModel extends AIVisualization {
  const AIVisualizationModel({
    required super.id,
    required super.generatedImage,
    required super.createdAt,
    required super.title,
    required super.description,
  });

  factory AIVisualizationModel.fromJson(Map<String, dynamic> json) {
    final rawImage = json['generated_image'] as String? ?? '';
    
    // Check if the image starts with /storage/ or http. If it's a relative path, we can prefix it.
    final String fullImage;
    if (rawImage.startsWith('/')) {
      fullImage = '${BackendEndPoint.baseUrl}$rawImage';
    } else {
      fullImage = rawImage;
    }

    final int idVal = json['id'] as int? ?? 0;
    final String titleText = json['title'] as String? ?? 'تصميم ذكاء اصطناعي';
    final String descriptionText = json['description'] as String? ?? '';

    return AIVisualizationModel(
      id: idVal,
      generatedImage: fullImage,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      title: titleText,
      description: descriptionText,
    );
  }
}
