import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/expense_entity.dart';

abstract class ExpensesRepository {
  Future<Either<Failure, ExpenseEntity>> addExpense({
    required String projectId,
    required int workItemId,
    required double amount,
    required String description,
  });
}
