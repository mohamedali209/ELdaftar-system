import 'package:aldafttar/features/Hesabatview/presentation/view/models/transaction.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoadInProgress extends TransactionState {}

class TransactionLoadSuccess extends TransactionState {
  final List<TransactionModel> transactions;

  TransactionLoadSuccess(this.transactions);
}

class TransactionLoadFailure extends TransactionState {
  final String errorMessage;

  TransactionLoadFailure(this.errorMessage);
}
