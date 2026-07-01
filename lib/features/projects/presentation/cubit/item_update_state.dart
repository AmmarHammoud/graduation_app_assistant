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

  const ItemUpdateLoaded({
    required this.data,
    this.chosenImagesBySpace = const {},
    this.submittingSpaceIds = const {},
  });

  ItemUpdateLoaded copyWith({
    WorkItemUpdateDetails? data,
    Map<int, List<String>>? chosenImagesBySpace,
    Set<int>? submittingSpaceIds,
  }) {
    return ItemUpdateLoaded(
      data: data ?? this.data,
      chosenImagesBySpace: chosenImagesBySpace ?? this.chosenImagesBySpace,
      submittingSpaceIds: submittingSpaceIds ?? this.submittingSpaceIds,
    );
  }

  @override
  List<Object?> get props => [data, chosenImagesBySpace, submittingSpaceIds];
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
    required super.chosenImagesBySpace,
    required super.submittingSpaceIds,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [data, chosenImagesBySpace, submittingSpaceIds, errorMessage];
}