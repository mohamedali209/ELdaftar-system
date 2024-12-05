import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AddEmployeeCubit extends Cubit<AddEmployeecubitState> {
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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's unique ID
      String uid = userCredential.user!.uid;

      // Add employee data to Firestore with the user's UID as the document ID
      await _firestore.collection('employees').doc(uid).set({
        'name': name,
        'email': email,
        'shopId': shopId,
        'role': role,
      });

      // Add the employee document to the 'employees' subcollection within 'users/{shopId}'
      await _firestore
          .collection('users')
          .doc(shopId)
          .collection('employees')
          .doc(uid)
          .set({
        'uid': uid,
        'name': name,
        'email': email,
        'role': role,
      });

      emit(AddEmployeeSuccess());
    } catch (e) {
      emit(AddEmployeeError('Failed to add employee: ${e.toString()}'));
    }
  }

  Future<void> fetchEmployees(String shopId) async {
    emit(AddEmployeeLoading());

    try {
      // Fetch all employee documents from the 'employees' subcollection
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(shopId)
          .collection('employees')
          .get();

      // Map each document in the subcollection to a list of employee maps
      List<Map<String, dynamic>> employees = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      emit(AddEmployeeLoaded(employees));
    } catch (e) {
      emit(AddEmployeeError('Failed to fetch employees: ${e.toString()}'));
    }
  }

  Future<void> deleteEmployee(String shopId, String uid) async {
    emit(AddEmployeeLoading());
    try {
      // First, delete the employee document from the 'employees' collection
      await _firestore.collection('employees').doc(uid).delete();
      await _firestore
          .collection('users')
          .doc(shopId)
          .collection('employees')
          .doc(uid)
          .delete();
      emit(AddEmployeeSuccess());
    } catch (e) {
      emit(AddEmployeeError('Failed to delete employee: ${e.toString()}'));
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
