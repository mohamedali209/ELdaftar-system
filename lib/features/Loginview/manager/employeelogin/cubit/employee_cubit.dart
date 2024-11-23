import 'package:aldafttar/features/Loginview/manager/employeelogin/cubit/employee_state.dart';
import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  EmployeeCubit()
      : _auth = ServiceLocator().auth,
        _firestore = ServiceLocator().firestore,
        super(EmployeeInitial());

  Future<void> loginEmployee(String email, String password) async {
    emit(EmployeeLoading()); // Emit loading state

    try {
      // Sign in the user with FirebaseAuth
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Query Firestore for employee document
        final querySnapshot = await _firestore
            .collection('employees')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final employeeData = querySnapshot.docs.first.data();
          final String role = employeeData['role'];
          final String shopId = employeeData['shopId'];

          // Query users collection with shopId
          final userDoc = await _firestore.collection('users').doc(shopId).get();

          if (userDoc.exists) {
            debugPrint('Login succeeded!');
            emit(EmployeeSuccess(role)); // Emit success state
          } else {
            emit(const EmployeeFailure("No user data found for this shop ID."));
          }
        } else {
          emit(const EmployeeFailure("Invalid email or password."));
        }
      }
    } catch (e) {
      emit(EmployeeFailure("Login failed: ${e.toString()}")); // Emit failure state
    }
  }
}
