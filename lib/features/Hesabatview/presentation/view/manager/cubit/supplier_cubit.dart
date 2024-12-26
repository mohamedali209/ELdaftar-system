import 'dart:async';

import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_state.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupplierCubit extends Cubit<SupplierState> {
  final FirebaseFirestore _firestore;
  StreamSubscription?
      _supplierSubscription; // For managing the Firestore stream
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance

  SupplierCubit(this._firestore) : super(SupplierInitial()) {
    fetchSuppliers(); // Initialize the streaming of suppliers
  }

  // Stream the suppliers in real-time
  void fetchSuppliers() async {
    emit(SupplierLoadInProgress());

    try {
      // Cancel the previous subscription if it exists
      _supplierSubscription?.cancel();

      // Get the current user's userId
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Listen to the suppliers in the current user's collection
        _supplierSubscription = _firestore
            .collection('users')
            .doc(userId) // Access the user's document
            .collection('suppliers')
            .snapshots()
            .listen(
          (snapshot) {
            final suppliers = snapshot.docs.map((doc) {
              return Hesabmodel.fromMap(
                  doc.data(), doc.id); // Include document ID
            }).toList();

            // Calculate totals

            final totalWazna21 =
                suppliers.fold<double>(0, (currentSum, supplier) {
              final value = double.tryParse(supplier.wazna21) ?? 0;
              return currentSum + value;
            });

            final totalNakdyia =
                suppliers.fold<double>(0.0, (currentSum, supplier) {
              final value = double.tryParse(supplier.nakdyia) ?? 0.0;
              return currentSum + value;
            });

            // Calculate total weight and account count

            final accountCount = suppliers.length;

            // Update the totals document in Firestore (optional, can be customized)
            _firestore
                .collection('users')
                .doc(userId)
                .collection('totals')
                .doc('totals')
                .set({
              'totalWazna21': totalWazna21,
              'totalNakdyia': totalNakdyia,
            });

            emit(SupplierLoadSuccess(
              totalNakdyia,
              suppliers,
              totalWazna21,
              accountCount,
            ));
          },
          onError: (e) {
            emit(SupplierLoadFailure(
                'Error streaming suppliers: ${e.toString()}'));
          },
        );
      } else {
        emit(SupplierLoadFailure('User not logged in'));
      }
    } catch (e) {
      emit(SupplierLoadFailure('Error fetching suppliers: ${e.toString()}'));
    }
  }

  // Add a new supplier
  Future<void> addSupplier(Hesabmodel newSupplier) async {
    try {
      emit(SupplierLoadInProgress());

      // Get the current user's userId
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Add a new supplier in the user's suppliers collection
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('suppliers')
            .add(newSupplier.toMap());
      } else {
        emit(SupplierLoadFailure('User not logged in'));
      }
    } catch (e) {
      emit(SupplierLoadFailure('Error adding supplier: ${e.toString()}'));
    }
  }

  // Delete a supplier and their transactions
  Future<void> deleteSupplier(String supplierId) async {
    try {
      emit(SupplierLoadInProgress());

      // Get the current user's userId
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Fetch all transactions in the transactions subcollection
        final transactionSnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('suppliers')
            .doc(supplierId)
            .collection('transactions')
            .get();

        // Delete each transaction document
        for (var doc in transactionSnapshot.docs) {
          await doc.reference.delete();
        }

        // After deleting the transactions, delete the supplier document itself
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('suppliers')
            .doc(supplierId)
            .delete();
      } else {
        emit(SupplierLoadFailure('User not logged in'));
      }
    } catch (e) {
      emit(SupplierLoadFailure('Error deleting supplier: ${e.toString()}'));
    }
  }

  // Method for adding/subtracting a transaction
  Future<void> addTransaction(
      String supplierId, String ayar21, String nakdyia, bool isAdd) async {
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.year}-${now.month}-${now.day}";

    try {
      emit(SupplierLoadInProgress());

      // Get the current user
      User? user = _auth.currentUser;

      // Check if the user is not null
      if (user != null) {
        String userId = user.uid;

        // Fetch the current supplier data within the user's document
        final supplierDoc = await _firestore
            .collection('users')
            .doc(userId)
            .collection('suppliers')
            .doc(supplierId)
            .get();

        if (!supplierDoc.exists) {
          emit(SupplierLoadFailure('Supplier not found'));
          return;
        }

        final supplierData = supplierDoc.data()!;
        double currentWazna21 =
            double.tryParse(supplierData['wazna21'] ?? '0') ?? 0;
        double currentNakdyia =
            double.tryParse(supplierData['nakdyia'] ?? '0') ?? 0;

        // Convert input to double for calculations
        double newWazna21 = double.tryParse(ayar21) ?? 0;
        final newNakdyia = double.tryParse(nakdyia) ?? 0;

        if (!isAdd) {
          // Subtraction Logic: Handle nakdyia and ayar21 subtraction
          if (newNakdyia > currentNakdyia) {
            emit(SupplierLoadFailure('Not enough nakdyia to subtract'));
            return;
          } else {
            currentNakdyia -= newNakdyia; // Subtract nakdyia
          }

          if (newWazna21 > currentWazna21) {
            emit(SupplierLoadFailure('Not enough gold to subtract'));
            return;
          } else {
            currentWazna21 -= newWazna21; // Subtract ayar21
          }
        } else {
          // Addition Logic: Add new values to the current values
          currentWazna21 += newWazna21;
          currentNakdyia += newNakdyia;
        }

        // Update supplier data with new weights and nakdyia
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('suppliers')
            .doc(supplierId)
            .update({
          'wazna21': currentWazna21.toStringAsFixed(2),
          'nakdyia': currentNakdyia.toString(),
          'isAdd': isAdd,
        });

        // Fetch the current transaction list and add the new transaction
        final supplierTransactionDoc = await _firestore
            .collection('users')
            .doc(userId)
            .collection('suppliers')
            .doc(supplierId)
            .get();
        final transactionList =
            supplierTransactionDoc.data()?['transactions'] ?? [];

        // Add the new transaction to the list
        transactionList.add({
          'wazna21': newWazna21.toStringAsFixed(2),
          'nakdyia': newNakdyia.toString(),
          'isAdd': isAdd, // Addition or subtraction
          'date': formattedDate, // Transaction date
        });

        // Update the transactions array in the supplier document
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('suppliers')
            .doc(supplierId)
            .update({
          'transactions': transactionList,
        });

        fetchSuppliers(); // Refresh supplier list
      } else {
        emit(SupplierLoadFailure('User not authenticated'));
      }
    } catch (e) {
      emit(SupplierLoadFailure('Error updating transaction: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _supplierSubscription?.cancel();
    return super.close();
  }
}
