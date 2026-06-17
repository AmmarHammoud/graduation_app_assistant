import 'package:graduation_app_assistant/features/projects/data/models/assigned_project_details_model.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/utils/backend_endpoints.dart';
import '../models/assigned_project_model.dart';

abstract class AssignedProjectsDataSource {
  Future<List<AssignedProjectModel>> fetchAssignedProjects({String? filter});
  Future<AssignedProjectDetailsModel> fetchAssignedProjectDetails(String projectId);
}

class AssignedProjectsRemoteDataSource implements AssignedProjectsDataSource {
  final DatabaseService _databaseService;

  AssignedProjectsRemoteDataSource({required DatabaseService databaseService})
      : _databaseService = databaseService;

  @override
  Future<List<AssignedProjectModel>> fetchAssignedProjects({String? filter}) async {
    final response = await _databaseService.getData(endpoint: BackendEndPoint.projects);
    final List<dynamic> projectsList = response['data'] as List<dynamic>;
    return projectsList.map((json) => AssignedProjectModel.fromJson(json)).toList();

    await Future.delayed(const Duration(milliseconds: 800));

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
  Future<AssignedProjectDetailsModel> fetchAssignedProjectDetails(String projectId) async {
    // TODO: Switch to live API endpoint execution when backend goes live:
    final response = await _databaseService.getData(endpoint: '${BackendEndPoint.projects}/$projectId/progress');
    return AssignedProjectDetailsModel.fromJson(response);

    await Future.delayed(const Duration(milliseconds: 500));

    // Live backend JSON layout payload injected for localized preview testing
    return AssignedProjectDetailsModel.fromJson({
      "status": 200,
      "message": "Project progress fetched",
      "data": {
        "id": int.tryParse(projectId) ?? 1,
        "name": "المشروع رقم 11", // Overridden with localization layout string matches
        "project_percent": 46, // Adjusted from 0 to 46 for visual parity with design specs
        "items": [
          {"id": 1, "name": "ملابن الأبواب", "percent": 100, "weight": "1.00", "details": [null]},
          {"id": 2, "name": "تمديدات كهرباء", "percent": 100, "weight": "1.00", "details": []},
          {"id": 3, "name": "تمديدات صحية", "percent": 66, "weight": "1.00", "details": [null, null]},
          {"id": 4, "name": "طينة / لياسة", "percent": 40, "weight": "1.00", "details": [null]},
          {"id": 5, "name": "سيراميك جدران / أسقف", "percent": 33, "weight": "1.00", "details": []},
          {"id": 6, "name": "بلاط أرضيات", "percent": 0, "weight": "1.00", "details": []},
          {"id": 7, "name": "أبواب ونجارة", "percent": 0, "weight": "1.00", "details": []}
        ]
      }
    });
  }
}