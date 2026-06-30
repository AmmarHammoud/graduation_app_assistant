import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expenses_repository.dart';
import '../datasources/expenses_remote_data_source.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesRemoteDataSource remoteDataSource;

  ExpensesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ExpenseEntity>> addExpense({
    required String projectId,
    required int workItemId,
    required double amount,
    required String description,
  }) async {
    try {
      final model = await remoteDataSource.addExpense(
        projectId: projectId,
        workItemId: workItemId,
        amount: amount,
        description: description,
      );
      return Right(model);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getExpenses({
    required String projectId,
    required int workItemId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final models = await remoteDataSource.getExpenses(
        projectId: projectId,
        workItemId: workItemId,
        fromDate: fromDate,
        toDate: toDate,
      );
      return Right(models);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
