import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/work_items_update_details.dart';
import '../../domain/usecases/get_work_item_update_details.dart';
import 'item_update_state.dart';

class ItemUpdateCubit extends Cubit<ItemUpdateState> {
  final GetWorkItemUpdateDetails getWorkItemUpdateDetails;

  String? projectId;

  ItemUpdateCubit({
    required this.getWorkItemUpdateDetails,
  }) : super(ItemUpdateInitial());

  Future<void> loadItemDetails({
    required String itemId,
    required String projectId,
    required String itemName,
  }) async {
    this.projectId = projectId;
    emit(ItemUpdateLoading());
    try {
      final details = await getWorkItemUpdateDetails(
        projectId: projectId,
        itemId: itemId,
        itemName: itemName,
      );
      emit(ItemUpdateLoaded(data: details));
    } catch (_) {
      emit(const ItemUpdateError('فشل جلب تفاصيل تحديث البند'));
    }
  }

  void selectImages(int spaceId, List<String> paths) {
    if (state is! ItemUpdateLoaded) return;
    final curr = state as ItemUpdateLoaded;
    final updatedMap = Map<int, List<String>>.from(curr.chosenImagesBySpace);
    final currentImages = updatedMap[spaceId] ?? [];
    updatedMap[spaceId] = List.from(currentImages)..addAll(paths);
    emit(curr.copyWith(chosenImagesBySpace: updatedMap));
  }

  Future<void> sendRequestToAdmin(SubSpaceItemEntity space) async {
    if (state is! ItemUpdateLoaded) return;
    final curr = state as ItemUpdateLoaded;

    emit(curr.copyWith(
      submittingSpaceIds: Set<int>.from(curr.submittingSpaceIds)..add(space.id),
    ));
    try {
      final spaceImages = curr.chosenImagesBySpace[space.id] ?? [];
      final success = await getWorkItemUpdateDetails.repository.submitSubSpaceProgressUpdate(
        projectId: projectId ?? '',
        itemId: curr.data.itemId.toString(),
        spaceId: space.id,
        localImagePaths: spaceImages,
      );
      if (success) {
        emit(ItemUpdateSuccess());
      } else {
        if (state is ItemUpdateLoaded) {
          final updatedCurr = state as ItemUpdateLoaded;
          emit(updatedCurr.copyWith(
            submittingSpaceIds: Set<int>.from(updatedCurr.submittingSpaceIds)..remove(space.id),
          ));
        }
      }
    } catch (_) {
      if (state is ItemUpdateLoaded) {
        final updatedCurr = state as ItemUpdateLoaded;
        emit(updatedCurr.copyWith(
          submittingSpaceIds: Set<int>.from(updatedCurr.submittingSpaceIds)..remove(space.id),
        ));
      }
    }
  }

  void addComment(String text) {
    if (state is! ItemUpdateLoaded || text.trim().isEmpty) return;
    final curr = state as ItemUpdateLoaded;
    
    // Import entity definition locally if needed, or rely on existing imported files
    final updatedComments = List<UpdateCommentEntity>.from(curr.data.managerComments)
      ..add(UpdateCommentEntity(
        authorName: 'المقاول (أنت)',
        commentText: text.trim(),
        relativeTime: 'الآن',
      ));

    final updatedData = WorkItemUpdateDetails(
      itemId: curr.data.itemId,
      itemName: curr.data.itemName,
      currentPercent: curr.data.currentPercent,
      delayWarningMessage: curr.data.delayWarningMessage,
      subSpaces: curr.data.subSpaces,
      managerComments: updatedComments,
    );

    emit(curr.copyWith(data: updatedData));
  }
}
