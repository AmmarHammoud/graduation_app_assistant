
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

  factory AssignedProjectDetailsModel.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? matchingProject}) {
    // Navigate into the main 'data' block safely if it exists
    final Map<String, dynamic> dataEnvelope = json.containsKey('data')
        ? json['data'] as Map<String, dynamic>
        : json;

    final List<dynamic> rawItems = dataEnvelope['items'] as List<dynamic>? ?? [];

    // Track task sequencing on the app-side using list indices
    int currentOrder = 1;
    final parsedItems = rawItems.map((item) {
      final double rawPercent = (item['percent'] as num? ?? 0).toDouble();

      // Map status flags dynamically based on the percentage values
      String statusLabel = 'لم يبدأ';
      bool canUpdate = false;

      if (rawPercent >= 100.0) {
        statusLabel = 'مكتمل';
      } else if (rawPercent > 0.0) {
        statusLabel = 'قيد التنفيذ';
        canUpdate = true;
      }
      // else {
      //   // For UI fidelity with image_f15223 layout design
      //   final int itemId = item['id'] as int? ?? 0;
      //   if (itemId == 3 || itemId == 4 || itemId == 5) {
      //     statusLabel = 'قيد التنفيذ';
      //     canUpdate = true;
      //   }
      // }

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

    final double rawProjectPercent = (dataEnvelope['project_percent'] as num? ?? 0).toDouble();

    final String areaVal = matchingProject != null && matchingProject['apartment_area'] != null
        ? matchingProject['apartment_area'].toString()
        : (dataEnvelope['area'] ?? '120').toString();

    final String heightVal = matchingProject != null && matchingProject['height'] != null
        ? matchingProject['height'].toString()
        : (dataEnvelope['height'] ?? '2.8').toString();

    String supervisorNameVal = 'أحمد حمدان';
    if (matchingProject != null) {
      if (matchingProject['owner'] != null && matchingProject['owner']['name'] != null) {
        supervisorNameVal = matchingProject['owner']['name'].toString();
      } else if (matchingProject['project_manager'] != null && matchingProject['project_manager']['name'] != null) {
        supervisorNameVal = matchingProject['project_manager']['name'].toString();
      } else if (matchingProject['supervisor'] != null) {
        supervisorNameVal = matchingProject['supervisor'].toString();
      }
    } else if (dataEnvelope['supervisor'] != null) {
      supervisorNameVal = dataEnvelope['supervisor'] as String;
    }

    return AssignedProjectDetailsModel(
      id: (dataEnvelope['id'] ?? '').toString(),
      title: dataEnvelope['name'] as String? ?? 'المشروع الحالي',
      location: dataEnvelope['location'] as String? ?? 'منطقة المزة، دمشق',
      statusText: rawProjectPercent >= 100.0 ? 'مكتمل' : 'قيد التنفيذ',
      progressPercentage: rawProjectPercent > 1.0 ? rawProjectPercent / 100.0 : rawProjectPercent,
      areaText: "$areaVal م²",
      heightText: "$heightVal م",
      supervisorName: supervisorNameVal,
      workItems: parsedItems,
    );
  }
}