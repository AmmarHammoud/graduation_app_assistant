
import '../../domain/entities/assigned_proejct_details.dart';

class AssignedProjectDetailsModel extends AssignedProjectDetails {
  const AssignedProjectDetailsModel({
    required super.id,
    required super.title,
    required super.location,
    required super.statusText,
    required super.progressPercentage,
    required super.areaText,
    required super.heightText,
    required super.supervisorName,
    required super.workItems,
  });

  factory AssignedProjectDetailsModel.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? matchingProject,
    String? projectId,
  }) {
    // Safely extract the list of work items
    final List<dynamic> rawItems = json['data'] is List<dynamic>
        ? json['data'] as List<dynamic>
        : (json['data'] is Map<String, dynamic> &&
                (json['data'] as Map<String, dynamic>).containsKey('items'))
            ? (json['data'] as Map<String, dynamic>)['items'] as List<dynamic>
            : [];

    // Track task sequencing on the app-side using list indices
    int currentOrder = 1;
    final parsedItems = rawItems.map((item) {
      final double rawPercent = (item['percent'] as num? ?? 0).toDouble();

      // Map status flags dynamically based on the status field or percentage values
      String statusLabel = 'لم يبدأ';
      bool canUpdate = false;

      final String rawStatus = item['status'] as String? ?? '';
      if (rawStatus == 'ongoing' || (rawPercent > 0.0 && rawPercent < 100.0)) {
        statusLabel = 'قيد التنفيذ';
        canUpdate = true;
      } else if (rawStatus == 'completed' || rawPercent >= 100.0) {
        statusLabel = 'مكتمل';
      }

      return AssistantWorkItemEntity(
        id: item['id'] as int? ?? 0,
        sequenceNumber: currentOrder++,
        name: item['name'] as String? ?? 'بند غير مسمى',
        statusLabel: statusLabel,
        // Convert to fractional representation if backend serves raw integers (e.g., 46 -> 0.46)
        completionPercent: rawPercent > 1.0 ? rawPercent / 100.0 : rawPercent,
        commentCount: (item['details'] as List<dynamic>? ?? []).length, // Safely counting sub-details arrays as comments for UI mock matching
        canUpdate: canUpdate,
      );
    }).toList();

    // Overall project percent calculation
    double rawProjectPercent = 0.0;
    if (matchingProject != null && matchingProject['progress_percent'] != null) {
      rawProjectPercent = (matchingProject['progress_percent'] as num).toDouble();
    } else if (json['data'] is Map<String, dynamic> &&
        (json['data'] as Map<String, dynamic>).containsKey('project_percent')) {
      rawProjectPercent = ((json['data'] as Map<String, dynamic>)['project_percent'] as num? ?? 0).toDouble();
    }

    final String areaVal = matchingProject != null && matchingProject['apartment_area'] != null
        ? matchingProject['apartment_area'].toString()
        : (json['data'] is Map<String, dynamic> ? (json['data'] as Map<String, dynamic>)['area']?.toString() ?? '120' : '120');

    final String heightVal = matchingProject != null && matchingProject['height'] != null
        ? matchingProject['height'].toString()
        : (json['data'] is Map<String, dynamic> ? (json['data'] as Map<String, dynamic>)['height']?.toString() ?? '2.8' : '2.8');

    String supervisorNameVal = 'أحمد حمدان';
    if (matchingProject != null) {
      if (matchingProject['owner'] != null && matchingProject['owner']['name'] != null) {
        supervisorNameVal = matchingProject['owner']['name'].toString();
      } else if (matchingProject['project_manager'] != null && matchingProject['project_manager']['name'] != null) {
        supervisorNameVal = matchingProject['project_manager']['name'].toString();
      } else if (matchingProject['supervisor'] != null) {
        supervisorNameVal = matchingProject['supervisor'].toString();
      }
    } else if (json['data'] is Map<String, dynamic> && (json['data'] as Map<String, dynamic>)['supervisor'] != null) {
      supervisorNameVal = (json['data'] as Map<String, dynamic>)['supervisor'] as String;
    }

    String projIdVal = projectId ?? '';
    if (projIdVal.isEmpty && rawItems.isNotEmpty && rawItems.first is Map<String, dynamic>) {
      projIdVal = (rawItems.first['project_id'] ?? '').toString();
    }
    if (projIdVal.isEmpty && json['data'] is Map<String, dynamic>) {
      projIdVal = ((json['data'] as Map<String, dynamic>)['id'] ?? '').toString();
    }

    final String projTitleVal = matchingProject != null
        ? matchingProject['name'] as String? ?? 'المشروع الحالي'
        : (json['data'] is Map<String, dynamic> ? (json['data'] as Map<String, dynamic>)['name'] as String? ?? 'المشروع الحالي' : 'المشروع الحالي');

    final String projLocationVal = matchingProject != null
        ? matchingProject['location'] as String? ?? 'منطقة المزة، دمشق'
        : (json['data'] is Map<String, dynamic> ? (json['data'] as Map<String, dynamic>)['location'] as String? ?? 'منطقة المزة، دمشق' : 'منطقة المزة، دمشق');

    return AssignedProjectDetailsModel(
      id: projIdVal,
      title: projTitleVal,
      location: projLocationVal,
      statusText: rawProjectPercent >= 100.0 ? 'مكتمل' : 'قيد التنفيذ',
      progressPercentage: rawProjectPercent > 1.0 ? rawProjectPercent / 100.0 : rawProjectPercent,
      areaText: "$areaVal م²",
      heightText: "$heightVal م",
      supervisorName: supervisorNameVal,
      workItems: parsedItems,
    );
  }
}