import 'package:graduation_app_assistant/features/projects/data/models/project_details_model.dart';

import '../../../../core/services/database_service.dart';
import '../../../../core/utils/backend_endpoints.dart';
import '../models/assigned_project_model.dart';

abstract class AssignedProjectsDataSource {
  Future<List<AssignedProjectModel>> fetchAssignedProjects({String? filter});
  Future<ProjectDetailsModel> fetchAssignedProjectDetails(String projectId);
}

class AssignedProjectsRemoteDataSource implements AssignedProjectsDataSource {
  final DatabaseService _databaseService;

  AssignedProjectsRemoteDataSource({required DatabaseService databaseService})
      : _databaseService = databaseService;

  @override
  Future<List<AssignedProjectModel>> fetchAssignedProjects({String? filter}) async {
    // Artificial delay to simulate smooth server network connectivity
    await Future.delayed(const Duration(milliseconds: 800));

    // Explicitly matching payloads to your design image specifications
    final mockResponse = [
      {
        "id": "11",
        "name": "المشروع رقم 11",
        "location": "دمشق - المزة",
        "status": "in_progress",
        "progress_percent": 46,
        "active_items_count": 3
      },
      {
        "id": "14",
        "name": "المشروع رقم 14",
        "location": "دمشق - مشروع دمر",
        "status": "in_progress",
        "progress_percent": 20,
        "active_items_count": 2
      },
      {
        "id": "15",
        "name": "المشروع رقم 15",
        "location": "دمشق - كفرسوسة",
        "status": "not_started",
        "progress_percent": 0,
        "active_items_count": 0
      }
    ];

    return mockResponse.map((json) => AssignedProjectModel.fromJson(json)).toList();
  }

  @override
  Future<ProjectDetailsModel> fetchAssignedProjectDetails(String projectId) async {
    // TODO: implement fetchAssignedProjectDetails
    // throw UnimplementedError();

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