
import '../../domain/entities/work_items_update_details.dart';

class WorkItemUpdateDetailsModel extends WorkItemUpdateDetails {
  const WorkItemUpdateDetailsModel({
    required super.itemId,
    required super.itemName,
    required super.currentPercent,
    super.delayWarningMessage,
    required super.subSpaces,
    required super.managerComments,
  });

  factory WorkItemUpdateDetailsModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawSpaces = json['sub_spaces'] as List<dynamic>? ?? [];
    final List<dynamic> rawComments = json['comments'] as List<dynamic>? ?? [];

    return WorkItemUpdateDetailsModel(
      itemId: json['item_id'] as int? ?? 0,
      itemName: json['item_name'] as String? ?? '',
      currentPercent: ((json['percent'] as num? ?? 0).toDouble()) / 100,
      delayWarningMessage: json['delay_warning'] as String?,
      subSpaces: rawSpaces.map((s) {
        String localizedLabel = 'لم يتم الرفع';
        if (s['status'] == 'completed') localizedLabel = 'مكتمل';
        if (s['status'] == 'under_review') localizedLabel = 'قيد المراجعة';

        return SubSpaceItemEntity(
          spaceName: s['name'] as String? ?? '',
          statusLabel: localizedLabel,
          uploadedMediaUrl: s['media_url'] as String?,
          uploadDate: s['date'] as String?,
        );
      }).toList(),
      managerComments: rawComments.map((c) => UpdateCommentEntity(
        authorName: c['author'] as String? ?? '',
        commentText: c['text'] as String? ?? '',
        relativeTime: c['time'] as String? ?? '',
      )).toList(),
    );
  }
}