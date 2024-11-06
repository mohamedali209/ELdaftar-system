import 'package:aldafttar/features/Hesabatview/presentation/view/manager/transaction/cubit/transaction_state.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final FirebaseFirestore _firestore = ServiceLocator.getFirestoreInstance();
  final FirebaseAuth _auth = ServiceLocator.getAuthInstance();

  TransactionCubit() : super(TransactionInitial());

  Future<void> fetchTransactions(String hesabId) async {
    try {
      emit(TransactionLoadInProgress());

      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        final supplierDoc = await _firestore
            .collection('users')
            .doc(userId)
            .collection('suppliers')
            .doc(hesabId)
            .get();

        if (!supplierDoc.exists) {
          emit(TransactionLoadFailure('Supplier not found'));
          return;
        }

        final supplierData = supplierDoc.data()!;
        final List<dynamic> transactionsData =
            supplierData['transactions'] ?? [];

        final transactions = transactionsData.map((data) {
          return TransactionModel.fromMap(data);
        }).toList();

        emit(TransactionLoadSuccess(transactions));
      } else {
        emit(TransactionLoadFailure('User not authenticated'));
      }
    } catch (e) {
      emit(TransactionLoadFailure(
          'Error fetching transactions: ${e.toString()}'));
    }
  }
}

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  // Private constructor
  ServiceLocator._internal();

  // Factory constructor to return the singleton instance
  factory ServiceLocator() {
    return _instance;
  }

  // Service instances
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  // Getter for FirebaseAuth
  FirebaseAuth get auth {
    _auth ??= FirebaseAuth.instance;
    return _auth!;
  }

  // Getter for FirebaseFirestore
  FirebaseFirestore get firestore {
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!;
  }

  // Static method to access the instance more easily
  static FirebaseAuth getAuthInstance() => _instance.auth;
  static FirebaseFirestore getFirestoreInstance() => _instance.firestore;
}
