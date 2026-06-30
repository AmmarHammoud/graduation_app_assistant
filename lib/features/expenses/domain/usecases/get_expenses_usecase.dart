import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/expense_entity.dart';
import '../repositories/expenses_repository.dart';

class GetExpensesUseCase {
  final ExpensesRepository repository;

  GetExpensesUseCase(this.repository);

  Future<Either<Failure, List<ExpenseEntity>>> call({
    required String projectId,
    required int workItemId,
    required String fromDate,
    required String toDate,
  }) {
    return repository.getExpenses(
      projectId: projectId,
      workItemId: workItemId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
