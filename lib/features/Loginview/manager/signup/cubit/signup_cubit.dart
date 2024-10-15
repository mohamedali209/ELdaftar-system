import 'package:aldafttar/features/Loginview/manager/signup/cubit/signup_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignupCubit() : super(SignupState());

  // Function to handle signup logic
  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required String storeName,
    required String phone,
  }) async {
    emit(SignupState(isLoading: true));

    try {
      // Sign up with Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String userId = userCredential.user?.uid ?? '';

      // Create the main collection with the store name
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'storeName': storeName,
        'phone': phone,
        'email': email,
        'createdAt': DateTime.now(),
      });

      // Create subcollections for the user within the store-named collection
      await _createSubcollections('users', userId);

      emit(SignupState(isSuccess: true));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(SignupState(errorMessage: 'The email address is already in use.'));
      } else {
        emit(SignupState(errorMessage: e.toString()));
      }
    } catch (e) {
      // Emit a general error state for any other exceptions
      emit(SignupState(errorMessage: e.toString()));
    }
  }

  // Helper function to create subcollections for the user
  Future<void> _createSubcollections(String storeName, String userId) async {
    // Create empty subcollections under the store-named collection
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('dailyTransactions')
        .doc('init')
        .set({});
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('suppliers')
        .doc('init')
        .set({});
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('marmat')
        .doc('init')
        .set({});
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('totals')
        .doc('init')
        .set({});
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .doc('init')
        .set({});
  }
}
