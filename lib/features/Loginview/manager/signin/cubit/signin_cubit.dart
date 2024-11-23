import 'dart:ui';

import 'package:aldafttar/features/Loginview/manager/signin/cubit/signin_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninCubit extends Cubit<SigninState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SigninCubit() : super(const SigninState());

  // Function to handle sign-in logic
  Future<void> signin({
    required String email,
    required String password,
  }) async {
    emit(const SigninState(isLoading: true)); // Start loading

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(const SigninState(isSuccess: true)); // Emit success state
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password';
      } else {
        errorMessage = e.message ?? 'Sign-in failed';
      }
      emit(SigninState(errorMessage: errorMessage)); // Emit failure state
    } catch (e) {
      emit(const SigninState(errorMessage: 'An error occurred during sign-in'));
    }
  }

  // Function to check if the user is already signed in
  Future<void> checkIfSignedIn(VoidCallback onSignedIn) async {
    emit(const SigninState(isLoading: true)); // Set loading to true
    final user = _auth.currentUser;
    if (user != null) {
      emit(const SigninState(isSuccess: true)); // User already signed in
      onSignedIn(); // Call the callback function
    } else {
      emit(const SigninState(isSuccess: false)); // User not signed in
    }
  }
}
