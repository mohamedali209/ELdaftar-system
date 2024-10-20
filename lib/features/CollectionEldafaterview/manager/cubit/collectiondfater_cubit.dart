import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/expenses_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'collectiondfater_state.dart';

class CollectiondfaterCubit extends Cubit<CollectiondfaterState> {
  final FirebaseFirestore _firestore;
  CollectiondfaterCubit(this._firestore) : super(CollectiondfaterInitial());
void selectDateAndFetchTransactions(String year, String month, String day) async {
  emit(CollectiondfaterLoading()); // Emit loading state
   fetchTransactionsForDate(year, month, day); // Fetch the data
}

  void fetchTransactionsForDate(String year, String month, String day) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      // Fetch data from Firestore for the specific date
      final DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyTransactions')
          .doc(year)
          .collection(month)
          .doc(day)
          .get();

      List<Daftarcheckmodel> sellingItems = [];
      List<Daftarcheckmodel> buyingItems = [];
      List<Expense> expenses = []; // Initialize the expenses list

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;

        // Fetch selling items
        if (data['sellingItems'] != null) {
          sellingItems = (data['sellingItems'] as List)
              .map((item) => Daftarcheckmodel.fromFirestore(item))
              .toList();
        }

        // Fetch buying items
        if (data['buyingItems'] != null) {
          buyingItems = (data['buyingItems'] as List)
              .map((item) => Daftarcheckmodel.fromFirestore(item))
              .toList();
        }

        // Fetch expenses
        if (data['expenses'] != null) {
          expenses = (data['expenses'] as List)
              .map((expense) => Expense.fromMap(expense))
              .toList();
        }
      }

      emit(CollectiondfaterLoaded(
        sellingItems: sellingItems,
        buyingItems: buyingItems,
        expenses: expenses, // Pass expenses to the state
      ));
    } else {
      emit(CollectiondfaterError('User is not logged in.'));
    }
  } catch (e) {
    emit(CollectiondfaterError('Error fetching data: $e'));
  }
}

}
