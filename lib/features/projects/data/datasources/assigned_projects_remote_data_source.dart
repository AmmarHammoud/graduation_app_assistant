import 'package:dio/dio.dart';
import 'package:graduation_app_assistant/features/projects/data/models/assigned_project_details_model.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/utils/backend_endpoints.dart';
import '../models/work_item_update_details.dart';
import '../models/assigned_project_model.dart';
import '../models/project_space_model.dart';
import '../models/space_responses.dart';
import '../models/duration_extension_model.dart';

abstract class AssignedProjectsDataSource {
  Future<List<AssignedProjectModel>> fetchAssignedProjects({String? filter});
  Future<AssignedProjectDetailsModel> fetchAssignedProjectDetails(String projectId);
  // Append these two method signatures onto your existing abstract AssignedProjectsDataSource interface:
  Future<WorkItemUpdateDetailsModel> fetchWorkItemUpdateDetails({
    required String projectId,
    required String itemId,
    required String itemName,
  });
  Future<bool> submitSubSpaceProgressUpdate({
    required String projectId,
    required String itemId,
    required int spaceId,
    required List<String> localImagePaths,
  });
  Future<bool> submitNumericProgressUpdate({
    required String projectId,
    required String itemId,
    required Map<String, String> payload,
    required List<String> localImagePaths,
  });
  Future<List<ProjectSpaceModel>> fetchProjectSpaces(String projectId);
  Future<GypsumSpacesResponse> fetchGypsumSpaces(String projectId);
  Future<SanitarySpacesResponse> fetchSanitarySpaces(String projectId);
  Future<CeramicSpacesResponse> fetchCeramicSpaces(String projectId);
  Future<DurationExtensionModel> submitDurationExtension({
    required String projectId,
    required String workItemId,
    required int requestedDurationDays,
    required String reason,
  });
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
  Future<WorkItemUpdateDetailsModel> fetchWorkItemUpdateDetails({
    required String projectId,
    required String itemId,
    required String itemName,
  }) async {
    final response = await _databaseService.getData(
      endpoint: '${BackendEndPoint.projects}/$projectId/work-items/$itemId/spaces-progress',
    );

    return WorkItemUpdateDetailsModel.fromResponse(
      json: response as Map<String, dynamic>,
      itemId: int.tryParse(itemId) ?? 0,
      itemName: itemName,
    );
  }

  @override
  Future<bool> submitSubSpaceProgressUpdate({
    required String projectId,
    required String itemId,
    required int spaceId,
    required List<String> localImagePaths,
  }) async {
    if (localImagePaths.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 422,
          data: {'message': 'يرجى اختيار صورة واحدة على الأقل لتوثيق الإنجاز.'},
        ),
      );
    }

    final Map<String, dynamic> dataMap = {
      'completed': 1,
    };

    if (localImagePaths.isNotEmpty) {
      final List<MultipartFile> files = [];
      for (final path in localImagePaths) {
        if (path.isNotEmpty) {
          final fileName = path.split('/').last;
          files.add(await MultipartFile.fromFile(path, filename: fileName));
        }
      }
      dataMap['photos[]'] = files;
    }

    final formData = FormData.fromMap(dataMap);

    final response = await _databaseService.addData(
      endpoint: '${BackendEndPoint.projects}/$projectId/work-items/$itemId/progress-requests/room/$spaceId',
      data: formData,
    );

    if (response is Map<String, dynamic>) {
      final status = response['status'] as int?;
      return status == 201;
    }
    return false;
  }

  @override
  Future<bool> submitNumericProgressUpdate({
    required String projectId,
    required String itemId,
    required Map<String, String> payload,
    required List<String> localImagePaths,
  }) async {
    if (localImagePaths.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 422,
          data: {'message': 'يرجى اختيار صورة واحدة على الأقل لتوثيق الإنجاز.'},
        ),
      );
    }

    final Map<String, dynamic> dataMap = Map<String, dynamic>.from(payload);

    if (localImagePaths.isNotEmpty) {
      final List<MultipartFile> files = [];
      for (final path in localImagePaths) {
        if (path.isNotEmpty) {
          final fileName = path.split('/').last;
          files.add(await MultipartFile.fromFile(path, filename: fileName));
        }
      }
      dataMap['photos[]'] = files;
    }

    final formData = FormData.fromMap(dataMap);

    final response = await _databaseService.addData(
      endpoint: '${BackendEndPoint.projects}/$projectId/work-items/$itemId/progress-requests',
      data: formData,
    );

    if (response is Map<String, dynamic>) {
      final status = response['status'] as int?;
      return status == 201;
    }
    return false;
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

  @override
  Future<DurationExtensionModel> submitDurationExtension({
    required String projectId,
    required String workItemId,
    required int requestedDurationDays,
    required String reason,
  }) async {
    final response = await _databaseService.addData(
      endpoint: '${BackendEndPoint.projects}/$projectId/work-items/$workItemId/duration-extensions',
      data: {
        'requested_duration_days': requestedDurationDays,
        'reason': reason,
      },
    );
    return DurationExtensionModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}