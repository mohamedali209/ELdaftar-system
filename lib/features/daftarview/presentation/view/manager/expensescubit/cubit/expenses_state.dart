import 'package:aldafttar/features/daftarview/presentation/view/models/expenses_model.dart';
import 'package:equatable/equatable.dart';

abstract class ExpensesState extends Equatable {
  @override
  List<Object> get props => [];
}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<Expense> expenses; // Change to List<Expense>

  ExpensesLoaded(this.expenses);

  @override
  List<Object> get props => [expenses];
}


class ExpensesError extends ExpensesState {
  final String message;

  ExpensesError(this.message);

  @override
  List<Object> get props => [message];
}