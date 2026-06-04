import '../../domain/entities/assigned_project.dart';

class AssignedProjectModel extends AssignedProject {
  const AssignedProjectModel({
    required super.id,
    required super.title,
    required super.location,
    required super.statusText,
    required super.progressPercentage,
    required super.activeWorkItemsCount,
  });

  factory AssignedProjectModel.fromJson(Map<String, dynamic> json) {
    return AssignedProjectModel(
      id: (json['id'] ?? '').toString(),
      title: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      statusText: _translateStatus(json['status'] as String? ?? ''),
      progressPercentage: ((json['progress_percent'] as num? ?? 0).toDouble()) / 100,
      activeWorkItemsCount: json['active_items_count'] as int? ?? 0,
    );
  }

  static String _translateStatus(String status) {
    switch (status) {
      case 'in_progress': return 'قيد التنفيذ';
      case 'completed': return 'منجز';
      default: return 'لم يبدأ';
    }
  }
}