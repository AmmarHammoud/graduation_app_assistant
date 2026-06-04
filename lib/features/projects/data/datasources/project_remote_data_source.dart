import '../../../../core/services/database_service.dart';
import '../../../../core/utils/backend_endpoints.dart';
import '../models/project_details_model.dart';
import '../models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> fetchProjects({String? filter});
  Future<ProjectDetailsModel> fetchProjectDetails(String projectId);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final DatabaseService _databaseService;

  ProjectRemoteDataSourceImpl({required DatabaseService databaseService})
      : _databaseService = databaseService;

  @override
  Future<List<ProjectModel>> fetchProjects({String? filter}) async {
    try {
      final response = await _databaseService.getData(endpoint: BackendEndPoint.projects);
      final List<dynamic> projectsList = response['data'] as List<dynamic>;
      return projectsList.map((json) => ProjectModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch projects: $e');
    }
  }

  @override
  Future<ProjectDetailsModel> fetchProjectDetails(String projectId) async {
    try {
      // Coordinate both endpoints concurrently
      final responses = await Future.wait([
        _databaseService.getData(endpoint: '${BackendEndPoint.projects}/$projectId/${BackendEndPoint.projectSpaces}'),
        _databaseService.getData(endpoint: '${BackendEndPoint.projects}/$projectId/${BackendEndPoint.projectWorkItems}'),
      ]);

      final Map<String, dynamic> spacesResponse = responses[0] as Map<String, dynamic>;
      final Map<String, dynamic> workItemsResponse = responses[1] as Map<String, dynamic>;

      return ProjectDetailsModel.fromSplitJson(
        spacesJson: spacesResponse,
        workItemsJson: workItemsResponse,
      );
    } catch (e) {
      throw Exception('تعذر جلب تفاصيل المشروع التفاعلية: $e');
    }
  }
}