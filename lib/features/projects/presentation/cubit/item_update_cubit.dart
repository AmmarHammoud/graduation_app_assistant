import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
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

      final Map<String, int> initialNumericValues = {};
      final name = itemName.toLowerCase();
      if (name.contains('ملابن')) {
        initialNumericValues['completed_wood_doors'] = 4;
        initialNumericValues['completed_aluminum_doors'] = 2;
        initialNumericValues['completed_windows'] = 6;
      } else if (name.contains('ألمنيوم') || name.contains('المنيوم')) {
        initialNumericValues['total_aluminum'] = 12;
        initialNumericValues['completed_aluminum'] = 5;
      } else if (name.contains('أبواب') || name.contains('ابواب') || name.contains('نجارة')) {
        initialNumericValues['total_doors'] = 5;
        initialNumericValues['completed_doors'] = 2;
        initialNumericValues['kitchen_cabinet_done'] = 0;
      }

      emit(ItemUpdateLoaded(
        data: details,
        numericValues: initialNumericValues,
      ));
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

    final spaceImages = curr.chosenImagesBySpace[space.id] ?? [];
    if (spaceImages.isEmpty) {
      emit(ItemUpdateSubmissionFailure(
        data: curr.data,
        chosenImagesBySpace: curr.chosenImagesBySpace,
        submittingSpaceIds: curr.submittingSpaceIds,
        errorMessage: 'يرجى اختيار صورة أولاً لتوثيق الإنجاز.',
      ));
      return;
    }

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
    } on DioException catch (e) {
      if (state is ItemUpdateLoaded) {
        final updatedCurr = state as ItemUpdateLoaded;
        final failure = ServerFailure.fromDioError(e);
        emit(ItemUpdateSubmissionFailure(
          data: updatedCurr.data,
          chosenImagesBySpace: updatedCurr.chosenImagesBySpace,
          submittingSpaceIds: Set<int>.from(updatedCurr.submittingSpaceIds)..remove(space.id),
          errorMessage: failure.errMessage,
        ));
      }
    } catch (e) {
      if (state is ItemUpdateLoaded) {
        final updatedCurr = state as ItemUpdateLoaded;
        emit(ItemUpdateSubmissionFailure(
          data: updatedCurr.data,
          chosenImagesBySpace: updatedCurr.chosenImagesBySpace,
          submittingSpaceIds: Set<int>.from(updatedCurr.submittingSpaceIds)..remove(space.id),
          errorMessage: e.toString(),
        ));
      }
    }
  }

  void updateNumericValue(String fieldKey, int value) {
    if (state is! ItemUpdateLoaded) return;
    final curr = state as ItemUpdateLoaded;
    final updatedValues = Map<String, int>.from(curr.numericValues);
    updatedValues[fieldKey] = value;
    emit(curr.copyWith(numericValues: updatedValues));
  }

  void selectNumericImages(String fieldKey, List<String> paths) {
    if (state is! ItemUpdateLoaded) return;
    final curr = state as ItemUpdateLoaded;
    final updatedMap = Map<String, List<String>>.from(curr.chosenImagesByField);
    final currentImages = updatedMap[fieldKey] ?? [];
    updatedMap[fieldKey] = List.from(currentImages)..addAll(paths);
    emit(curr.copyWith(chosenImagesByField: updatedMap));
  }

  void clearNumericImage(String fieldKey) {
    if (state is! ItemUpdateLoaded) return;
    final curr = state as ItemUpdateLoaded;
    final updatedMap = Map<String, List<String>>.from(curr.chosenImagesByField);
    updatedMap.remove(fieldKey);
    emit(curr.copyWith(chosenImagesByField: updatedMap));
  }

  Future<void> sendNumericRequestToAdmin() async {
    if (state is! ItemUpdateLoaded) return;
    final curr = state as ItemUpdateLoaded;

    if (curr.data.hasPendingProgressRequest) {
      emit(ItemUpdateSubmissionFailure(
        data: curr.data,
        chosenImagesBySpace: curr.chosenImagesBySpace,
        submittingSpaceIds: curr.submittingSpaceIds,
        numericValues: curr.numericValues,
        chosenImagesByField: curr.chosenImagesByField,
        isSubmittingNumeric: false,
        errorMessage: 'لا يمكنك إرسال تحديث جديد بينما الطلب السابق قيد المراجعة.',
      ));
      return;
    }

    final List<String> allSelectedImages = [];
    curr.chosenImagesByField.values.forEach(allSelectedImages.addAll);

    if (allSelectedImages.isEmpty) {
      emit(ItemUpdateSubmissionFailure(
        data: curr.data,
        chosenImagesBySpace: curr.chosenImagesBySpace,
        submittingSpaceIds: curr.submittingSpaceIds,
        numericValues: curr.numericValues,
        chosenImagesByField: curr.chosenImagesByField,
        isSubmittingNumeric: false,
        errorMessage: 'يرجى اختيار صورة واحدة على الأقل لتوثيق الإنجاز.',
      ));
      return;
    }

    emit(curr.copyWith(isSubmittingNumeric: true));

    final Map<String, String> payload = {};
    curr.numericValues.forEach((key, value) {
      payload[key] = value.toString();
    });

    try {
      final success = await getWorkItemUpdateDetails.repository.submitNumericProgressUpdate(
        projectId: projectId ?? '',
        itemId: curr.data.itemId.toString(),
        payload: payload,
        localImagePaths: allSelectedImages,
      );
      if (success) {
        emit(ItemUpdateSuccess());
      } else {
        if (state is ItemUpdateLoaded) {
          final updatedCurr = state as ItemUpdateLoaded;
          emit(updatedCurr.copyWith(isSubmittingNumeric: false));
        }
      }
    } on DioException catch (e) {
      if (state is ItemUpdateLoaded) {
        final updatedCurr = state as ItemUpdateLoaded;
        final failure = ServerFailure.fromDioError(e);
        emit(ItemUpdateSubmissionFailure(
          data: updatedCurr.data,
          chosenImagesBySpace: updatedCurr.chosenImagesBySpace,
          submittingSpaceIds: updatedCurr.submittingSpaceIds,
          numericValues: updatedCurr.numericValues,
          chosenImagesByField: updatedCurr.chosenImagesByField,
          isSubmittingNumeric: false,
          errorMessage: failure.errMessage,
        ));
      }
    } catch (e) {
      if (state is ItemUpdateLoaded) {
        final updatedCurr = state as ItemUpdateLoaded;
        emit(ItemUpdateSubmissionFailure(
          data: updatedCurr.data,
          chosenImagesBySpace: updatedCurr.chosenImagesBySpace,
          submittingSpaceIds: updatedCurr.submittingSpaceIds,
          numericValues: updatedCurr.numericValues,
          chosenImagesByField: updatedCurr.chosenImagesByField,
          isSubmittingNumeric: false,
          errorMessage: e.toString(),
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
