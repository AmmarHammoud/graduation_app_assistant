import 'project_space_model.dart';

class ProjectSpacesResponse {
  final int status;
  final String message;
  final List<ProjectSpaceModel> data;

  const ProjectSpacesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProjectSpacesResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawData = json['data'] as List<dynamic>? ?? [];
    return ProjectSpacesResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: rawData.map((e) => ProjectSpaceModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class GypsumSpacesResponse {
  final int status;
  final String message;
  final List<ProjectSpaceModel> data;

  const GypsumSpacesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GypsumSpacesResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawData = json['data'] as List<dynamic>? ?? [];
    return GypsumSpacesResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: rawData.map((e) => ProjectSpaceModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class SanitarySpacesResponse {
  final int status;
  final String message;
  final List<ProjectSpaceModel> data;

  const SanitarySpacesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SanitarySpacesResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawData = json['data'] as List<dynamic>? ?? [];
    return SanitarySpacesResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: rawData.map((e) => ProjectSpaceModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class CeramicSpacesResponse {
  final int status;
  final String message;
  final List<ProjectSpaceModel> data;

  const CeramicSpacesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CeramicSpacesResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawData = json['data'] as List<dynamic>? ?? [];
    return CeramicSpacesResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: rawData.map((e) => ProjectSpaceModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
