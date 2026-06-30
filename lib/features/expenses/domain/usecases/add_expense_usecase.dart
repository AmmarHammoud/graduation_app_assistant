import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/expense_entity.dart';
import '../repositories/expenses_repository.dart';

class AddExpenseUseCase {
  final ExpensesRepository repository;

  AddExpenseUseCase(this.repository);

  Future<Either<Failure, ExpenseEntity>> call({
    required String projectId,
    required int workItemId,
    required double amount,
    required String description,
  }) {
    return repository.addExpense(
      projectId: projectId,
      workItemId: workItemId,
      amount: amount,
      description: description,
    );
  }
}
