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
          fieldWeight: newWeight.toString(),
        });

        final total18kWeight =
            double.tryParse(data['total18kWeight'] ?? '0') ?? 0;
        final total21kWeight =
            double.tryParse(data['total21kWeight'] ?? '0') ?? 0;

        double updatedTotal18kWeight = total18kWeight;
        double updatedTotal21kWeight = total21kWeight;

        if (purity == '18k') {
          updatedTotal18kWeight = operation == 'add'
              ? total18kWeight + weight
              : total18kWeight - weight;
        } else if (purity == '21k') {
          updatedTotal21kWeight = operation == 'add'
              ? total21kWeight + weight
              : total21kWeight - weight;
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
}
