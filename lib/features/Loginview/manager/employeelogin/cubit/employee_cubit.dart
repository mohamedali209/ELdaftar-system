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
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

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
          final userDoc =
              await _firestore.collection('users').doc(shopId).get();

          if (userDoc.exists) {
            debugPrint('Login succeeded!');
            emit(EmployeeSuccess(role)); // Emit success state
          } else {
            emit(const EmployeeFailure("لم يتم العثور على بيانات المستخدم لهذا المتجر."));
          }
        } else {
          emit(const EmployeeFailure("البريد الإلكتروني أو كلمة المرور غير صحيحة."));
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'المستخدم غير موجود.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'كلمة المرور غير صحيحة.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'تم حظر الحساب مؤقتًا بسبب محاولات تسجيل دخول كثيرة. حاول مرة أخرى لاحقًا.';
      } else if (e.message?.contains('The supplied auth credential is incorrect') ?? false) {
        errorMessage = 'البيانات المدخلة غير صحيحة.';
      } else {
        errorMessage = e.message != null
            ? 'حدث خطأ أثناء تسجيل الدخول: ${e.message}'
            : 'فشل تسجيل الدخول.';
      }
      emit(EmployeeFailure(errorMessage));
    } catch (e) {
      emit(const EmployeeFailure("حدث خطأ أثناء تسجيل الدخول."));
    }
  }
}
