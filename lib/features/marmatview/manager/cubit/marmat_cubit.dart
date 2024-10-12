import 'dart:async';

import 'package:aldafttar/features/marmatview/manager/cubit/marmat_state.dart';
import 'package:aldafttar/features/marmatview/model/marmat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarmatCubit extends Cubit<MarmatState> {
  final FirebaseFirestore firestore;
  StreamSubscription? _marmatSubscription; // Stream subscription variable
  MarmatCubit({required this.firestore}) : super(MarmatInitial());

  // Stream to fetch and listen to real-time changes
   void streamMarmatItems() {
    emit(MarmatLoading());

    try {
      _marmatSubscription = firestore.collection('marmat').snapshots().listen(
        (querySnapshot) {
          final items = querySnapshot.docs.map((doc) {
            return MarmatModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          if (!isClosed) {
            emit(MarmatLoaded(items: items)); // Emit state only if not closed
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(MarmatError(message: error.toString()));
          }
          print('Error fetching Marmat items: $error');
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(MarmatError(message: e.toString()));
      }
    }
  }

  // Method to add a new Marmat item
  Future<void> addMarmatItem(MarmatModel marmatModel) async {
    try {
      // Automatically generate a new document ID
      final docRef = firestore.collection('marmat').doc();
      await docRef.set(marmatModel.toMap());
    } catch (e) {
      emit(MarmatError(message: 'Error adding Marmat item: $e'));
      if (kDebugMode) {
        print('Error adding Marmat item: $e');
      }
    }
  }

  // Method to update an existing Marmat item
  Future<void> updateMarmatItem(MarmatModel marmatModel) async {
    try {
      await firestore
          .collection('marmat')
          .doc(marmatModel.id)
          .update(marmatModel.toMap());
    } catch (e) {
      emit(MarmatError(message: 'Error updating Marmat item: $e'));
      if (kDebugMode) {
        print('Error updating Marmat item: $e');
      }
    }
  }

  // Method to delete a Marmat item
  Future<void> deleteMarmatItem(String documentId) async {
    try {
      await firestore.collection('marmat').doc(documentId).delete();
    } catch (e) {
      emit(MarmatError(message: 'Error deleting Marmat item: $e'));
      if (kDebugMode) {
        print('Error deleting Marmat item: $e');
      }
    }
  }

  // Method to toggle the repair status of a Marmat item
  Future<void> toggleRepairStatus(MarmatModel marmatModel) async {
    // Toggle the isRepaired field
    bool newIsRepaired = !marmatModel.isRepaired;

    // Update the model with the new isRepaired value
    MarmatModel updatedMarmatModel = MarmatModel(
      id: marmatModel.id,
      product: marmatModel.product,
      repairRequirements: marmatModel.repairRequirements,
      paidAmount: marmatModel.paidAmount,
      remainingAmount: marmatModel.remainingAmount,
      customerName: marmatModel.customerName,
      note: marmatModel.note,
      isRepaired: newIsRepaired, // Update the bool
    );

    // Update Firestore with the new value
    await FirebaseFirestore.instance
        .collection('marmat')
        .doc(updatedMarmatModel.id)
        .update(updatedMarmatModel.toMap());

    // Emit updated state if needed
    // You can emit a new state to update the UI here
  }
   @override
  Future<void> close() {
    _marmatSubscription?.cancel(); // Cancel the stream subscription
    return super.close();
  }
}
