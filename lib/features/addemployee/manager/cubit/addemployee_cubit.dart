import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployeeCubit extends Cubit<AddEmployeeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AddEmployeeCubit() : super(AddEmployeeInitial());

 Future<void> addEmployee(String name, String email, String password) async {
  emit(AddEmployeeLoading());

  try {
    // Get the current primary user's ID
    String ownerId = _auth.currentUser!.uid;

    // Create a new user for the employee
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String employeeId = userCredential.user!.uid;

    // Prepare the employee data
    Map<String, dynamic> employeeData = {
      'name': name,
      'email': email,
      'password': password,
      'role': 'employee', // Define roles as needed
      'employeeId': employeeId, // Store employee ID if needed
    };

    // Store employee data in the primary user's document
    await _firestore.collection('users').doc(ownerId).set({
      'employees': FieldValue.arrayUnion([employeeData]), // Add employee data to the employees array
    }, SetOptions(merge: true));

    emit(AddEmployeeSuccess());
  } on FirebaseAuthException catch (e) {
    emit(AddEmployeeError(e.message ?? 'خطأ في إضافة الموظف'));
  } catch (e) {
    emit(AddEmployeeError('حدث خطأ غير متوقع'));
  }
}

}
