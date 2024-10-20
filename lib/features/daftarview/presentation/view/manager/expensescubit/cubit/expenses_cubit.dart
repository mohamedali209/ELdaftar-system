import 'package:aldafttar/features/daftarview/presentation/view/manager/expensescubit/cubit/expenses_state.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/expenses_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ExpensesCubit() : super(ExpensesInitial());

Future<void> fetchExpenses({
  required String year,
  required String month,
  required String day,
}) async {
  try {
    emit(ExpensesLoading());

    // Get the authenticated user's ID
    final FirebaseAuth auth = FirebaseAuth.instance;
    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      emit(ExpensesError("User is not authenticated."));
      return;
    }

    // Fetch the document that contains the expenses
    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('dailyTransactions')
        .doc(year)
        .collection(month)
        .doc(day)
        .get();

    if (doc.exists) {
      // Check if 'expenses' field exists and is a list
      if (doc.data() != null &&
          (doc.data() as Map<String, dynamic>).containsKey('expenses')) {
        List<dynamic> expensesData = doc.get('expenses') as List<dynamic>;

        // Convert it into a list of Expense objects
        List<Expense> expensesList = expensesData.asMap().entries.map((entry) {
          return Expense.fromMap(entry.value,);
        }).toList();

        emit(ExpensesLoaded(expensesList)); // Now passes List<Expense>
      } else {
        // Handle case where 'expenses' field is missing
        emit(ExpensesLoaded(const [])); // Return empty list if 'expenses' field doesn't exist
      }
    } else {
      emit(ExpensesLoaded(const [])); // Empty list if no document exists
    }
  } catch (e) {
    emit(ExpensesError(e.toString()));
  }
}


  Future<void> addExpense({
    required String year,
    required String month,
    required String day,
    required String description,
    required double amount,
  }) async {
    try {
      // Get the authenticated user's ID
      final FirebaseAuth auth = FirebaseAuth.instance;
      String? userId = auth.currentUser?.uid;

      if (userId == null) {
        emit(ExpensesError("User is not authenticated."));
        return;
      }

      // Reference to the document for the specific day
      DocumentReference docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyTransactions')
          .doc(year)
          .collection(month)
          .doc(day);

      // Add the new expense to Firestore using arrayUnion
      await docRef.set({
        'expenses': FieldValue.arrayUnion([
          {
            'description': description,
            'amount': amount,
          }
        ])
      }, SetOptions(merge: true)); // Merge with existing document

      // Reference to the total_cash document
      DocumentReference cashDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('weight')
          .doc('init');

      // Fetch the current total_cash value
      DocumentSnapshot cashSnapshot = await cashDocRef.get();

      if (cashSnapshot.exists) {
        String totalCashString = cashSnapshot.get('total_cash') as String;

        // Convert total_cash to int
        int totalCash = int.tryParse(totalCashString) ?? 0;

        // Subtract the amount from total_cash
        int updatedTotalCash = totalCash - amount.toInt();

        // Update total_cash as a string in Firestore
        await cashDocRef.update({
          'total_cash': updatedTotalCash.toString(),
        });
      } else {
        emit(ExpensesError("Cash document does not exist."));
      }

      // Optionally, re-fetch expenses to update UI after adding a new one
      fetchExpenses(year: year, month: month, day: day);
    } catch (e) {
      emit(ExpensesError("Failed to add expense: ${e.toString()}"));
    }
  }
  Future<void> deleteExpense({
    required String year,
    required String month,
    required String day,
    required String description,
    required double amount,
  }) async {
    try {
      // Get the authenticated user's ID
      final FirebaseAuth auth = FirebaseAuth.instance;
      String? userId = auth.currentUser?.uid;

      if (userId == null) {
        emit(ExpensesError("User is not authenticated."));
        return;
      }

      // Reference to the document for the specific day
      DocumentReference docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyTransactions')
          .doc(year)
          .collection(month)
          .doc(day);

      // Delete the expense from Firestore using arrayRemove
      await docRef.update({
        'expenses': FieldValue.arrayRemove([
          {
            'description': description,
            'amount': amount,
          }
        ])
      });

      // Optionally, re-fetch expenses to update the UI after deletion
      fetchExpenses(year: year, month: month, day: day);
      
      // Reference to the total_cash document
      DocumentReference cashDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('weight')
          .doc('init');

      // Fetch the current total_cash value
      DocumentSnapshot cashSnapshot = await cashDocRef.get();

      if (cashSnapshot.exists) {
        String totalCashString = cashSnapshot.get('total_cash') as String;

        // Convert total_cash to int
        int totalCash = int.tryParse(totalCashString) ?? 0;

        // Add the amount back to total_cash (since we are deleting the expense)
        int updatedTotalCash = totalCash + amount.toInt();

        // Update total_cash as a string in Firestore
        await cashDocRef.update({
          'total_cash': updatedTotalCash.toString(),
        });
      } else {
        emit(ExpensesError("Cash document does not exist."));
      }
    } catch (e) {
      emit(ExpensesError("Failed to delete expense: ${e.toString()}"));
    }
  }
}

