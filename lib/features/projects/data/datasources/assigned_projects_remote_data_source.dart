import 'package:graduation_app_assistant/features/projects/data/models/assigned_project_details_model.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/utils/backend_endpoints.dart';
import '../models/work_item_update_details.dart';
import '../models/assigned_project_model.dart';
import '../models/project_space_model.dart';
import '../models/space_responses.dart';

abstract class AssignedProjectsDataSource {
  Future<List<AssignedProjectModel>> fetchAssignedProjects({String? filter});
  Future<AssignedProjectDetailsModel> fetchAssignedProjectDetails(String projectId);
  // Append these two method signatures onto your existing abstract AssignedProjectsDataSource interface:
  Future<WorkItemUpdateDetailsModel> fetchWorkItemUpdateDetails(String itemId);
  Future<bool> submitSubSpaceProgressUpdate({
    required String itemId,
    required String spaceName,
    required List<String> localImagePaths,
  });
  Future<List<ProjectSpaceModel>> fetchProjectSpaces(String projectId);
  Future<GypsumSpacesResponse> fetchGypsumSpaces(String projectId);
  Future<SanitarySpacesResponse> fetchSanitarySpaces(String projectId);
  Future<CeramicSpacesResponse> fetchCeramicSpaces(String projectId);
}

class AssignedProjectsRemoteDataSource implements AssignedProjectsDataSource {
  final DatabaseService _databaseService;

  AssignedProjectsRemoteDataSource(this._databaseService);

  @override
  Future<List<AssignedProjectModel>> fetchAssignedProjects({String? filter}) async {
    final response = await _databaseService.getData(endpoint: BackendEndPoint.projects);
    final List<dynamic> projectsList = response['data'] as List<dynamic>;
    return projectsList.map((json) => AssignedProjectModel.fromJson(json)).toList();
  }

  @override
  Future<AssignedProjectDetailsModel> fetchAssignedProjectDetails(String projectId) async {
    // TODO: Switch to live API endpoint execution when backend goes live:
    final response = await _databaseService.getData(endpoint: '${BackendEndPoint.projects}/$projectId/progress');
    return AssignedProjectDetailsModel.fromJson(response);
  }

  @override
  Future<WorkItemUpdateDetailsModel> fetchWorkItemUpdateDetails(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Simulating endpoint matching exactly with screenshot components
    return WorkItemUpdateDetailsModel.fromJson({
      "item_id": int.tryParse(itemId) ?? 3,
      "item_name": "صحية سواد",
      "percent": 75,
      "delay_warning": "يوجد تأخير في إنجاز بند صحية سواد يرجى تقديم طلب تمديد موضحاً الأسباب.",
      "sub_spaces": [
        {
          "name": "مطبخ (Kitchen)",
          "status": "completed",
          "media_url": "kitchen_final.jpg",
          "date": "12/25/2023"
        },
        {
          "name": "مطبخ (Kitchen)",
          "status": "completed",
          "media_url": "kitchen_final.jpg",
          "date": "12/25/2024"
        },
        {
          "name": "مرحاض (Toilet)",
          "status": "under_review",
          "media_url": null,
          "date": null
        }
      ],
      "comments": [
        {
          "author": "محمد علي",
          "text": "تم إنجاز الحمام والمطابخ بنجاح، بانتظار توريد قطع دورة المياه.",
          "time": "اليوم"
        },
        {
          "author": "محمد علي",
          "text": "يوجد نقص بسيط في بعض الوصلات الخاصة بالمرحاض، تم التواصل مع المورد لتوفيرها في أقرب وقت.",
          "time": "أمس"
        }
      ]
    });
  }

  @override
  Future<bool> submitSubSpaceProgressUpdate({
    required String itemId,
    required String spaceName,
    required List<String> localImagePaths,
  }) async {
    // Simulated multi-part upload form submission cycle
    await Future.delayed(const Duration(milliseconds: 1200));
    return true;
  }

  @override
  Future<List<ProjectSpaceModel>> fetchProjectSpaces(String projectId) async {
    final response = await _databaseService.getData(
      endpoint: '${BackendEndPoint.projects}/$projectId/spaces',
    );
    final List<dynamic> spacesList = response['data'] as List<dynamic>? ?? [];
    return spacesList.map((json) => ProjectSpaceModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<GypsumSpacesResponse> fetchGypsumSpaces(String projectId) async {
    final response = await _databaseService.getData(
      endpoint: '${BackendEndPoint.projects}/$projectId/spaces/gypsum',
    );
    return GypsumSpacesResponse.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<SanitarySpacesResponse> fetchSanitarySpaces(String projectId) async {
    final response = await _databaseService.getData(
      endpoint: '${BackendEndPoint.projects}/$projectId/spaces/sanitary',
    );
    return SanitarySpacesResponse.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<CeramicSpacesResponse> fetchCeramicSpaces(String projectId) async {
    final response = await _databaseService.getData(
      endpoint: '${BackendEndPoint.projects}/$projectId/spaces/ceramic',
    );
    return CeramicSpacesResponse.fromJson(response as Map<String, dynamic>);
  }
}