import 'package:equatable/equatable.dart';

import '../../domain/entities/work_items_update_details.dart';

abstract class ItemUpdateState extends Equatable {
  const ItemUpdateState();
  @override
  List<Object?> get props => [];
}

class ItemUpdateInitial extends ItemUpdateState {}
class ItemUpdateLoading extends ItemUpdateState {}
class ItemUpdateLoaded extends ItemUpdateState {
  final WorkItemUpdateDetails data;
  final Map<int, List<String>> chosenImagesBySpace;
  final Set<int> submittingSpaceIds;
  final Map<String, int> numericValues;
  final Map<String, List<String>> chosenImagesByField;
  final bool isSubmittingNumeric;

  const ItemUpdateLoaded({
    required this.data,
    this.chosenImagesBySpace = const {},
    this.submittingSpaceIds = const {},
    this.numericValues = const {},
    this.chosenImagesByField = const {},
    this.isSubmittingNumeric = false,
  });

  ItemUpdateLoaded copyWith({
    WorkItemUpdateDetails? data,
    Map<int, List<String>>? chosenImagesBySpace,
    Set<int>? submittingSpaceIds,
    Map<String, int>? numericValues,
    Map<String, List<String>>? chosenImagesByField,
    bool? isSubmittingNumeric,
  }) {
    return ItemUpdateLoaded(
      data: data ?? this.data,
      chosenImagesBySpace: chosenImagesBySpace ?? this.chosenImagesBySpace,
      submittingSpaceIds: submittingSpaceIds ?? this.submittingSpaceIds,
      numericValues: numericValues ?? this.numericValues,
      chosenImagesByField: chosenImagesByField ?? this.chosenImagesByField,
      isSubmittingNumeric: isSubmittingNumeric ?? this.isSubmittingNumeric,
    );
  }

  @override
  List<Object?> get props => [
        data,
        chosenImagesBySpace,
        submittingSpaceIds,
        numericValues,
        chosenImagesByField,
        isSubmittingNumeric,
      ];
}
class ItemUpdateSuccess extends ItemUpdateState {}
class ItemUpdateError extends ItemUpdateState {
  final String message;
  const ItemUpdateError(this.message);
}

class ItemUpdateSubmissionFailure extends ItemUpdateLoaded {
  final String errorMessage;

  const ItemUpdateSubmissionFailure({
    required super.data,
    super.chosenImagesBySpace = const {},
    super.submittingSpaceIds = const {},
    super.numericValues = const {},
    super.chosenImagesByField = const {},
    super.isSubmittingNumeric = false,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [
        data,
        chosenImagesBySpace,
        submittingSpaceIds,
        numericValues,
        chosenImagesByField,
        isSubmittingNumeric,
        errorMessage,
      ];
}