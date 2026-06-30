import '../../../../core/services/database_service.dart';
import '../models/expense_model.dart';

abstract class ExpensesRemoteDataSource {
  Future<ExpenseModel> addExpense({
    required String projectId,
    required int workItemId,
    required double amount,
    required String description,
  });

  Future<List<ExpenseModel>> getExpenses({
    required String projectId,
    required int workItemId,
    required String fromDate,
    required String toDate,
  });
}

class ExpensesRemoteDataSourceImpl implements ExpensesRemoteDataSource {
  final DatabaseService _databaseService;

  ExpensesRemoteDataSourceImpl(this._databaseService);

  @override
  Future<ExpenseModel> addExpense({
    required String projectId,
    required int workItemId,
    required double amount,
    required String description,
  }) async {
    final response = await _databaseService.addData(
      endpoint: 'projects/$projectId/work-items/$workItemId/expenses',
      data: {
        'amount': amount,
        'description': description,
      },
    );

    final Map<String, dynamic> data = response['data'] as Map<String, dynamic>? ?? {};
    return ExpenseModel.fromJson(data);
  }

  @override
  Future<List<ExpenseModel>> getExpenses({
    required String projectId,
    required int workItemId,
    required String fromDate,
    required String toDate,
  }) async {
    final response = await _databaseService.getData(
      endpoint: 'projects/$projectId/work-items/$workItemId/expenses',
      quary: {
        'from': fromDate,
        'to': toDate,
      },
    );

    final Map<String, dynamic> data = response['data'] as Map<String, dynamic>? ?? {};
    final projectMap = data['project'] as Map<String, dynamic>? ?? {};
    final workItemMap = data['work_item'] as Map<String, dynamic>? ?? {};
    final expensesList = data['expenses'] as List<dynamic>? ?? [];

    return expensesList.map((item) {
      final Map<String, dynamic> itemMap = Map<String, dynamic>.from(item as Map);
      itemMap['project'] = projectMap;
      itemMap['work_item'] = workItemMap;
      return ExpenseModel.fromJson(itemMap);
    }).toList();
  }
}
