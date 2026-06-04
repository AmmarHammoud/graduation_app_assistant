import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.location,
    required super.completionPercentage,
    required super.status,
    required super.imageUrl,
    super.statusLabel,
    super.executionDateText,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // 1. Map backend status strings to our UI Domain presentation state
    final backendStatus = json['status'] as String? ?? 'planned';
    ProjectStatus domainStatus;
    String statusLabelText;

    switch (backendStatus) {
      case 'completed':
        domainStatus = ProjectStatus.completed;
        statusLabelText = "منجز";
        break;
      case 'in_progress':
        domainStatus = ProjectStatus.inProgress;
        statusLabelText = "قيد التنفيذ";
        break;
      case 'planned':
      default:
        domainStatus = ProjectStatus.upcoming;
        statusLabelText = "لم يبدأ";
        break;
    }

    // 2. Parse values from the API (safely converting String numbers if needed)
    final double rawProgress = (json['progress_percent'] as num? ?? 0).toDouble();
    // Normalize percentage value from 0-100 to 0.0-1.0 range for the Flutter Progress Indicator
    final calculatedPercentage = rawProgress > 1 ? rawProgress / 100 : rawProgress;

    // 3. Extract execution timestamp fallback strings if present
    String? dateLabel;
    if (json['started_at'] != null) {
      dateLabel = "بدأ في ${json['started_at']}";
    } else if (json['completed_at'] != null) {
      dateLabel = "تم الإغلاق في ${json['completed_at']}";
    } else {
      dateLabel = "تاريخ البدء قريباً";
    }

    return ProjectModel(
      // Safely casting backend Int ID to a clean String standard for entity consistency
      id: (json['id'] ?? '').toString(),
      title: json['name'] as String? ?? 'مشروع بدون اسم',
      location: json['location'] as String? ?? 'الموقع غير محدد',
      completionPercentage: calculatedPercentage,
      status: domainStatus,
      statusLabel: statusLabelText,
      executionDateText: dateLabel,
      // Placeholder asset fallback until the backend team exposes real picture endpoint fields
      imageUrl: _getPlaceholderForId(json['id'] as int? ?? 1),
    );
  }

  static String _getPlaceholderForId(int id) {
    final list = [
      "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=600",
      "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=600",
      "https://images.unsplash.com/photo-1503387762-592deb58ef4e?q=80&w=600"
    ];
    return list[id % list.length];
  }
}