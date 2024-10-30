import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeCubit extends Cubit<String?> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // Constructor with no parameters, fetching dependencies from ServiceLocator
  EmployeeCubit()
      : _auth = ServiceLocator().auth,
        _firestore = ServiceLocator().firestore,
        super(null);

  Future<void> loginEmployee(String email, String password) async {
    try {
      // Sign in the user with FirebaseAuth
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Now, query Firestore to find an employee document matching email
        final querySnapshot = await _firestore
            .collection('employees')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final employeeData = querySnapshot.docs.first.data();
          final String role = employeeData['role'];
          final String shopId = employeeData['shopId'];

          // Print the shopId to the console
          debugPrint('Shop ID: $shopId');

          // Use shopId to query the users collection
          final userDoc = await _firestore.collection('users').doc(shopId).get();

          if (userDoc.exists) {
            // Print "succeeded" after successful login
            debugPrint('Login succeeded!');
            emit(role); // Emit the employee role for navigation
          } else {
            emit("No user data found for this shop ID.");
          }
        } else {
          emit("Invalid email or password.");
        }
      }
    } catch (e) {
      emit("Login failed: ${e.toString()}");
    }
  }
}
