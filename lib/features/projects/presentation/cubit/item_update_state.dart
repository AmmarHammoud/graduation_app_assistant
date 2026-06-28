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
  final List<String> chosenImages;
  final bool isSubmitting;

  const ItemUpdateLoaded({required this.data, this.chosenImages = const [], this.isSubmitting = false});

  ItemUpdateLoaded copyWith({WorkItemUpdateDetails? data, List<String>? chosenImages, bool? isSubmitting}) {
    return ItemUpdateLoaded(
      data: data ?? this.data,
      chosenImages: chosenImages ?? this.chosenImages,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [data, chosenImages, isSubmitting];
}
class ItemUpdateSuccess extends ItemUpdateState {}
class ItemUpdateError extends ItemUpdateState {
  final String message;
  const ItemUpdateError(this.message);
}