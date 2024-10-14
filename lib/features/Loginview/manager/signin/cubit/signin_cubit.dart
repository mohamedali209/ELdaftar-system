import 'dart:ui';

import 'package:aldafttar/features/Loginview/manager/signin/cubit/signin_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninCubit extends Cubit<SigninState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SigninCubit() : super(SigninState());

  // Function to handle sign-in logic
  Future<void> signin({
    required String email,
    required String password,
  }) async {
    emit(SigninState(isLoading: true)); // Start loading

    try {
      // Firebase Authentication sign-in
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(SigninState(isSuccess: true)); // On success
    } on FirebaseAuthException catch (e) {
      // Handle different error codes
      if (e.code == 'user-not-found') {
        emit(SigninState(errorMessage: 'User not found'));
      } else if (e.code == 'wrong-password') {
        emit(SigninState(errorMessage: 'Incorrect password'));
      } else {
        emit(SigninState(errorMessage: e.message ?? 'Sign-in failed'));
      }
    } catch (e) {
      emit(SigninState(errorMessage: 'An error occurred during sign-in'));
    }
  }

  // Function to check if the user is already signed in
  Future<void> checkIfSignedIn(VoidCallback onSignedIn) async {
    emit(SigninState(isLoading: true)); // Set loading to true
    final user = _auth.currentUser;
    if (user != null) {
      emit(SigninState(isSuccess: true)); // User already signed in
      onSignedIn(); // Call the callback function
    } else {
      emit(SigninState(isSuccess: false)); // User not signed in
    }
  }
}
