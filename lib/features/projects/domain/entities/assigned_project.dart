import 'package:equatable/equatable.dart';

class AssignedProject extends Equatable {
  final String id;
  final String title;
  final String location;
  final String statusText;
  final double progressPercentage;
  final int activeWorkItemsCount;

  const AssignedProject({
    required this.id,
    required this.title,
    required this.location,
    required this.statusText,
    required this.progressPercentage,
    required this.activeWorkItemsCount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    location,
    statusText,
    progressPercentage,
    activeWorkItemsCount,
  ];
}