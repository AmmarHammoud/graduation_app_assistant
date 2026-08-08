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
    List<dynamic>? details,
  }) async {
    this.projectId = projectId;
    emit(ItemUpdateLoading());
    try {
      final itemDetails = await getWorkItemUpdateDetails(
        projectId: projectId,
        itemId: itemId,
        itemName: itemName,
      );

      int woodDoors = 0;
      int aluminumDoors = 0;
      int windows = 0;
      int aluminum = 0;
      int doors = 0;
      int kitchenCabinet = 0;

      if (details != null && details.isNotEmpty) {
        for (final element in details) {
          if (element is Map<String, dynamic>) {
            if (element.containsKey('completed_wood_doors')) {
              woodDoors = int.tryParse(element['completed_wood_doors']?.toString() ?? '') ?? woodDoors;
            }
            if (element.containsKey('completed_aluminum_doors')) {
              aluminumDoors = int.tryParse(element['completed_aluminum_doors']?.toString() ?? '') ?? aluminumDoors;
            }
            if (element.containsKey('completed_windows')) {
              windows = int.tryParse(element['completed_windows']?.toString() ?? '') ?? windows;
            }
            if (element.containsKey('completed_aluminum')) {
              aluminum = int.tryParse(element['completed_aluminum']?.toString() ?? '') ?? aluminum;
            }
            if (element.containsKey('completed_doors')) {
              doors = int.tryParse(element['completed_doors']?.toString() ?? '') ?? doors;
            }
            if (element.containsKey('kitchen_cabinet_done')) {
              kitchenCabinet = int.tryParse(element['kitchen_cabinet_done']?.toString() ?? '') ?? kitchenCabinet;
            }
          }
        }
      }

      final Map<String, int> initialNumericValues = {};
      final name = itemName.toLowerCase();
      if (name.contains('ملابن')) {
        initialNumericValues['completed_wood_doors'] = woodDoors;
        initialNumericValues['completed_aluminum_doors'] = aluminumDoors;
        initialNumericValues['completed_windows'] = windows;
      } else if (name.contains('ألمنيوم') || name.contains('المنيوم')) {
        initialNumericValues['completed_aluminum'] = aluminum;
      } else if (name.contains('أبواب') || name.contains('ابواب') || name.contains('نجارة')) {
        initialNumericValues['completed_doors'] = doors;
        initialNumericValues['kitchen_cabinet_done'] = kitchenCabinet;
      }

      emit(ItemUpdateLoaded(
        data: itemDetails,
        numericValues: initialNumericValues,
        originalNumericValues: Map<String, int>.from(initialNumericValues),
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

  void removeNumericImageAtIndex(String fieldKey, int index) {
    if (state is! ItemUpdateLoaded) return;
    final curr = state as ItemUpdateLoaded;
    final updatedMap = Map<String, List<String>>.from(curr.chosenImagesByField);
    if (updatedMap.containsKey(fieldKey)) {
      final images = List<String>.from(updatedMap[fieldKey] ?? []);
      if (index >= 0 && index < images.length) {
        images.removeAt(index);
        if (images.isEmpty) {
          updatedMap.remove(fieldKey);
        } else {
          updatedMap[fieldKey] = images;
        }
        emit(curr.copyWith(chosenImagesByField: updatedMap));
      }
    }
  }

  String _getFieldArabicTitle(String key) {
    switch (key) {
      case 'completed_wood_doors':
        return 'أبواب خشب';
      case 'completed_aluminum_doors':
        return 'أبواب ألمنيوم';
      case 'completed_windows':
        return 'شبابيك';
      case 'completed_aluminum':
        return 'ألمنيوم وأبجورات';
      case 'completed_doors':
        return 'أبواب خشب';
      case 'kitchen_cabinet_done':
        return 'أغطية أبجور';
      default:
        return key;
    }
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
        originalNumericValues: curr.originalNumericValues,
        chosenImagesByField: curr.chosenImagesByField,
        isSubmittingNumeric: false,
        errorMessage: 'لا يمكنك إرسال تحديث جديد بينما الطلب السابق قيد المراجعة.',
      ));
      return;
    }

    bool hasAnyChange = false;
    String? validationErrorMessage;
    final List<String> allSelectedImages = [];

    // Enforce that uploaded photos match the exact increment for each modified field
    for (final entry in curr.numericValues.entries) {
      final key = entry.key;
      final currentValue = entry.value;
      final initialValue = curr.originalNumericValues[key] ?? 0;
      final increment = currentValue - initialValue;

      if (increment > 0) {
        hasAnyChange = true;
        final images = curr.chosenImagesByField[key] ?? [];
        if (images.length != increment) {
          validationErrorMessage = 'يرجى إرفاق عدد صور ($increment) يطابق عدد البنود المنجزة الجديدة لـ "${_getFieldArabicTitle(key)}". (تم إرفاق ${images.length} حالياً)';
          break;
        }
        allSelectedImages.addAll(images);
      }
    }

    if (!hasAnyChange) {
      emit(ItemUpdateSubmissionFailure(
        data: curr.data,
        chosenImagesBySpace: curr.chosenImagesBySpace,
        submittingSpaceIds: curr.submittingSpaceIds,
        numericValues: curr.numericValues,
        originalNumericValues: curr.originalNumericValues,
        chosenImagesByField: curr.chosenImagesByField,
        isSubmittingNumeric: false,
        errorMessage: 'لم تقم بتعديل أي كمية ليتم حفظها. يرجى تعديل البنود التي تود تحديثها الآن وتأجيل البقية.',
      ));
      return;
    }

    if (validationErrorMessage != null) {
      emit(ItemUpdateSubmissionFailure(
        data: curr.data,
        chosenImagesBySpace: curr.chosenImagesBySpace,
        submittingSpaceIds: curr.submittingSpaceIds,
        numericValues: curr.numericValues,
        originalNumericValues: curr.originalNumericValues,
        chosenImagesByField: curr.chosenImagesByField,
        isSubmittingNumeric: false,
        errorMessage: validationErrorMessage,
      ));
      return;
    }

    emit(curr.copyWith(isSubmittingNumeric: true));

    final Map<String, String> payload = {};
    curr.numericValues.forEach((key, value) {
      final initialValue = curr.originalNumericValues[key] ?? 0;
      final increment = value - initialValue;
      payload[key] = increment.toString();
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
          originalNumericValues: updatedCurr.originalNumericValues,
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
          originalNumericValues: updatedCurr.originalNumericValues,
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
