import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_state.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/gold_converter.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupplierCubit extends Cubit<SupplierState> {
  final FirebaseFirestore _firestore;

  SupplierCubit(this._firestore) : super(SupplierInitial()) {
    fetchSuppliers();
  }

  Future<void> fetchSuppliers() async {
    emit(SupplierLoadInProgress());

    try {
      final snapshot = await _firestore.collection('suppliers').get();

      final suppliers = snapshot.docs.map((doc) {
        return Hesabmodel.fromMap(doc.data(), doc.id); // Include document ID
      }).toList();

      // Calculate totals
      final totalWazna18 = suppliers.fold<double>(0, (sum, supplier) {
        final value = double.tryParse(supplier.wazna18) ?? 0;
        return sum + value;
      });

      final totalWazna21 = suppliers.fold<double>(0, (sum, supplier) {
        final value = double.tryParse(supplier.wazna21) ?? 0;
        return sum + value;
      });

    final totalWazna24 = suppliers.fold<double>(0, (sum, supplier) {
        final value = double.tryParse(supplier.wazna24) ?? 0;
        return sum + value;
      });

      final totalNakdyia = suppliers.fold<int>(0, (sum, supplier) {
        final value = int.tryParse(supplier.nakdyia) ?? 0;
        return sum + value;
      });

      // Calculate total weight and account count
      final totalWeight = (totalWazna18*6/7)+(totalWazna24 *24/21)+totalWazna21 ;
      final accountCount = suppliers.length;
          final total21 = (totalWazna18 * 6 / 7) + (totalWazna24 * 24 / 21) + totalWazna21;
          (totalWazna18 * 6 / 7) + (totalWazna24 * 24 / 21) + totalWazna21;


      // Update the totals document
      await _firestore.collection('totals').doc('totals').set({
        'totalWazna18': totalWazna18,
        'totalWazna21': totalWazna21,
        'totalWazna24': totalWazna24,
        'totalWeight': totalWeight,
        'total21': total21,
        'totalNakdyia': totalNakdyia,
      });

      emit(SupplierLoadSuccess(total21,totalNakdyia, suppliers, totalWazna18,totalWazna24,
          totalWazna21, totalWeight, accountCount,
          ));
    } catch (e) {
      emit(SupplierLoadFailure('Error fetching suppliers: ${e.toString()}'));
    }
  }

  Future<void> addSupplier(Hesabmodel newSupplier) async {
    try {
      emit(SupplierLoadInProgress());
      await _firestore.collection('suppliers').add(newSupplier.toMap());
      await fetchSuppliers(); // Refresh the list after adding a new supplier
    } catch (e) {
      emit(SupplierLoadFailure('Error adding supplier: ${e.toString()}'));
    }
  }

 Future<void> deleteSupplier(String supplierId) async {
  try {
    emit(SupplierLoadInProgress());

    // Fetch all transactions in the transactions subcollection
    final transactionSnapshot = await _firestore
        .collection('suppliers')
        .doc(supplierId)
        .collection('transactions')
        .get();

    // Delete each transaction document
    for (var doc in transactionSnapshot.docs) {
      await doc.reference.delete();
    }

    // After deleting the transactions, delete the supplier document itself
    await _firestore.collection('suppliers').doc(supplierId).delete();

    await fetchSuppliers(); // Refresh the list after deletion
  } catch (e) {
    emit(SupplierLoadFailure('Error deleting supplier: ${e.toString()}'));
  }
}


  // Method for adding/subtracting a transaction
Future<void> addTransaction(
  String supplierId, 
  String ayar18, 
  String ayar21,
  String ayar24, 
  String nakdyia, 
  bool isAdd
) async {
  final DateTime now = DateTime.now();
  final String formattedDate = "${now.year}-${now.month}-${now.day}";

  final GoldConverter goldConverter = GoldConverter();

  try {
    emit(SupplierLoadInProgress());

    // Fetch the current supplier data
    final supplierDoc = await _firestore.collection('suppliers').doc(supplierId).get();
    if (!supplierDoc.exists) {
      emit(SupplierLoadFailure('Supplier not found'));
      return;
    }

    final supplierData = supplierDoc.data()!;
    double currentWazna18 = double.tryParse(supplierData['wazna18'] ?? '0') ?? 0;
    double currentWazna21 = double.tryParse(supplierData['wazna21'] ?? '0') ?? 0;
    double currentWazna24 = double.tryParse(supplierData['wazna24'] ?? '0') ?? 0;
    final currentNakdyia = int.tryParse(supplierData['nakdyia'] ?? '0') ?? 0;

    // Convert input to double for calculations
    double newWazna18 = double.tryParse(ayar18) ?? 0;
    double newWazna21 = double.tryParse(ayar21) ?? 0;
    double newWazna24 = double.tryParse(ayar24) ?? 0;
    final newNakdyia = int.tryParse(nakdyia) ?? 0;

    if (!isAdd) {
      // Subtraction Logic: Handle gold subtraction
      if (newWazna18 > currentWazna18) {
        double remainingWazna18 = newWazna18 - currentWazna18;
        currentWazna18 = 0;

        double wazna21Equivalent = goldConverter.convert18kTo21k(remainingWazna18);
        if (wazna21Equivalent > currentWazna21) {
          double remainingWazna21 = wazna21Equivalent - currentWazna21;
          currentWazna21 = 0;

          double wazna24Equivalent = goldConverter.convert21kTo24k(remainingWazna21);
          if (wazna24Equivalent > currentWazna24) {
            emit(SupplierLoadFailure('Not enough gold across all karats to subtract'));
            return;
          } else {
            currentWazna24 -= wazna24Equivalent;
          }
        } else {
          currentWazna21 -= wazna21Equivalent;
        }
      } else {
        currentWazna18 -= newWazna18;
      }

      // Subtract from wazna21
      if (newWazna21 > currentWazna21) {
        double remainingWazna21 = newWazna21 - currentWazna21;
        currentWazna21 = 0;

        double wazna24Equivalent = goldConverter.convert21kTo24k(remainingWazna21);
        if (wazna24Equivalent > currentWazna24) {
          double wazna18Equivalent = goldConverter.convert24kTo18k(wazna24Equivalent);
          if (wazna18Equivalent > currentWazna18) {
            emit(SupplierLoadFailure('Not enough gold across all karats to subtract'));
            return;
          } else {
            currentWazna18 -= wazna18Equivalent;
          }
        } else {
          currentWazna24 -= wazna24Equivalent;
        }
      } else {
        currentWazna21 -= newWazna21;
      }

      // Subtract from wazna24
      if (newWazna24 > currentWazna24) {
        double remainingWazna24 = newWazna24 - currentWazna24;
        currentWazna24 = 0;

        double wazna21Equivalent = goldConverter.convert24kTo21k(remainingWazna24);
        if (wazna21Equivalent > currentWazna21) {
          double wazna18Equivalent = goldConverter.convert21kTo18k(wazna21Equivalent);
          if (wazna18Equivalent > currentWazna18) {
            emit(SupplierLoadFailure('Not enough gold across all karats to subtract'));
            return;
          } else {
            currentWazna18 -= wazna18Equivalent;
          }
        } else {
          currentWazna21 -= wazna21Equivalent;
        }
      } else {
        currentWazna24 -= newWazna24;
      }
    } else {
      // Addition Logic: Add new values to the current values
      currentWazna18 += newWazna18;
      currentWazna21 += newWazna21;
      currentWazna24 += newWazna24;
    }

    // Update supplier data with new weights and nakdyia
    await _firestore.collection('suppliers').doc(supplierId).update({
      'wazna18': currentWazna18.toString(),
      'wazna21': currentWazna21.toString(),
      'wazna24': currentWazna24.toString(),
      'nakdyia': (currentNakdyia + newNakdyia).toString(),
    });

    // Add transaction to subcollection
    await _firestore.collection('suppliers').doc(supplierId).collection('transactions').add({
      'wazna18': newWazna18.toString(),
      'wazna21': newWazna21.toString(),
      'wazna24': newWazna24.toString(),
      'nakdyia': newNakdyia.toString(),
      'isAdd': isAdd, // Addition or subtraction
      'date': formattedDate, // Transaction date
    });

    await fetchSuppliers(); // Refresh supplier list
  } catch (e) {
    emit(SupplierLoadFailure('Error updating transaction: ${e.toString()}'));
  }
}



  Future<void> fetchTransactions(String supplierId) async {
    try {
      emit(SupplierLoadInProgress());

      // Fetch transactions from Firestore
      final querySnapshot = await _firestore
          .collection('suppliers')
          .doc(supplierId)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      // Map transactions into a list of models
      final transactions = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return TransactionModel(
          wazna18: data['wazna18'] ?? '0',
          wazna21: data['wazna21'] ?? '0',
          wazna24: data['wazna24'] ?? '0',
          nakdyia: data['nakdyia'] ?? '0',
          date: data['date'] ?? '',
          isAddition: data['isAddition'] ?? true, // Include isAddition
        );
      }).toList();

      // Emit the success state with transactions
      emit(SupplierTransactionsLoadSuccess(transactions));
    } catch (e) {
      emit(SupplierLoadFailure('Error fetching transactions: ${e.toString()}'));
    }
  }
  
}
