import 'dart:async';

import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/expenses_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'collectiondfater_state.dart';

class CollectiondfaterCubit extends Cubit<CollectiondfaterState> {
  final FirebaseFirestore _firestore;
  CollectiondfaterCubit(this._firestore) : super(CollectiondfaterInitial());
    StreamSubscription<DocumentSnapshot>? _transactionSubscription;

void selectDateAndFetchTransactions(String year, String month, String day) async {
  emit(CollectiondfaterLoading()); // Emit loading state
   fetchTransactionsForDate(year, month, day); // Fetch the data
}

  void fetchTransactionsForDate(String year, String month, String day) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(CollectiondfaterError('User is not logged in.'));
      return;
    }

    final userId = user.uid;

    try {
      emit(CollectiondfaterLoading());

      // Listen to changes in the Firestore document
      _transactionSubscription = _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyTransactions')
          .doc(year)
          .collection(month)
          .doc(day)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data() as Map<String, dynamic>;

          final sellingItems = (data['sellingItems'] as List?)
                  ?.map((item) => Daftarcheckmodel.fromFirestore(item))
                  .toList() ??
              [];

          final buyingItems = (data['buyingItems'] as List?)
                  ?.map((item) => Daftarcheckmodel.fromFirestore(item))
                  .toList() ??
              [];

          final expenses = (data['expenses'] as List?)
                  ?.map((expense) => Expense.fromMap(expense))
                  .toList() ??
              [];

          emit(CollectiondfaterLoaded(
            sellingItems: sellingItems,
            buyingItems: buyingItems,
            expenses: expenses,
          ));
        } else {
          emit(CollectiondfaterLoaded(
            sellingItems: [],
            buyingItems: [],
            expenses: [],
          ));
        }
      }, onError: (error) {
        emit(CollectiondfaterError('Error streaming data: $error'));
      });
    } catch (e) {
      emit(CollectiondfaterError('Error initializing stream: $e'));
    }
  }

  /// Cancels the Firestore stream
  void cancelTransactionStream() {
    _transactionSubscription?.cancel();
    _transactionSubscription = null;
  }

  @override
  Future<void> close() {
    cancelTransactionStream();
    return super.close();
  }
}
