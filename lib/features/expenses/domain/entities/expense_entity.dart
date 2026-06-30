import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  final int id;
  final String projectName;
  final String workItemName;
  final String createdByName;
  final double amount;
  final String description;
  final String createdAt;

  const ExpenseEntity({
    required this.id,
    required this.projectName,
    required this.workItemName,
    required this.createdByName,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        projectName,
        workItemName,
        createdByName,
        amount,
        description,
        createdAt,
      ];
}
