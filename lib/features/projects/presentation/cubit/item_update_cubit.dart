import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/work_items_update_details.dart';
import '../../domain/usecases/get_work_item_update_details.dart';
import 'item_update_state.dart';

class ItemUpdateCubit extends Cubit<ItemUpdateState> {
  final GetWorkItemUpdateDetails getWorkItemUpdateDetails;

  ItemUpdateCubit({
    required this.getWorkItemUpdateDetails,
  }) : super(ItemUpdateInitial());

  Future<void> loadItemDetails(String itemId) async {
    emit(ItemUpdateLoading());
    try {
      final details = await getWorkItemUpdateDetails(itemId);
      emit(ItemUpdateLoaded(data: details));
    } catch (_) {
      emit(const ItemUpdateError('فشل جلب تفاصيل تحديث البند'));
    }
  }

  void selectImages(List<String> paths) {
    if (state is! ItemUpdateLoaded) return;
    final curr = state as ItemUpdateLoaded;
    emit(
      curr.copyWith(chosenImages: List.from(curr.chosenImages)..addAll(paths)),
    );
  }

  Future<void> sendRequestToAdmin(String spaceName) async {
    if (state is! ItemUpdateLoaded) return;
    final curr = state as ItemUpdateLoaded;

    emit(curr.copyWith(isSubmitting: true));
    try {
      await getWorkItemUpdateDetails.repository.submitSubSpaceProgressUpdate(
        itemId: curr.data.itemId.toString(),
        spaceName: spaceName,
        localImagePaths: curr.chosenImages,
      );
      emit(ItemUpdateSuccess());
    } catch (_) {
      emit(curr.copyWith(isSubmitting: false));
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
