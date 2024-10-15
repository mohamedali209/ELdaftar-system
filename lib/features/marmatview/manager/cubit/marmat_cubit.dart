import 'dart:async';

import 'package:aldafttar/features/marmatview/manager/cubit/marmat_state.dart';
import 'package:aldafttar/features/marmatview/model/marmat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import FirebaseAuth
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarmatCubit extends Cubit<MarmatState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth _auth = FirebaseAuth.instance;  // FirebaseAuth instance
  StreamSubscription? _marmatSubscription; // Stream subscription variable
  
  MarmatCubit({required this.firestore}) : super(MarmatInitial());

  // Stream to fetch and listen to real-time changes in the current user's marmat collection
  void streamMarmatItems() {
    emit(MarmatLoading());

    try {
      // Get the current user's userId
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Stream the 'marmat' collection for the logged-in user
        _marmatSubscription = firestore
            .collection('users')
            .doc(userId)  // Access the user's document
            .collection('marmat')
            .snapshots()
            .listen(
          (querySnapshot) {
            final items = querySnapshot.docs.map((doc) {
              return MarmatModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            }).toList();

            if (!isClosed) {
              emit(MarmatLoaded(items: items));  // Emit the loaded items
            }
          },
          onError: (error) {
            if (!isClosed) {
              emit(MarmatError(message: error.toString()));
            }
            print('Error fetching Marmat items: $error');
          },
        );
      } else {
        emit(MarmatError(message: 'User not logged in'));
      }
    } catch (e) {
      if (!isClosed) {
        emit(MarmatError(message: e.toString()));
      }
    }
  }

  // Method to add a new Marmat item for the current user
  Future<void> addMarmatItem(MarmatModel marmatModel) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Automatically generate a new document ID in the user's 'marmat' collection
        final docRef = firestore.collection('users')
            .doc(userId)
            .collection('marmat')
            .doc();
            
        await docRef.set(marmatModel.toMap());
      } else {
        emit(MarmatError(message: 'User not logged in'));
      }
    } catch (e) {
      emit(MarmatError(message: 'Error adding Marmat item: $e'));
      if (kDebugMode) {
        print('Error adding Marmat item: $e');
      }
    }
  }

  // Method to update an existing Marmat item for the current user
  Future<void> updateMarmatItem(MarmatModel marmatModel) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        await firestore
            .collection('users')
            .doc(userId)
            .collection('marmat')
            .doc(marmatModel.id)
            .update(marmatModel.toMap());
      } else {
        emit(MarmatError(message: 'User not logged in'));
      }
    } catch (e) {
      emit(MarmatError(message: 'Error updating Marmat item: $e'));
      if (kDebugMode) {
        print('Error updating Marmat item: $e');
      }
    }
  }

  // Method to delete a Marmat item for the current user
  Future<void> deleteMarmatItem(String documentId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        await firestore
            .collection('users')
            .doc(userId)
            .collection('marmat')
            .doc(documentId)
            .delete();
      } else {
        emit(MarmatError(message: 'User not logged in'));
      }
    } catch (e) {
      emit(MarmatError(message: 'Error deleting Marmat item: $e'));
      if (kDebugMode) {
        print('Error deleting Marmat item: $e');
      }
    }
  }

  // Method to toggle the repair status of a Marmat item
  Future<void> toggleRepairStatus(MarmatModel marmatModel) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

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
        await firestore
            .collection('users')
            .doc(userId)
            .collection('marmat')
            .doc(updatedMarmatModel.id)
            .update(updatedMarmatModel.toMap());
      } else {
        emit(MarmatError(message: 'User not logged in'));
      }
    } catch (e) {
      emit(MarmatError(message: 'Error toggling repair status: $e'));
      if (kDebugMode) {
        print('Error toggling repair status: $e');
      }
    }
  }

  @override
  Future<void> close() {
    _marmatSubscription?.cancel();  // Cancel the stream subscription
    return super.close();
  }
}
