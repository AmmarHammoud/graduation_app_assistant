import '../../../../core/services/database_service.dart';
import '../models/expense_model.dart';

abstract class ExpensesRemoteDataSource {
  Future<ExpenseModel> addExpense({
    required String projectId,
    required int workItemId,
    required double amount,
    required String description,
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
}
