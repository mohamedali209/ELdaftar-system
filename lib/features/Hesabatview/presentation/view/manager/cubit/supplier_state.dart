import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/transaction.dart';

abstract class SupplierState {}

class SupplierInitial extends SupplierState {}

class SupplierLoadInProgress extends SupplierState {}

class SupplierLoadSuccess extends SupplierState {
  final List<Hesabmodel> suppliers;
  final double totalWazna21;
  final int nakdyia;
  final int accountCount;

  SupplierLoadSuccess(
    this.nakdyia, this.suppliers,
      this.totalWazna21,  this.accountCount);
}

class SupplierLoadFailure extends SupplierState {
  final String error;

  SupplierLoadFailure(this.error);
}

// Define the SupplierTransactionsLoadSuccess state
class SupplierTransactionsLoadSuccess extends SupplierState {
  final List<TransactionModel> transactions;

  SupplierTransactionsLoadSuccess(this.transactions);
}
