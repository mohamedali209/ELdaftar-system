import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/transaction.dart';

abstract class SupplierState {}

class SupplierInitial extends SupplierState {}

class SupplierLoadInProgress extends SupplierState {}

class SupplierLoadSuccess extends SupplierState {
  final List<Hesabmodel> suppliers;
  final double totalWazna18;
  final double totalWazna21;
  final double totalWazna24;
  final double totalWeight;
  final double total21;
  final int nakdyia;
  final int accountCount;

  SupplierLoadSuccess(
    this.total21,
    this.nakdyia, this.suppliers, this.totalWazna18,
      this.totalWazna24,
      this.totalWazna21, this.totalWeight, this.accountCount);
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
