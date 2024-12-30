import 'package:aldafttar/features/Gardview/presentation/manager/cubit/updateinventory/cubit/updateinventory_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateInventoryCubit extends Cubit<UpdateInventoryState> {
  UpdateInventoryCubit() : super(UpdateInventoryInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<void> updateInventory({
  required String type,
  required double weight,
  required int quantity,
  required String purity,
  required String operation,
}) async {
  emit(UpdateInventoryLoading());

  try {
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      emit(UpdateInventoryFailure(error: 'User not authenticated'));
      return;
    }

    final userId = user.uid;
    final documentRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .doc('init'); // Update based on your Firestore structure

    String fieldQuantity;
    String fieldWeight;

    if (type == 'جنيهات') {
      fieldQuantity = 'gnihat_count';
      fieldWeight = 'gnihat_weight';
    } else if (type == 'سبائك') {
      fieldQuantity = 'sabaek_count';
      fieldWeight = 'sabaek_weight';
    } else if (type == 'كسر') { // Check if the item is كسر
      fieldQuantity = '${purity}_kasr_quantity'; // Assuming you have fields for kasr
      fieldWeight = '${purity}_kasr_weight';
    } else {
      fieldQuantity = '${type}_${purity}_quantity';
      fieldWeight = '${type}_${purity}_weight';
    }

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(documentRef);

      if (!snapshot.exists) {
        throw Exception("Document does not exist!");
      }

      final data = snapshot.data()!;
      final currentQuantity = int.tryParse(data[fieldQuantity] ?? '0') ?? 0;
      final currentWeight = double.tryParse(data[fieldWeight] ?? '0') ?? 0;

      final newQuantity = operation == 'add'
          ? currentQuantity + quantity
          : currentQuantity - quantity;
      final newWeight = operation == 'add'
          ? currentWeight + weight
          : currentWeight - weight;

      transaction.update(documentRef, {
        fieldQuantity: newQuantity.toString(),
        fieldWeight: newWeight.toStringAsFixed(2),
      });

      final total18kWeight =
          double.tryParse(data['total18kWeight'] ?? '0') ?? 0;
      final total21kWeight =
          double.tryParse(data['total21kWeight'] ?? '0') ?? 0;

      double updatedTotal18kWeight = total18kWeight;
      double updatedTotal21kWeight = total21kWeight;

      // Update totals based on purity and type
      if (purity == '18k') {
        if (type == 'كسر') {
          // Update for broken items
          final currentTotalKasr = double.tryParse(data['total18kKasr'] ?? '0') ?? 0;
          final newTotalKasr = operation == 'add'
              ? currentTotalKasr + weight
              : currentTotalKasr - weight;

          transaction.update(documentRef, {
            'total18kKasr': newTotalKasr.toStringAsFixed(2),
          });
        } else {
          updatedTotal18kWeight = operation == 'add'
              ? total18kWeight + weight
              : total18kWeight - weight;
        }
      } else if (purity == '21k') {
        if (type == 'كسر') {
          // Update for broken items
          final currentTotalKasr = double.tryParse(data['total21kKasr'] ?? '0') ?? 0;
          final newTotalKasr = operation == 'add'
              ? currentTotalKasr + weight
              : currentTotalKasr - weight;

          transaction.update(documentRef, {
            'total21kKasr': newTotalKasr.toStringAsFixed(2),
          });
        } else {
          updatedTotal21kWeight = operation == 'add'
              ? total21kWeight + weight
              : total21kWeight - weight;
        }
      }

      final totalInventoryWeight21 =
          (updatedTotal18kWeight * 6 / 7) + updatedTotal21kWeight;

      transaction.update(documentRef, {
        'total18kWeight': updatedTotal18kWeight.toString(),
        'total21kWeight': updatedTotal21kWeight.toString(),
        'totalInventoryWeight21': totalInventoryWeight21.toString(),
      });

      emit(UpdateInventorySuccess());
    });
  } catch (e) {
    emit(UpdateInventoryFailure(error: e.toString()));
  }
}

  Future<void> updateTotalCash({
  required String operation,  // Either 'إضافة' (add) or 'سحب' (subtract)
  required int amount,     // The cash amount to add or subtract
}) async {
  try {
    // Get the current authenticated user
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    // Get user ID
    String userId = user.uid;

    // Reference the document in the 'weight' collection (specific to the user)
    DocumentReference weightDoc = firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .doc('init');  // Reference to the 'init' document in 'weight'

    // Run a transaction to update the total cash field
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(weightDoc);

      if (!snapshot.exists) {
        throw Exception("Weight document does not exist!");
      }

      // Get the current total cash value
      int currentCash = int.tryParse(snapshot['total_cash'].toString()) ?? 0;

      // Calculate the updated cash value based on the operation (add or subtract)
      int updatedCash = operation == 'إضافة'
          ? currentCash + amount
          : currentCash - amount;

      // Update the total_cash field in the 'weight' document
      transaction.update(weightDoc, {'total_cash': updatedCash.toString()});
    });

    // Emit success state after the update
    emit(UpdateInventorySuccess());
  } catch (e) {
    // Emit failure state if an error occurs
    emit(UpdateInventoryFailure(error: e.toString()));
  }
}

}
