import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'addemployee_state.dart';

class AddEmployeeCubit extends Cubit<AddEmployeeState> {
  final FirebaseFirestore _firestore = ServiceLocator().firestore;
  final FirebaseAuth _auth = ServiceLocator().auth;

  AddEmployeeCubit() : super(AddEmployeeInitial());

  Future<void> addEmployee({
    required String name,
    required String email,
    required String password,
    required String role,
    required String shopId,
  }) async {
    emit(AddEmployeeLoading());

    try {
      // Create a Firebase Auth user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's unique ID
      String uid = userCredential.user!.uid;

      // Add employee data to Firestore with the user's UID as shopId
      await _firestore.collection('employees').doc(uid).set({
        'name': name,
        'email': email,
        'password': password,
        'shopId': shopId, // Using the user's UID as shopId
        'role': role,
      });

      emit(AddEmployeeSuccess());
    } catch (e) {
      emit(AddEmployeeError('Failed to add employee: ${e.toString()}'));
    }
  }
}


class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  // Private constructor
  ServiceLocator._internal();

  // Factory constructor to return the singleton instance
  factory ServiceLocator() {
    return _instance;
  }

  // Service instances
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  // Getter for FirebaseAuth
  FirebaseAuth get auth {
    _auth ??= FirebaseAuth.instance;
    return _auth!;
  }

  // Getter for FirebaseFirestore
  FirebaseFirestore get firestore {
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!;
  }
}
