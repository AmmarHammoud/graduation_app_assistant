import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.projectName,
    required super.workItemName,
    required super.createdByName,
    required super.amount,
    required super.description,
    required super.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    // Dig into nested fields safely
    final projectMap = json['project'] as Map<String, dynamic>? ?? {};
    final workItemMap = json['work_item'] as Map<String, dynamic>? ?? {};
    final createdByMap = json['created_by'] as Map<String, dynamic>? ?? {};

    return ExpenseModel(
      id: json['id'] as int? ?? 0,
      projectName: projectMap['name'] as String? ?? '',
      workItemName: workItemMap['name'] as String? ?? '',
      createdByName: createdByMap['name'] as String? ?? '',
      amount: double.tryParse((json['amount'] ?? '0').toString()) ?? 0.0,
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project': {
        'name': projectName,
      },
      'work_item': {
        'name': workItemName,
      },
      'created_by': {
        'name': createdByName,
      },
      'amount': amount.toString(),
      'description': description,
      'created_at': createdAt,
    };
  }
}
