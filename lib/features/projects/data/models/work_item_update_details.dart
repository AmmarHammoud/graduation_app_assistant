import '../../domain/entities/work_items_update_details.dart';

String _mapSpaceTypeToArabic(String type) {
  switch (type.toLowerCase()) {
    case 'corridor':
      return 'ممر (Corridor)';
    case 'toilet':
      return 'مرحاض (Toilet)';
    case 'kitchen':
      return 'مطبخ (Kitchen)';
    case 'salon':
      return 'صالون (Salon)';
    case 'bedroom':
      return 'غرفة نوم (Bedroom)';
    case 'living':
    case 'living_room':
      return 'غرفة معيشة (Living Room)';
    case 'bathroom':
      return 'دورة مياه (Bathroom)';
    default:
      return type;
  }
}

class WorkItemUpdateDetailsModel extends WorkItemUpdateDetails {
  const WorkItemUpdateDetailsModel({
    required super.itemId,
    required super.itemName,
    required super.currentPercent,
    super.delayWarningMessage,
    required super.subSpaces,
    required super.managerComments,
    super.hasPendingProgressRequest = false,
  });

  factory WorkItemUpdateDetailsModel.fromResponse({
    required Map<String, dynamic> json,
    required int itemId,
    required String itemName,
  }) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final List<dynamic> finishedList = data['finished'] as List<dynamic>? ?? [];
    final List<dynamic> unfinishedList = data['unfinished'] as List<dynamic>? ?? [];

    final pendingRequest = data['pending_request'] as Map<String, dynamic>?;
    bool hasPendingProgress = false;
    int? pendingSpaceId;

    if (pendingRequest != null) {
      final type = pendingRequest['type'] as String?;
      final status = pendingRequest['status'] as String?;
      if (status == 'pending') {
        if (type == 'progress') {
          hasPendingProgress = true;
        } else if (type == 'room') {
          final payload = pendingRequest['payload'] as Map<String, dynamic>?;
          if (payload != null) {
            pendingSpaceId = int.tryParse(payload['space_id']?.toString() ?? '');
          }
        }
      }
    }

    final List<SubSpaceItemEntity> spaces = [];

    // Map finished
    for (final s in finishedList) {
      spaces.add(SubSpaceItemEntity(
        id: s['id'] as int? ?? 0,
        spaceName: _mapSpaceTypeToArabic(s['type'] as String? ?? ''),
        statusLabel: 'مكتمل',
        uploadedMediaUrl: (s['photos'] as List<dynamic>?)?.isNotEmpty == true
            ? (s['photos'] as List<dynamic>).first['path']?.toString()
            : null,
        uploadDate: s['updated_at'] as String?,
      ));
    }

    // Map unfinished
    for (final s in unfinishedList) {
      final sId = s['id'] as int? ?? 0;
      final isPending = sId == pendingSpaceId;
      spaces.add(SubSpaceItemEntity(
        id: sId,
        spaceName: _mapSpaceTypeToArabic(s['type'] as String? ?? ''),
        statusLabel: isPending ? 'قيد المراجعة' : 'لم يتم الرفع',
        uploadedMediaUrl: null,
        uploadDate: null,
      ));
    }

    final totalCount = finishedList.length + unfinishedList.length;
    final double percent = totalCount > 0 ? finishedList.length / totalCount : 0.0;

    return WorkItemUpdateDetailsModel(
      itemId: itemId,
      itemName: itemName,
      currentPercent: percent,
      delayWarningMessage: null,
      subSpaces: spaces,
      managerComments: const [],
      hasPendingProgressRequest: hasPendingProgress,
    );
  }

  factory WorkItemUpdateDetailsModel.fromJson(Map<String, dynamic> json) {
    return WorkItemUpdateDetailsModel.fromResponse(
      json: json,
      itemId: json['item_id'] as int? ?? 0,
      itemName: json['item_name'] as String? ?? 'تحديث الأعمال',
    );
  }
}