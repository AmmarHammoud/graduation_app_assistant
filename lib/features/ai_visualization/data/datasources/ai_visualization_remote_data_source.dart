import 'package:dio/dio.dart';
import '../../../../core/services/database_service.dart';
import '../models/ai_visualization_model.dart';

abstract class AiVisualizationRemoteDataSource {
  Future<List<AiVisualizationModel>> getVisualizations(String projectId);
  Future<AiVisualizationModel> createVisualization({
    required int projectImageId,
    required String prompt,
    List<String>? referenceImages,
  });
}

class AiVisualizationRemoteDataSourceImpl implements AiVisualizationRemoteDataSource {
  final DatabaseService _databaseService;

  AiVisualizationRemoteDataSourceImpl(this._databaseService);

  @override
  Future<List<AiVisualizationModel>> getVisualizations(String projectId) async {
    final response = await _databaseService.getData(
      endpoint: 'project-images/$projectId/visualizations',
    );
    final List<dynamic> data = response['data'] as List<dynamic>? ?? [];
    return data.map((json) => AiVisualizationModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<AiVisualizationModel> createVisualization({
    required int projectImageId,
    required String prompt,
    List<String>? referenceImages,
  }) async {
    final Map<String, dynamic> fields = {
      'project_image_id': projectImageId,
      'prompt': prompt,
    };

    if (referenceImages != null && referenceImages.isNotEmpty) {
      final List<MultipartFile> files = [];
      for (final path in referenceImages) {
        files.add(await MultipartFile.fromFile(path));
      }
      // 'reference_images[]' is standard array notation for file uploads
      fields['reference_images[]'] = files;
    }

    final formData = FormData.fromMap(fields);

    final response = await _databaseService.addData(
      endpoint: 'ai-visualization',
      data: formData,
    );

    final Map<String, dynamic> responseData = response['data'] as Map<String, dynamic>? ?? {};
    return AiVisualizationModel.fromJson(
      responseData,
      defaultPrompt: prompt,
      defaultProjectImageId: projectImageId,
    );
  }
}
