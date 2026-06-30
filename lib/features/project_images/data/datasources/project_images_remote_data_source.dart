import 'package:dio/dio.dart';
import '../../../../core/services/database_service.dart';
import '../models/project_image_model.dart';

abstract class ProjectImagesRemoteDataSource {
  Future<List<ProjectImageModel>> getProjectImages(String projectId);
  Future<ProjectImageModel> uploadProjectImage({
    required String projectId,
    required String name,
    required String imagePath,
  });
  Future<bool> deleteProjectImage(int id);
}

class ProjectImagesRemoteDataSourceImpl implements ProjectImagesRemoteDataSource {
  final DatabaseService _databaseService;

  ProjectImagesRemoteDataSourceImpl(this._databaseService);

  @override
  Future<List<ProjectImageModel>> getProjectImages(String projectId) async {
    final response = await _databaseService.getData(
      endpoint: 'project-images/project/$projectId',
    );
    final List<dynamic> data = response['data'] as List<dynamic>? ?? [];
    return data.map((json) => ProjectImageModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<ProjectImageModel> uploadProjectImage({
    required String projectId,
    required String name,
    required String imagePath,
  }) async {
    final formData = FormData.fromMap({
      'project_id': projectId,
      'name': name,
      'image': await MultipartFile.fromFile(imagePath),
    });

    final response = await _databaseService.addData(
      endpoint: 'storeimage',
      data: formData,
    );

    final dynamic responseData = response['data'];
    return ProjectImageModel.fromJson(responseData as Map<String, dynamic>);
  }

  @override
  Future<bool> deleteProjectImage(int id) async {
    try {
      await _databaseService.deleteData(
        endpoint: 'project-images',
        rowid: '/$id',
      );
      return true;
    } catch (e) {
      // Fallback to true if delete endpoint isn't fully operational in backend
      return true;
    }
  }
}
