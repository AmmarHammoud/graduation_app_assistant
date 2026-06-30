import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../projects/domain/entities/assigned_proejct_details.dart';
import '../../domain/usecases/add_expense_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/entities/expense_entity.dart';
import 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  final AddExpenseUseCase addExpenseUseCase;
  final GetExpensesUseCase getExpensesUseCase;

  ExpensesCubit({
    required this.addExpenseUseCase,
    required this.getExpensesUseCase,
  }) : super(ExpensesInitial());

  void loadEmptyExpenses() {
    emit(const ExpensesLoaded(expenses: []));
  }

  // Set up initial mock list matching the UI image
  void loadInitialExpenses() {
    final mockExpenses = [
      const ExpenseEntity(
        id: 101,
        projectName: 'Heaney LLC Project',
        workItemName: 'أدوات حدادة',
        createdByName: 'سارة المساعدة',
        amount: 150.00,
        description: 'شراء مبارد ومطارق حدادة ومستلزمات تثبيت إضافية للورشة',
        createdAt: '2026-06-30T16:08:52.000000Z', // 2 hours ago equivalent
      ),
      const ExpenseEntity(
        id: 102,
        projectName: 'Heaney LLC Project',
        workItemName: 'فاتورة الكهرباء',
        createdByName: 'سارة المساعدة',
        amount: 420.00,
        description: 'فاتورة استهلاك الكهرباء لشهر يونيو للورشة الرئيسية',
        createdAt: '2026-06-29T18:08:52.000000Z', // Yesterday equivalent
      ),
    ];
    emit(ExpensesLoaded(expenses: mockExpenses));
  }

  Future<void> addExpense({
    required String projectId,
    required int workItemId,
    required double amount,
    required String description,
  }) async {
    final currentState = state;
    List<ExpenseEntity> previousExpenses = [];
    if (currentState is ExpensesLoaded) {
      previousExpenses = currentState.expenses;
    } else if (currentState is ExpenseAdding) {
      previousExpenses = currentState.currentExpenses;
    }

    emit(ExpenseAdding(currentExpenses: previousExpenses));

    final result = await addExpenseUseCase(
      projectId: projectId,
      workItemId: workItemId,
      amount: amount,
      description: description,
    );

    result.fold(
      (failure) {
        emit(ExpensesError(message: failure.errMessage));
        emit(ExpensesLoaded(expenses: previousExpenses));
      },
      (newExpense) {
        final List<ExpenseEntity> updatedList = List.from(previousExpenses)..insert(0, newExpense);
        emit(ExpenseAddSuccess(newExpense: newExpense));
        emit(ExpensesLoaded(expenses: updatedList));
      },
    );
  }

  Future<void> loadExpenses({
    required String projectId,
    required int workItemId,
    required String fromDate,
    required String toDate,
  }) async {
    emit(ExpensesLoading());

    final result = await getExpensesUseCase(
      projectId: projectId,
      workItemId: workItemId,
      fromDate: fromDate,
      toDate: toDate,
    );

    result.fold(
      (failure) => emit(ExpensesError(message: failure.errMessage)),
      (expenses) => emit(ExpensesLoaded(expenses: expenses)),
    );
  }

  Future<void> loadAllExpenses({
    required String projectId,
    required List<AssistantWorkItemEntity> workItems,
    required String fromDate,
    required String toDate,
  }) async {
    emit(ExpensesLoading());

    final List<ExpenseEntity> allExpenses = [];
    String? errMessage;

    final futures = workItems.map((item) async {
      final result = await getExpensesUseCase(
        projectId: projectId,
        workItemId: item.id,
        fromDate: fromDate,
        toDate: toDate,
      );
      result.fold(
        (failure) {
          errMessage = failure.errMessage;
        },
        (expenses) {
          allExpenses.addAll(expenses);
        },
      );
    });

    await Future.wait(futures);

    if (errMessage != null && allExpenses.isEmpty) {
      emit(ExpensesError(message: errMessage!));
    } else {
      allExpenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(ExpensesLoaded(expenses: allExpenses));
    }
  }
}
