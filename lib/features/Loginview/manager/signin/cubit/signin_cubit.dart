import 'dart:ui';

import 'package:aldafttar/features/Loginview/manager/signin/cubit/signin_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
        errorMessage = 'المستخدم غير موجود';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'كلمة المرور غير صحيحة';
      } else if (e.message?.contains('The supplied auth credential is incorrect') ?? false) {
        errorMessage = 'البيانات المدخلة غير صحيحة';
      } else {
        errorMessage = e.message != null
            ? 'خطأ حدث أثناء تسجيل الدخول: ${e.message}'
            : 'فشل تسجيل الدخول';
      }
      emit(SigninState(errorMessage: errorMessage)); // Emit failure state
    } catch (e) {
      emit(const SigninState(errorMessage: 'حدث خطأ أثناء تسجيل الدخول'));
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
