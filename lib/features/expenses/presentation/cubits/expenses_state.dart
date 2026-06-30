import 'package:equatable/equatable.dart';
import '../../domain/entities/expense_entity.dart';

abstract class ExpensesState extends Equatable {
  const ExpensesState();

  @override
  List<Object?> get props => [];
}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<ExpenseEntity> expenses;

  const ExpensesLoaded({required this.expenses});

  @override
  List<Object?> get props => [expenses];
}

class ExpenseAdding extends ExpensesState {
  final List<ExpenseEntity> currentExpenses;

  const ExpenseAdding({required this.currentExpenses});

  @override
  List<Object?> get props => [currentExpenses];
}

class ExpenseAddSuccess extends ExpensesState {
  final ExpenseEntity newExpense;

  const ExpenseAddSuccess({required this.newExpense});

  @override
  List<Object?> get props => [newExpense];
}

class ExpensesError extends ExpensesState {
  final String message;

  const ExpensesError({required this.message});

  @override
  List<Object?> get props => [message];
}
